#!/bin/bash

# Database connection variable
PSQL="psql -X --username=postgres --dbname=recipes --tuples-only -c"

MAIN_MENU() {
  echo -e "\nWelcome to the recipe database! What would you like to do?"
  echo -e "1) Add a new recipe"
  echo -e "2) View all recipes"
  echo -e "3) Search for a recipe by name"
  echo -e "4) Calorie Tracker"
  echo -e "5) Exit"
  read MAIN_MENU_SELECTION

  case $MAIN_MENU_SELECTION in
    1) ADD_RECIPE ;;
    2) VIEW_RECIPES ;;
    3) SEARCH_RECIPE ;;
    4) CALORIE_TRACKER ;;
    5) exit ;;
    *) echo -e "\nInvalid option. Please try again." ; MAIN_MENU ;;
  esac
}

ADD_RECIPE() {
    echo -e "\nEnter the recipe name:"
    read RECIPE_NAME
    
    ADD_RECIPE_RESULT=$($PSQL "INSERT INTO recipes(title) VALUES('$RECIPE_NAME')")
    
    if [[ $ADD_RECIPE_RESULT == "INSERT 0 1" ]]; then
        echo -e "\nRecipe '$RECIPE_NAME' added successfully!"
    else
        echo -e "\nFailed to add recipe. Returning to menu."
        MAIN_MENU
        return
    fi

    RECIPE_ID=$($PSQL "SELECT recipe_id FROM recipes WHERE title='$RECIPE_NAME'" | xargs)

    echo -e "Enter the ingredients (comma-separated):"
    read INGREDIENTS
    IFS=',' read -ra INGREDIENT_ARRAY <<< "$INGREDIENTS"
    
    for INGREDIENT in "${INGREDIENT_ARRAY[@]}"; do
        CLEAN_INGREDIENT=$(echo "$INGREDIENT" | xargs)
        SAFE_INGREDIENT="${CLEAN_INGREDIENT//\'/\'\'}"
        
        $PSQL "INSERT INTO ingredients(name) VALUES('$SAFE_INGREDIENT')" > /dev/null 2>&1
        INGREDIENT_ID=$($PSQL "SELECT ingredient_id FROM ingredients WHERE name='$SAFE_INGREDIENT'" | xargs)
        $PSQL "INSERT INTO recipe_ingredients(recipe_id, ingredient_id) VALUES($RECIPE_ID, $INGREDIENT_ID)" > /dev/null 2>&1
    done

    echo -e "\nEnter the recipe steps (separated by semicolons):"
    read STEPS
    IFS=';' read -ra STEPS_ARRAY <<< "$STEPS"

    for i in "${!STEPS_ARRAY[@]}"; do
        STEP_NUMBER=$((i + 1))
        STEP=$(echo "${STEPS_ARRAY[$i]}" | xargs)
        SAFE_STEP="${STEP//\'/\'\'}"
        $PSQL "INSERT INTO recipe_steps(recipe_id, step_number, instruction) VALUES($RECIPE_ID, $STEP_NUMBER, '$SAFE_STEP')" > /dev/null 2>&1
    done

    echo -e "\nRecipe complete! Returning to menu..."
    MAIN_MENU
}

VIEW_RECIPES() {

    echo -e "\n1)View all recipes"
    echo -e "\n2)View recipes by category"
    echo -e "\n3)Return to main menu"
    read VIEW_RECIPES_MENU_SELECTION

    case $VIEW_RECIPES_MENU_SELECTION in
        1) VIEW_ALL_RECIPES ;;
        2) VIEW_RECIPES_BY_CATEGORY ;;
        3) MAIN_MENU ;;
        *) echo -e "\nInvalid option." ; VIEW_RECIPES ;;
    esac
}

VIEW_ALL_RECIPES() {

    SHOW_RECIPES=$($PSQL "SELECT title FROM recipes")
    if [[ -z $(echo "$SHOW_RECIPES" | xargs) ]]; then
        echo -e "\nThe database is currently empty."
    else
        echo -e "\nRecipes in the database:"
        echo "$SHOW_RECIPES"
    fi
    MAIN_MENU
}

