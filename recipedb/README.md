# Dynamic Recipe & Nutrition Database

A robust Command Line Interface (CLI) application built with Bash and PostgreSQL. This system provides a centralized, scalable platform for managing recipes, tracking ingredient usage, and automatically calculating nutritional information using a normalized relational database.

This project was developed for CS 361 / MIS 361: Database System Design.

##  Features

* **Interactive CLI Interface:** A user-friendly terminal menu for seamless navigation.
* **Dynamic Calorie Calculation:** Calculates total meal calories on-the-fly using relational `JOIN` statements and aggregate functions rather than hardcoded values.
* **Fuzzy Searching:** Users can search for recipes using partial and case-insensitive matches.
* **Relational Data Mapping:** Utilizes a junction table to handle the many-to-many relationship between recipes and ingredients.
* **Input Sanitization:** Automatically parses arrays and escapes special characters (e.g., apostrophes in "Tony's Seasoning") to prevent SQL syntax errors.
* **Collision Handling:** Uses `ON CONFLICT DO NOTHING` logic for smooth, error-free data entry and bulk importing.
*User Profiles & Authentication: Support for multiple users with unique usernames and personalized settings.
Personalized Calorie Tracker: Calculates a user's Basal Metabolic Rate (BMR) based on weight, height, age, and activity level to set a daily calorie goal.
*Daily Intake Logging: Real-time tracking of consumed calories against the daily limit with "Calories Remaining" logic.
*Multi-Category Classification: Utilizes a junction table to allow recipes to belong to multiple categories (e.g., "Beef" and "Pasta").
*Advanced SQL Aggregation: Complex JOIN and SUM logic to calculate daily remaining calories by subtracting daily_intake from calorie_limits.

## Database Schema

The database is normalized to 3NF to prevent data redundancy and ensure mathematical accuracy when calculating nutrition. 

1. **`recipes`**: Stores high-level meal details (`title`, `prep_time_minutes`, `cook_time_minutes`, `servings`).
2. **`ingredients`**: A dictionary table storing raw items (`name`, `calories_per_base_unit`, `base_unit`).
3. **`recipe_ingredients`**: The junction/bridge table linking a recipe to its ingredients, storing the specific `quantity` used.
4. **`recipe_steps`**: Stores the sequential instructions for a given recipe, linked by `recipe_id` and ordered by `step_number`.
The database has been expanded to support user-specific data and many-to-many categorization:
5. users: Stores user credentials and unique profile IDs.
6. calorie_limits: Stores physical metrics (weight, age, height) and the calculated daily_calorie_limit.
7.daily_intake: A transaction table logging calories consumed by a specific user_id on a specific log_date.=
8.recipe_categories: A dictionary of meal types (Poultry, Vegan, Breakfast, etc.).
9.recipe_category_links: A junction table mapping recipes to recipe_categories to allow for multi-tagging.

##  Prerequisites

To run this application locally, you will need:
* **PostgreSQL** installed and running on your machine.
* A PostgreSQL user named `postgres`.
* **Bash** terminal (macOS/Linux standard, or Git Bash/WSL on Windows).





##  Installation & Setup

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/YOUR-USERNAME/recipedb.git](https://github.com/YOUR-USERNAME/recipedb.git)
   cd recipedb

   ### Database Initialization
If you are setting this up for the first time, create the database and import the schema/data:
```bash
createdb recipes
psql --username=postgres --dbname=recipes < recipe.sql