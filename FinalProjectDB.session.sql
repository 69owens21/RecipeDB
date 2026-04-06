-- Recipe Database

-- Create the recipes table
CREATE TABLE recipes (
    recipe_id SERIAL PRIMARY KEY,
    title VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    prep_time_minutes INT,
    cook_time_minutes INT,
    servings INT);

-- Create ingredients table
CREATE TABLE ingredients (
    ingredient_id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    calories_per_base_unit DECIMAL,
    base_unit VARCHAR(50)
);

-- Create recipe_ingredients table to link recipes and ingredients
CREATE TABLE recipe_ingredients (
    recipe_id INT REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    ingredient_id INT REFERENCES ingredients(ingredient_id) ON DELETE CASCADE,
    quantity DECIMAL,
    unit_used VARCHAR(50),
    PRIMARY KEY (recipe_id, ingredient_id)
);

-- Create recipe_steps table to store the steps for each recipe
CREATE TABLE recipe_steps (
    step_id SERIAL PRIMARY KEY,
    recipe_id INT REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    step_number INT,
    instruction TEXT    
);

-- Insert sample data into recipes table
INSERT INTO recipes (title, description, prep_time_minutes, cook_time_minutes, servings) VALUES
('Spaghetti Bolognese', 'A classic Italian pasta dish with a rich meat sauce.', 15, 60, 4),
('Chicken Curry', 'A flavorful curry dish with tender chicken pieces.', 20, 40, 4),
('Vegetable Stir Fry', 'A quick and healthy stir fry with fresh vegetables.', 10, 15, 2); 

-- Insert sample data into ingredients table
INSERT INTO ingredients (name, calories_per_base_unit, base_unit) VALUES
('Spaghetti', 200, '100g'),
('Ground Beef', 250, '100g'),
('Tomato Sauce', 80, '100g'),
('Chicken Breast', 165, '100g'),
('Curry Powder', 50, '1 tbsp'),
('Mixed Vegetables', 50, '100g');   

-- Insert sample data into recipe_ingredients table
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit_used) VALUES
(1, 1, 200, 'g'),
(1, 2, 300, 'g'),   
(1, 3, 150, 'g'),
(2, 4, 400, 'g'),
(2, 5, 2, 'tbsp'),
(3, 6, 300, 'g');

-- Insert sample data into recipe_steps table
INSERT INTO recipe_steps (recipe_id, step_number, instruction) VALUES
(1, 1, 'Cook spaghetti according to package instructions.'),
(1, 2, 'In a separate pan, cook ground beef until browned.'),
(1, 3, 'Add tomato sauce to the beef and simmer for 20 minutes.'),
(1, 4, 'Serve the sauce over the cooked spaghetti.'),
(2, 1, 'Cook chicken breast in a pan until fully cooked.'),
(2, 2, 'Add curry powder and cook for another minute.'),
(2, 3, 'Add water and simmer for 20 minutes.'),
(2, 4, 'Serve with rice.'),
(3, 1, 'Heat oil in a pan and add mixed vegetables.'),
(3, 2, 'Stir fry for 5-7 minutes until vegetables are tender.'),
(3, 3, 'Serve with noodles or rice.');  

