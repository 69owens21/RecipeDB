--
-- PostgreSQL database dump
--

\restrict xquA4vim6NazAs5Ik2p1OeljaAlbcy7xUEwn3SVchx60l8b2Hk9RbCY7VgDkg1q

-- Dumped from database version 18.3 (Homebrew)
-- Dumped by pg_dump version 18.3 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE recipes;
--
-- Name: recipes; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE recipes WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';


ALTER DATABASE recipes OWNER TO postgres;

\unrestrict xquA4vim6NazAs5Ik2p1OeljaAlbcy7xUEwn3SVchx60l8b2Hk9RbCY7VgDkg1q
\connect recipes
\restrict xquA4vim6NazAs5Ik2p1OeljaAlbcy7xUEwn3SVchx60l8b2Hk9RbCY7VgDkg1q

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ingredients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ingredients (
    ingredient_id integer NOT NULL,
    name character varying(255) NOT NULL,
    calories_per_base_unit numeric,
    base_unit character varying(50)
);


ALTER TABLE public.ingredients OWNER TO postgres;

--
-- Name: ingredients_ingredient_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ingredients_ingredient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ingredients_ingredient_id_seq OWNER TO postgres;

--
-- Name: ingredients_ingredient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ingredients_ingredient_id_seq OWNED BY public.ingredients.ingredient_id;


--
-- Name: recipe_ingredients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recipe_ingredients (
    recipe_id integer NOT NULL,
    ingredient_id integer NOT NULL,
    quantity numeric,
    unit_used character varying(50)
);


ALTER TABLE public.recipe_ingredients OWNER TO postgres;

--
-- Name: recipe_steps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recipe_steps (
    step_id integer NOT NULL,
    recipe_id integer,
    step_number integer,
    instruction text
);


ALTER TABLE public.recipe_steps OWNER TO postgres;

--
-- Name: recipe_steps_step_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recipe_steps_step_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recipe_steps_step_id_seq OWNER TO postgres;

--
-- Name: recipe_steps_step_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recipe_steps_step_id_seq OWNED BY public.recipe_steps.step_id;


--
-- Name: recipes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recipes (
    recipe_id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    prep_time_minutes integer,
    cook_time_minutes integer,
    servings integer
);


ALTER TABLE public.recipes OWNER TO postgres;

--
-- Name: recipes_recipe_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recipes_recipe_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recipes_recipe_id_seq OWNER TO postgres;

--
-- Name: recipes_recipe_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recipes_recipe_id_seq OWNED BY public.recipes.recipe_id;


--
-- Name: ingredients ingredient_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredients ALTER COLUMN ingredient_id SET DEFAULT nextval('public.ingredients_ingredient_id_seq'::regclass);


--
-- Name: recipe_steps step_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_steps ALTER COLUMN step_id SET DEFAULT nextval('public.recipe_steps_step_id_seq'::regclass);


--
-- Name: recipes recipe_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes ALTER COLUMN recipe_id SET DEFAULT nextval('public.recipes_recipe_id_seq'::regclass);


