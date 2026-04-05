#!/bin/bash

# Database connection variable
PSQL="psql -X --username=postgres --dbname=recipes --tuples-only -c"

MAIN_MENU() {
  echo -e "\nWelcome to the recipe database! What would you like to do?"
  echo -e "1) Add a new recipe"
  echo -e "2) View all recipes"
  echo -e "3) Search for a recipe by name"
  echo -e "4) Exit"
  read MAIN_MENU_SELECTION

  case $MAIN_MENU_SELECTION in
    1) ADD_RECIPE ;;
    2) VIEW_RECIPES ;;
    3) SEARCH_RECIPE ;;
    4) exit ;;
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
        # Escape single quotes (for things like Tony's)
        SAFE_INGREDIENT="${CLEAN_INGREDIENT//\'/\'\'}"
        
        $PSQL "INSERT INTO ingredients(name) VALUES('$SAFE_INGREDIENT')" > /dev/null 2>&1
        INGREDIENT_ID=$($PSQL "SELECT ingredient_id FROM ingredients WHERE name='$SAFE_INGREDIENT'" | xargs)
        
        # FIXED: Removed the extra closing parenthesis here
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
    SHOW_RECIPES=$($PSQL "SELECT title FROM recipes")
    if [[ -z $(echo "$SHOW_RECIPES" | xargs) ]]; then
        echo -e "\nThe database is currently empty."
    else
        echo -e "\nRecipes in the database:"
        echo "$SHOW_RECIPES"
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
        echo -e "\nRecipe not found. Please check your spelling."
        SEARCH_RECIPE_MENU
        return
    fi
    
    echo -e "\n--- $DETAIL_NAME ---"
    echo -e "\nIngredients:"
    $PSQL "SELECT i.name FROM ingredients i JOIN recipe_ingredients ri ON i.ingredient_id = ri.ingredient_id WHERE ri.recipe_id = $RECIPE_ID"
    
    echo -e "\nSteps:"
    $PSQL "SELECT step_number, instruction FROM recipe_steps WHERE recipe_id = $RECIPE_ID ORDER BY step_number"
    
    echo -e "\nServing size:"
    SERVING_SIZE=$($PSQL "SELECT servings FROM recipes WHERE recipe_id=$RECIPE_ID" | xargs)
    if [[ -n $SERVING_SIZE ]]; then
        echo "$SERVING_SIZE servings"
    else
        echo "Not specified"
    fi

    SEARCH_RECIPE_MENU
}

# Execute the program
MAIN_MENU