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

##  Database Schema

The database is normalized to 3NF to prevent data redundancy and ensure mathematical accuracy when calculating nutrition. 

1. **`recipes`**: Stores high-level meal details (`title`, `prep_time_minutes`, `cook_time_minutes`, `servings`).
2. **`ingredients`**: A dictionary table storing raw items (`name`, `calories_per_base_unit`, `base_unit`).
3. **`recipe_ingredients`**: The junction/bridge table linking a recipe to its ingredients, storing the specific `quantity` used.
4. **`recipe_steps`**: Stores the sequential instructions for a given recipe, linked by `recipe_id` and ordered by `step_number`.

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