--
-- Data for Name: ingredients; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ingredients VALUES (1, 'Spaghetti', 200, '100g');
INSERT INTO public.ingredients VALUES (2, 'Ground Beef', 250, '100g');
INSERT INTO public.ingredients VALUES (3, 'Tomato Sauce', 80, '100g');
INSERT INTO public.ingredients VALUES (4, 'Chicken Breast', 165, '100g');
INSERT INTO public.ingredients VALUES (5, 'Curry Powder', 50, '1 tbsp');
INSERT INTO public.ingredients VALUES (6, 'Mixed Vegetables', 50, '100g');
INSERT INTO public.ingredients VALUES (8, 'Ranch', NULL, NULL);
INSERT INTO public.ingredients VALUES (10, 'Pizza Dough', 250, '100g');
INSERT INTO public.ingredients VALUES (11, 'Mozzarella', 280, '100g');
INSERT INTO public.ingredients VALUES (12, 'Fresh Basil', 23, '100g');
INSERT INTO public.ingredients VALUES (13, 'Corn Tortillas', 50, 'unit');
INSERT INTO public.ingredients VALUES (14, 'Pork Shoulder', 240, '100g');
INSERT INTO public.ingredients VALUES (15, 'Cilantro', 23, '100g');
INSERT INTO public.ingredients VALUES (16, 'Beef Brisket', 330, '100g');
INSERT INTO public.ingredients VALUES (17, 'BBQ Rub', 20, 'tbsp');
INSERT INTO public.ingredients VALUES (18, 'Apple Cider Vinegar', 3, 'tbsp');
INSERT INTO public.ingredients VALUES (19, 'Ramen Noodles', 188, '100g');
INSERT INTO public.ingredients VALUES (20, 'Miso Paste', 56, 'tbsp');
INSERT INTO public.ingredients VALUES (21, 'Nori', 5, 'sheet');
INSERT INTO public.ingredients VALUES (22, 'Quinoa', 120, '100g');
INSERT INTO public.ingredients VALUES (23, 'Chickpeas', 164, '100g');
INSERT INTO public.ingredients VALUES (24, 'Feta Cheese', 264, '100g');
INSERT INTO public.ingredients VALUES (25, 'Fettuccine', 350, '100g');
INSERT INTO public.ingredients VALUES (26, 'Heavy Cream', 340, '100g');
INSERT INTO public.ingredients VALUES (27, 'Parmesan', 431, '100g');
INSERT INTO public.ingredients VALUES (28, 'Coconut Milk', 230, '100ml');
INSERT INTO public.ingredients VALUES (29, 'Green Curry Paste', 15, 'tbsp');
INSERT INTO public.ingredients VALUES (30, 'Bamboo Shoots', 27, '100g');
INSERT INTO public.ingredients VALUES (31, 'Ground Beef Paties', 250, '100g');
INSERT INTO public.ingredients VALUES (32, 'Brioche Buns', 280, 'unit');
INSERT INTO public.ingredients VALUES (33, 'Pickles', 11, '100g');
INSERT INTO public.ingredients VALUES (34, 'Red Lentils', 116, '100g');
INSERT INTO public.ingredients VALUES (35, 'Cumin', 22, 'tbsp');
INSERT INTO public.ingredients VALUES (36, 'Turmeric', 24, 'tbsp');
INSERT INTO public.ingredients VALUES (37, 'Rice Noodles', 190, '100g');
INSERT INTO public.ingredients VALUES (38, 'Peanuts', 567, '100g');
INSERT INTO public.ingredients VALUES (39, 'Tamarind Paste', 239, '100g');
INSERT INTO public.ingredients VALUES (40, 'Onions', 40, '100g');
INSERT INTO public.ingredients VALUES (41, 'Beef Stock', 15, '100ml');
INSERT INTO public.ingredients VALUES (42, 'Gruyere Cheese', 413, '100g');
INSERT INTO public.ingredients VALUES (43, 'Sushi Rice', 130, '100g');
INSERT INTO public.ingredients VALUES (44, 'Salmon', 208, '100g');
INSERT INTO public.ingredients VALUES (45, 'Cucumber', 15, '100g');
INSERT INTO public.ingredients VALUES (46, 'Pita Bread', 275, 'unit');
INSERT INTO public.ingredients VALUES (47, 'Lamb', 294, '100g');
INSERT INTO public.ingredients VALUES (48, 'Tzatziki', 54, 'tbsp');
INSERT INTO public.ingredients VALUES (49, 'Chicken Thighs', 209, '100g');
INSERT INTO public.ingredients VALUES (50, 'Flour', 364, '100g');
INSERT INTO public.ingredients VALUES (51, 'Buttermilk', 40, '100ml');
INSERT INTO public.ingredients VALUES (52, 'Lasagna Sheets', 280, '100g');
INSERT INTO public.ingredients VALUES (53, 'Ricotta', 174, '100g');
INSERT INTO public.ingredients VALUES (54, 'Spinach', 23, '100g');
INSERT INTO public.ingredients VALUES (55, 'Arborio Rice', 130, '100g');
INSERT INTO public.ingredients VALUES (56, 'Mushrooms', 22, '100g');
INSERT INTO public.ingredients VALUES (57, 'White Wine', 85, '100ml');
INSERT INTO public.ingredients VALUES (58, 'Romaine Lettuce', 17, '100g');
INSERT INTO public.ingredients VALUES (59, 'Croutons', 122, '100g');
INSERT INTO public.ingredients VALUES (60, 'Caesar Dressing', 78, 'tbsp');
INSERT INTO public.ingredients VALUES (61, 'Eggplant', 25, '100g');
INSERT INTO public.ingredients VALUES (62, 'Zucchini', 17, '100g');
INSERT INTO public.ingredients VALUES (63, 'Bell Peppers', 31, '100g');
INSERT INTO public.ingredients VALUES (64, 'Ground Lamb', 280, '100g');
INSERT INTO public.ingredients VALUES (65, 'Potatoes', 77, '100g');
INSERT INTO public.ingredients VALUES (66, 'Green Peas', 81, '100g');