#View recipes by category WIP
VIEW_RECIPES_BY_CATEGORY() {
  echo -e "\nEnter the category name:"
  read CAT_NAME
  
  RECIPES=$($PSQL "SELECT r.title FROM recipes r 
                   JOIN recipe_category_links rcl ON r.recipe_id = rcl.recipe_id 
                   JOIN recipe_categories rc ON rcl.cat_id = rc.cat_id 
                   WHERE rc.name ILIKE '$CAT_NAME'")

  if [[ -z $(echo "$RECIPES" | xargs) ]]; then
    echo -e "\nNo recipes found in '$CAT_NAME'."
  else
    echo -e "\nRecipes in $CAT_NAME:"
    echo "$RECIPES"
  fi
  MAIN_MENU
}

SEARCH_RECIPE() {
    echo -e "\nEnter the recipe name to search for:"
    read SEARCH_NAME
    SEARCH_RESULT=$($PSQL "SELECT title FROM recipes WHERE title ILIKE '%$SEARCH_NAME%'")
    
    if [[ -z $(echo "$SEARCH_RESULT" | xargs) ]]; then
        echo -e "\nNo recipes found matching '$SEARCH_NAME'."
        MAIN_MENU
    else
        echo -e "\nSearch results for '$SEARCH_NAME':"
        echo "$SEARCH_RESULT"
        SEARCH_RECIPE_MENU
    fi
}

SEARCH_RECIPE_MENU() {
    echo -e "\nWhat would you like to do next?"
    echo -e "1) View recipe details"
    echo -e "2) Return to main menu"
    read SEARCH_MENU_SELECTION

    case $SEARCH_MENU_SELECTION in
        1) VIEW_RECIPE_DETAILS ;;
        2) MAIN_MENU ;;
        *) echo -e "\nInvalid option." ; SEARCH_RECIPE_MENU ;;
    esac
}

VIEW_RECIPE_DETAILS() {
    echo -e "\nEnter the exact recipe name to view details:"
    read DETAIL_NAME
    RECIPE_ID=$($PSQL "SELECT recipe_id FROM recipes WHERE title='$DETAIL_NAME'" | xargs)
    
    if [[ -z $RECIPE_ID ]]; then
        echo -e "\nRecipe not found. Returning to search menu."
        SEARCH_RECIPE_MENU
        return
    fi
    
    echo -e "\n--- $DETAIL_NAME ---"
    
    echo -e "\nIngredients:"
    $PSQL "SELECT i.name FROM ingredients i JOIN recipe_ingredients ri ON i.ingredient_id = ri.ingredient_id WHERE ri.recipe_id = $RECIPE_ID"
    
    echo -e "\nSteps:"
    $PSQL "SELECT step_number, instruction FROM recipe_steps WHERE recipe_id = $RECIPE_ID ORDER BY step_number"
    
    echo -e "\nServing size:"
    # Using COALESCE to provide a fallback if the result is NULL
    SERVING_SIZE=$($PSQL "SELECT COALESCE(CAST(servings AS TEXT), 'Not specified') FROM recipes WHERE recipe_id=$RECIPE_ID" | xargs)
    echo "$SERVING_SIZE"

    echo -e "\nTotal Calories:"
    # Updated query to only select the SUM so xargs captures a single number
    CALORIES=$($PSQL "SELECT SUM(ri.quantity * i.calories_per_base_unit) FROM recipes r JOIN recipe_ingredients ri ON r.recipe_id = ri.recipe_id JOIN ingredients i ON ri.ingredient_id = i.ingredient_id WHERE r.recipe_id = $RECIPE_ID" | xargs)
    
    if [[ -z $CALORIES || $CALORIES == "NULL" ]]; then
        echo "Calorie data incomplete for this recipe."
    else
        echo "$CALORIES calories"
    fi

    echo -e "\nPrepare Time:"
    PREP_TIME=$($PSQL "SELECT prep_time_minutes FROM recipes WHERE recipe_id=$RECIPE_ID")
    if [[ -z $PREP_TIME || $PREP_TIME == "NULL" ]]; then
        echo "Preparation time not specified."
    else
        echo "$PREP_TIME minutes"
    fi

    echo -e "\nCook Time:"
    COOK_TIME=$($PSQL "SELECT cook_time_minutes FROM recipes WHERE recipe_id=$RECIPE_ID")
    if [[ -z $COOK_TIME || $COOK_TIME == "NULL" ]]; then
        echo "Cook time not specified."
    else
        echo "$COOK_TIME minutes"
    fi


    SEARCH_RECIPE_MENU
}

