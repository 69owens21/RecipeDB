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
    # 1. Get and Insert Recipe Title
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

    # 2. Get the new Recipe ID (using xargs to trim spaces)
    RECIPE_ID=$($PSQL "SELECT recipe_id FROM recipes WHERE title='$RECIPE_NAME'" | xargs)

    # 3. Handle Ingredients
    echo -e "\nEnter the ingredients (comma-separated):"
    read INGREDIENTS
    IFS=',' read -ra INGREDIENT_ARRAY <<< "$INGREDIENTS"
    
    for INGREDIENT in "${INGREDIENT_ARRAY[@]}"; do
        # Trim whitespace
        CLEAN_INGREDIENT=$(echo "$INGREDIENT" | xargs)
        
        # Insert into ingredients dictionary (ignore if already exists)
        $PSQL "INSERT INTO ingredients(name) VALUES('$CLEAN_INGREDIENT')" > /dev/null 2>&1
        
        # Get the Ingredient ID
        INGREDIENT_ID=$($PSQL "SELECT ingredient_id FROM ingredients WHERE name='$CLEAN_INGREDIENT'" | xargs)
        
        # Link to the recipe in the junction table
        ADD_LINK_RESULT=$($PSQL "INSERT INTO recipe_ingredients(recipe_id, ingredient_id) VALUES($RECIPE_ID, $INGREDIENT_ID)")
        
        if [[ $ADD_LINK_RESULT == "INSERT 0 1" ]]; then
            echo -e "Ingredient '$CLEAN_INGREDIENT' linked."
        fi
    done

    # 4. Handle Recipe Steps
    echo -e "\nEnter the recipe steps (separated by semicolons):"
    read STEPS
    IFS=';' read -ra STEPS_ARRAY <<< "$STEPS"

    for i in "${!STEPS_ARRAY[@]}"; do
        STEP_NUMBER=$((i + 1))
        STEP=$(echo "${STEPS_ARRAY[$i]}" | xargs)
        
        # Sanitize single quotes for SQL
        SAFE_STEP="${STEP//\'/\'\'}"

        ADD_STEP_RESULT=$($PSQL "INSERT INTO recipe_steps(recipe_id, step_number, instruction) VALUES($RECIPE_ID, $STEP_NUMBER, '$SAFE_STEP')")
        
        if [[ $ADD_STEP_RESULT == "INSERT 0 1" ]]; then
            echo -e "Step $STEP_NUMBER added."
        fi
    done

    # Return to menu when finished
    MAIN_MENU
}

# Placeholder functions to prevent crashes
VIEW_RECIPES() {
    SHOW_RECIPES=$($PSQL "SELECT title FROM recipes")
    echo -e "\nRecipes in the database:\n$SHOW_RECIPES"
    MAIN_MENU
}

SEARCH_RECIPE() {
    echo -e "\nSearch Recipe logic coming soon!"
    MAIN_MENU
}

# Execute the program
MAIN_MENU