--
-- Data for Name: recipe_ingredients; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.recipe_ingredients VALUES (1, 1, 200, 'g');
INSERT INTO public.recipe_ingredients VALUES (1, 2, 300, 'g');
INSERT INTO public.recipe_ingredients VALUES (1, 3, 150, 'g');
INSERT INTO public.recipe_ingredients VALUES (2, 4, 400, 'g');
INSERT INTO public.recipe_ingredients VALUES (2, 5, 2, 'tbsp');
INSERT INTO public.recipe_ingredients VALUES (3, 6, 300, 'g');


--
-- Data for Name: recipe_steps; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.recipe_steps VALUES (1, 1, 1, 'Cook spaghetti according to package instructions.');
INSERT INTO public.recipe_steps VALUES (2, 1, 2, 'In a separate pan, cook ground beef until browned.');
INSERT INTO public.recipe_steps VALUES (3, 1, 3, 'Add tomato sauce to the beef and simmer for 20 minutes.');
INSERT INTO public.recipe_steps VALUES (4, 1, 4, 'Serve the sauce over the cooked spaghetti.');
INSERT INTO public.recipe_steps VALUES (5, 2, 1, 'Cook chicken breast in a pan until fully cooked.');
INSERT INTO public.recipe_steps VALUES (6, 2, 2, 'Add curry powder and cook for another minute.');
INSERT INTO public.recipe_steps VALUES (7, 2, 3, 'Add water and simmer for 20 minutes.');
INSERT INTO public.recipe_steps VALUES (8, 2, 4, 'Serve with rice.');
INSERT INTO public.recipe_steps VALUES (9, 3, 1, 'Heat oil in a pan and add mixed vegetables.');
INSERT INTO public.recipe_steps VALUES (10, 3, 2, 'Stir fry for 5-7 minutes until vegetables are tender.');
INSERT INTO public.recipe_steps VALUES (11, 3, 3, 'Serve with noodles or rice.');
INSERT INTO public.recipe_steps VALUES (15, 7, 1, 'Roll out the pizza dough on a floured surface.');
INSERT INTO public.recipe_steps VALUES (16, 7, 2, 'Top with sauce, mozzarella, and fresh basil.');
INSERT INTO public.recipe_steps VALUES (17, 7, 3, 'Bake at 500F for 8-10 minutes.');
INSERT INTO public.recipe_steps VALUES (18, 26, 1, 'Air fry the crinkle cut fries until golden.');
INSERT INTO public.recipe_steps VALUES (19, 26, 2, 'Toss chicken in buffalo sauce and layer over fries.');
INSERT INTO public.recipe_steps VALUES (20, 26, 3, 'Drizzle with ranch and serve immediately.');


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.recipes VALUES (1, 'Spaghetti Bolognese', 'A classic Italian pasta dish with a rich meat sauce.', 15, 60, 4);
INSERT INTO public.recipes VALUES (2, 'Chicken Curry', 'A flavorful curry dish with tender chicken pieces.', 20, 40, 4);
INSERT INTO public.recipes VALUES (3, 'Vegetable Stir Fry', 'A quick and healthy stir fry with fresh vegetables.', 10, 15, 2);
INSERT INTO public.recipes VALUES (7, 'Margherita Pizza', 'Simple and classic Italian pizza.', 20, 10, 2);
INSERT INTO public.recipes VALUES (8, 'Carnitas Tacos', 'Slow-cooked pork with fresh cilantro.', 15, 180, 6);
INSERT INTO public.recipes VALUES (9, 'Texas BBQ Brisket', 'Smoked low and slow.', 30, 720, 10);
INSERT INTO public.recipes VALUES (10, 'Miso Ramen', 'Rich and savory Japanese noodle soup.', 20, 60, 2);
INSERT INTO public.recipes VALUES (11, 'Mediterranean Bowl', 'Healthy quinoa and chickpea bowl.', 15, 15, 2);
INSERT INTO public.recipes VALUES (12, 'Fettuccine Alfredo', 'Indulgent creamy pasta.', 10, 15, 2);
INSERT INTO public.recipes VALUES (13, 'Thai Green Curry', 'Spicy and aromatic coconut curry.', 15, 25, 4);
INSERT INTO public.recipes VALUES (14, 'Classic Burger', 'Juicy beef burger with all the fixings.', 10, 10, 1);
INSERT INTO public.recipes VALUES (15, 'Lentil Soup', 'Hearty and vegan-friendly soup.', 10, 40, 4);
INSERT INTO public.recipes VALUES (16, 'Pad Thai', 'Classic Thai street food noodles.', 20, 15, 2);
INSERT INTO public.recipes VALUES (17, 'French Onion Soup', 'Rich onion soup with melted cheese.', 20, 90, 4);
INSERT INTO public.recipes VALUES (18, 'Salmon Sushi Roll', 'Fresh salmon and cucumber rolls.', 40, 0, 3);
INSERT INTO public.recipes VALUES (19, 'Greek Gyro', 'Spiced lamb in a warm pita.', 20, 20, 2);
INSERT INTO public.recipes VALUES (20, 'Fried Chicken', 'Crispy, buttermilk-soaked chicken.', 30, 20, 4);
INSERT INTO public.recipes VALUES (21, 'Spinach Lasagna', 'Vegetarian lasagna with ricotta.', 30, 45, 6);
INSERT INTO public.recipes VALUES (22, 'Mushroom Risotto', 'Creamy Italian rice with wild mushrooms.', 10, 30, 2);
INSERT INTO public.recipes VALUES (23, 'Caesar Salad', 'The gold standard of salads.', 15, 0, 2);
INSERT INTO public.recipes VALUES (24, 'Ratatouille', 'Classic French vegetable stew.', 20, 60, 4);
INSERT INTO public.recipes VALUES (25, 'Shepherd Pie', 'Savory lamb topped with mashed potatoes.', 20, 30, 4);
INSERT INTO public.recipes VALUES (26, 'Buffalo Chicken Ranch Fries', 'Gracie’s special - fries, chicken, and spice.', 10, 25, 2);