CALORIE_TRACKER_SETUP() {
    # $1 is the USER_ID passed from the caller
    LOCAL_USER_ID=$1

    echo -e "\nEnter your weight in lbs:"
    read WEIGHT
    echo -e "\nEnter your age in years:"
    read AGE
    echo -e "\nEnter your height in inches:"
    read HEIGHT
    echo -e "\nEnter your gender (M/F):"
    read GENDER
    echo -e "Enter your activity level (1.2=Sedentary, 1.5=Moderate, 1.9=Very Active):"
    read ACTIVITY_LEVEL

    # Calculate BMR using bc
    if [[ $GENDER == "M" ]]; then
        BMR=$(echo "66 + (6.23 * $WEIGHT) + (12.7 * $HEIGHT) - (6.8 * $AGE)" | bc -l)
    else
        BMR=$(echo "655 + (4.35 * $WEIGHT) + (4.7 * $HEIGHT) - (4.7 * $AGE)" | bc -l)
    fi

    DAILY_LIMIT=$(echo "$BMR * $ACTIVITY_LEVEL" | bc -l)

    INSERT_RESULT=$($PSQL "INSERT INTO calorie_limits(user_id, weight, height, age, gender, activity_level, daily_calorie_limit) VALUES ($LOCAL_USER_ID, $WEIGHT, $HEIGHT, $AGE, '$GENDER', '$ACTIVITY_LEVEL', $DAILY_LIMIT)")

    if [[ $INSERT_RESULT == "INSERT 0 1" ]]; then
        printf "\nSetup complete! Your daily limit is: %.2f calories.\n" "$DAILY_LIMIT"
    else
        echo -e "\nFailed to save settings."
    fi
}

CALORIE_TRACKER() {
    echo -e "\nEnter your username:"
    read USERNAME
    
    # Check if user exists
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'" | xargs)
    
    if [[ -z $USER_ID ]]; then
        echo -e "\nUser not found. Create account? (y/n)"
        read CREATE_USER
        if [[ $CREATE_USER == "y" ]]; then
            # Insert and then IMMEDIATELY fetch the new ID
            $PSQL "INSERT INTO users(username) VALUES ('$USERNAME')"
            USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'" | xargs)
            
            if [[ -z $USER_ID ]]; then
                echo "Error: Could not create user. Check your database connection."
                MAIN_MENU; return
            fi
            
            echo "Account created for $USERNAME!"
            CALORIE_TRACKER_SETUP "$USER_ID"
        else
            MAIN_MENU; return
        fi
    else
        echo -e "\nWelcome back, $USERNAME!"
    fi

    CALORIES_LEFT "$USER_ID"


    

}

CALORIES_LEFT() {
    USER_ID=$1
  
  # Calculate remaining calories
  VAL=$($PSQL "SELECT cl.daily_calorie_limit - COALESCE(SUM(di.calories), 0) 
               FROM calorie_limits cl 
               LEFT JOIN daily_intake di ON cl.user_id = di.user_id AND di.log_date = CURRENT_DATE 
               WHERE cl.user_id = $USER_ID 
               GROUP BY cl.daily_calorie_limit" | xargs)

  if [[ -z $VAL || $VAL == "NULL" ]]; then
    echo -e "\nNo calorie limit set. Please run setup."
  else
    printf "\nYou have %.2f calories left for today.\n" "$VAL"
  fi
}


# Execute the program
MAIN_MENU