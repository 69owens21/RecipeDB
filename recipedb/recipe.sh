#!/bin/bash

PSQL="psql -X --username=postgres --dbname=recipes --tuples-only -c"

MAIN_MENU()
{
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
    *) echo -e "\nInvalid option. Please try again." ;;
  esac
}

ADD_RECIPE() {
    echo -e "\nEnter the recipe name:"
    read RECIPE_NAME
    ADD_RECIPE_RESULT=$($PSQL "INSERT INTO recipes(name) VALUES('$RECIPE_NAME')");
    if [[ $ADD_RECIPE_RESULT == "INSERT 0 1" ]]; then
        echo -e "\nRecipe added successfully!"
    else
        echo -e "\nFailed to add recipe. Please try again."
    fi
    echo -e "Enter the ingredients (comma-separated):"
    read INGREDIENTS
    RECIPE_ID=$($PSQL "SELECT recipe_id FROM recipes WHERE name='$RECIPE_NAME'");
    IFS=',' read -ra INGREDIENT_ARRAY <<< "$INGREDIENTS"
    for INGREDIENT in "${INGREDIENT_ARRAY[@]}"; do
        ADD_INGREDIENT_RESULT=$($PSQL "INSERT INTO ingredients(recipe_id, ingredient) VALUES($RECIPE_ID, '$INGREDIENT')");
        if [[ $ADD_INGREDIENT_RESULT == "INSERT 0 1" ]]; then
            echo -e "\nIngredient '$INGREDIENT' added successfully!"
        else
            echo -e "\nFailed to add ingredient '$INGREDIENT'. Please try again."
        fi
    done
echo -e "\nEnter the recipe steps (separated by semicolons):"
read STEPS
IFS=';' read -ra STEPS_ARRAY <<< "$STEPS"

for i in "${!STEPS_ARRAY[@]}"; do
    
    STEP_NUMBER=$((i + 1))
    
    STEP=$(echo "${STEPS_ARRAY[$i]}" | xargs)
    
    SAFE_STEP="${STEP//\'/\'\'}"

    ADD_STEP_RESULT=$($PSQL "INSERT INTO recipe_steps(recipe_id, step_number, instruction) VALUES($RECIPE_ID, $STEP_NUMBER, '$SAFE_STEP')")
    
    if [[ $ADD_STEP_RESULT == "INSERT 0 1" ]]; then
        echo -e "\nStep $STEP_NUMBER added successfully!"
    else
        echo -e "\nFailed to add step $STEP_NUMBER ('$STEP'). Please try again."
    fi
done