--
-- Name: ingredients_ingredient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ingredients_ingredient_id_seq', 66, true);


--
-- Name: recipe_steps_step_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recipe_steps_step_id_seq', 20, true);


--
-- Name: recipes_recipe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recipes_recipe_id_seq', 26, true);


--
-- Name: ingredients ingredients_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT ingredients_name_key UNIQUE (name);


--
-- Name: ingredients ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT ingredients_pkey PRIMARY KEY (ingredient_id);


--
-- Name: recipe_ingredients recipe_ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_ingredients
    ADD CONSTRAINT recipe_ingredients_pkey PRIMARY KEY (recipe_id, ingredient_id);


--
-- Name: recipe_steps recipe_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_steps
    ADD CONSTRAINT recipe_steps_pkey PRIMARY KEY (step_id);


--
-- Name: recipes recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (recipe_id);


--
-- Name: recipes recipes_title_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_title_key UNIQUE (title);


--
-- Name: recipe_ingredients recipe_ingredients_ingredient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_ingredients
    ADD CONSTRAINT recipe_ingredients_ingredient_id_fkey FOREIGN KEY (ingredient_id) REFERENCES public.ingredients(ingredient_id) ON DELETE CASCADE;


--
-- Name: recipe_ingredients recipe_ingredients_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_ingredients
    ADD CONSTRAINT recipe_ingredients_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.recipes(recipe_id) ON DELETE CASCADE;


--
-- Name: recipe_steps recipe_steps_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe_steps
    ADD CONSTRAINT recipe_steps_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.recipes(recipe_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict xquA4vim6NazAs5Ik2p1OeljaAlbcy7xUEwn3SVchx60l8b2Hk9RbCY7VgDkg1q