INSERT INTO ingredients (name, calories_per_base_unit, base_unit) VALUES
('Pizza Dough', 250, '100g'), ('Mozzarella', 280, '100g'), ('Fresh Basil', 23, '100g'),
('Corn Tortillas', 50, 'unit'), ('Pork Shoulder', 240, '100g'), ('Cilantro', 23, '100g'),
('Beef Brisket', 330, '100g'), ('BBQ Rub', 20, 'tbsp'), ('Apple Cider Vinegar', 3, 'tbsp'),
('Ramen Noodles', 188, '100g'), ('Miso Paste', 56, 'tbsp'), ('Nori', 5, 'sheet'),
('Quinoa', 120, '100g'), ('Chickpeas', 164, '100g'), ('Feta Cheese', 264, '100g'),
('Fettuccine', 350, '100g'), ('Heavy Cream', 340, '100g'), ('Parmesan', 431, '100g'),
('Coconut Milk', 230, '100ml'), ('Green Curry Paste', 15, 'tbsp'), ('Bamboo Shoots', 27, '100g'),
('Ground Beef Paties', 250, '100g'), ('Brioche Buns', 280, 'unit'), ('Pickles', 11, '100g'),
('Red Lentils', 116, '100g'), ('Cumin', 22, 'tbsp'), ('Turmeric', 24, 'tbsp'),
('Rice Noodles', 190, '100g'), ('Peanuts', 567, '100g'), ('Tamarind Paste', 239, '100g'),
('Onions', 40, '100g'), ('Beef Stock', 15, '100ml'), ('Gruyere Cheese', 413, '100g'),
('Sushi Rice', 130, '100g'), ('Salmon', 208, '100g'), ('Cucumber', 15, '100g'),
('Pita Bread', 275, 'unit'), ('Lamb', 294, '100g'), ('Tzatziki', 54, 'tbsp'),
('Chicken Thighs', 209, '100g'), ('Flour', 364, '100g'), ('Buttermilk', 40, '100ml'),
('Lasagna Sheets', 280, '100g'), ('Ricotta', 174, '100g'), ('Spinach', 23, '100g'),
('Arborio Rice', 130, '100g'), ('Mushrooms', 22, '100g'), ('White Wine', 85, '100ml'),
('Romaine Lettuce', 17, '100g'), ('Croutons', 122, '100g'), ('Caesar Dressing', 78, 'tbsp'),
('Eggplant', 25, '100g'), ('Zucchini', 17, '100g'), ('Bell Peppers', 31, '100g'),
('Ground Lamb', 280, '100g'), ('Potatoes', 77, '100g'), ('Green Peas', 81, '100g')
ON CONFLICT (name) DO NOTHING;

INSERT INTO recipes (title, description, prep_time_minutes, cook_time_minutes, servings) VALUES
('Margherita Pizza', 'Simple and classic Italian pizza.', 20, 10, 2),
('Carnitas Tacos', 'Slow-cooked pork with fresh cilantro.', 15, 180, 6),
('Texas BBQ Brisket', 'Smoked low and slow.', 30, 720, 10),
('Miso Ramen', 'Rich and savory Japanese noodle soup.', 20, 60, 2),
('Mediterranean Bowl', 'Healthy quinoa and chickpea bowl.', 15, 15, 2),
('Fettuccine Alfredo', 'Indulgent creamy pasta.', 10, 15, 2),
('Thai Green Curry', 'Spicy and aromatic coconut curry.', 15, 25, 4),
('Classic Burger', 'Juicy beef burger with all the fixings.', 10, 10, 1),
('Lentil Soup', 'Hearty and vegan-friendly soup.', 10, 40, 4),
('Pad Thai', 'Classic Thai street food noodles.', 20, 15, 2),
('French Onion Soup', 'Rich onion soup with melted cheese.', 20, 90, 4),
('Salmon Sushi Roll', 'Fresh salmon and cucumber rolls.', 40, 0, 3),
('Greek Gyro', 'Spiced lamb in a warm pita.', 20, 20, 2),
('Fried Chicken', 'Crispy, buttermilk-soaked chicken.', 30, 20, 4),
('Spinach Lasagna', 'Vegetarian lasagna with ricotta.', 30, 45, 6),
('Mushroom Risotto', 'Creamy Italian rice with wild mushrooms.', 10, 30, 2),
('Caesar Salad', 'The gold standard of salads.', 15, 0, 2),
('Ratatouille', 'Classic French vegetable stew.', 20, 60, 4),
('Shepherd Pie', 'Savory lamb topped with mashed potatoes.', 20, 30, 4),
('Buffalo Chicken Ranch Fries', 'Gracie’s special - fries, chicken, and spice.', 10, 25, 2)
ON CONFLICT (title) DO NOTHING;



SELECT * FROM recipes;

-- Creates user table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL
);

-- Create calorie_limits table
CREATE TABLE calorie_limits (
    limit_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    weight DECIMAL,
    height DECIMAL,
    age INT,
    gender VARCHAR(10),
    activity_level VARCHAR(20),
    daily_calorie_limit DECIMAL NOT NULL
);

CREATE TABLE daily_intake (
    intake_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    calories_consumed DECIMAL DEFAULT 0,
    log_date DATE DEFAULT CURRENT_DATE
);

-- create view  to calculate calories consumed for the day
CREATE VIEW user_calorie_status AS
SELECT 
    u.username,
    cl.daily_calorie_limit,
    COALESCE(di.calories_consumed, 0) as consumed,
    (cl.daily_calorie_limit - COALESCE(di.calories_consumed, 0)) AS calories_remaining
FROM users u
JOIN calorie_limits cl ON u.user_id = cl.user_id
LEFT JOIN daily_intake di ON u.user_id = di.user_id AND di.log_date = CURRENT_DATE;

SELECT * FROM user_calorie_status;

