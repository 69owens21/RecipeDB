--
-- PostgreSQL database dump
--

\restrict QbYXD68Jtrsp1C57iFR63YK91yrIViSk0EH3hkkhMekoBi5dn1DUTsZOfPSKB7d

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: calorie_limits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.calorie_limits (
    limit_id integer NOT NULL,
    user_id integer,
    weight numeric,
    height numeric,
    age integer,
    gender character varying(10),
    activity_level character varying(20),
    daily_calorie_limit numeric NOT NULL
);


ALTER TABLE public.calorie_limits OWNER TO postgres;

--
-- Name: calorie_limits_limit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.calorie_limits_limit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.calorie_limits_limit_id_seq OWNER TO postgres;

--
-- Name: calorie_limits_limit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.calorie_limits_limit_id_seq OWNED BY public.calorie_limits.limit_id;


--
-- Name: daily_intake; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.daily_intake (
    intake_id integer NOT NULL,
    user_id integer,
    calories_consumed numeric DEFAULT 0,
    log_date date DEFAULT CURRENT_DATE
);


ALTER TABLE public.daily_intake OWNER TO postgres;

--
-- Name: daily_intake_intake_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.daily_intake_intake_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.daily_intake_intake_id_seq OWNER TO postgres;

--
-- Name: daily_intake_intake_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.daily_intake_intake_id_seq OWNED BY public.daily_intake.intake_id;


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
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(255) NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: user_calorie_status; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.user_calorie_status AS
 SELECT u.username,
    cl.daily_calorie_limit,
    COALESCE(di.calories_consumed, (0)::numeric) AS consumed,
    (cl.daily_calorie_limit - COALESCE(di.calories_consumed, (0)::numeric)) AS calories_remaining
   FROM ((public.users u
     JOIN public.calorie_limits cl ON ((u.user_id = cl.user_id)))
     LEFT JOIN public.daily_intake di ON (((u.user_id = di.user_id) AND (di.log_date = CURRENT_DATE))));


ALTER VIEW public.user_calorie_status OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: calorie_limits limit_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calorie_limits ALTER COLUMN limit_id SET DEFAULT nextval('public.calorie_limits_limit_id_seq'::regclass);


--
-- Name: daily_intake intake_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_intake ALTER COLUMN intake_id SET DEFAULT nextval('public.daily_intake_intake_id_seq'::regclass);


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
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: calorie_limits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.calorie_limits (limit_id, user_id, weight, height, age, gender, activity_level, daily_calorie_limit) FROM stdin;
\.


--
-- Data for Name: daily_intake; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.daily_intake (intake_id, user_id, calories_consumed, log_date) FROM stdin;
\.


--
-- Data for Name: ingredients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ingredients (ingredient_id, name, calories_per_base_unit, base_unit) FROM stdin;
1	Spaghetti	200	100g
2	Ground Beef	250	100g
3	Tomato Sauce	80	100g
4	Chicken Breast	165	100g
5	Curry Powder	50	1 tbsp
6	Mixed Vegetables	50	100g
8	Ranch	\N	\N
10	Pizza Dough	250	100g
11	Mozzarella	280	100g
12	Fresh Basil	23	100g
13	Corn Tortillas	50	unit
14	Pork Shoulder	240	100g
15	Cilantro	23	100g
16	Beef Brisket	330	100g
17	BBQ Rub	20	tbsp
18	Apple Cider Vinegar	3	tbsp
19	Ramen Noodles	188	100g
20	Miso Paste	56	tbsp
21	Nori	5	sheet
22	Quinoa	120	100g
23	Chickpeas	164	100g
24	Feta Cheese	264	100g
25	Fettuccine	350	100g
26	Heavy Cream	340	100g
27	Parmesan	431	100g
28	Coconut Milk	230	100ml
29	Green Curry Paste	15	tbsp
30	Bamboo Shoots	27	100g
31	Ground Beef Paties	250	100g
32	Brioche Buns	280	unit
33	Pickles	11	100g
34	Red Lentils	116	100g
35	Cumin	22	tbsp
36	Turmeric	24	tbsp
37	Rice Noodles	190	100g
38	Peanuts	567	100g
39	Tamarind Paste	239	100g
40	Onions	40	100g
41	Beef Stock	15	100ml
42	Gruyere Cheese	413	100g
43	Sushi Rice	130	100g
44	Salmon	208	100g
45	Cucumber	15	100g
46	Pita Bread	275	unit
47	Lamb	294	100g
48	Tzatziki	54	tbsp
49	Chicken Thighs	209	100g
50	Flour	364	100g
51	Buttermilk	40	100ml
52	Lasagna Sheets	280	100g
53	Ricotta	174	100g
54	Spinach	23	100g
55	Arborio Rice	130	100g
56	Mushrooms	22	100g
57	White Wine	85	100ml
58	Romaine Lettuce	17	100g
59	Croutons	122	100g
60	Caesar Dressing	78	tbsp
61	Eggplant	25	100g
62	Zucchini	17	100g
63	Bell Peppers	31	100g
64	Ground Lamb	280	100g
65	Potatoes	77	100g
66	Green Peas	81	100g
67	butthair	\N	\N
68	sock	\N	\N
69	junk	\N	\N
\.


--
-- Data for Name: recipe_ingredients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recipe_ingredients (recipe_id, ingredient_id, quantity, unit_used) FROM stdin;
1	1	200	g
1	2	300	g
1	3	150	g
2	4	400	g
2	5	2	tbsp
3	6	300	g
27	67	\N	\N
27	68	\N	\N
27	69	\N	\N
\.


--
-- Data for Name: recipe_steps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recipe_steps (step_id, recipe_id, step_number, instruction) FROM stdin;
1	1	1	Cook spaghetti according to package instructions.
2	1	2	In a separate pan, cook ground beef until browned.
3	1	3	Add tomato sauce to the beef and simmer for 20 minutes.
4	1	4	Serve the sauce over the cooked spaghetti.
5	2	1	Cook chicken breast in a pan until fully cooked.
6	2	2	Add curry powder and cook for another minute.
7	2	3	Add water and simmer for 20 minutes.
8	2	4	Serve with rice.
9	3	1	Heat oil in a pan and add mixed vegetables.
10	3	2	Stir fry for 5-7 minutes until vegetables are tender.
11	3	3	Serve with noodles or rice.
15	7	1	Roll out the pizza dough on a floured surface.
16	7	2	Top with sauce, mozzarella, and fresh basil.
17	7	3	Bake at 500F for 8-10 minutes.
18	26	1	Air fry the crinkle cut fries until golden.
19	26	2	Toss chicken in buffalo sauce and layer over fries.
20	26	3	Drizzle with ranch and serve immediately.
21	27	1	lick
22	27	2	suck
23	27	3	shuck
\.


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recipes (recipe_id, title, description, prep_time_minutes, cook_time_minutes, servings) FROM stdin;
1	Spaghetti Bolognese	A classic Italian pasta dish with a rich meat sauce.	15	60	4
2	Chicken Curry	A flavorful curry dish with tender chicken pieces.	20	40	4
3	Vegetable Stir Fry	A quick and healthy stir fry with fresh vegetables.	10	15	2
7	Margherita Pizza	Simple and classic Italian pizza.	20	10	2
8	Carnitas Tacos	Slow-cooked pork with fresh cilantro.	15	180	6
9	Texas BBQ Brisket	Smoked low and slow.	30	720	10
10	Miso Ramen	Rich and savory Japanese noodle soup.	20	60	2
11	Mediterranean Bowl	Healthy quinoa and chickpea bowl.	15	15	2
12	Fettuccine Alfredo	Indulgent creamy pasta.	10	15	2
13	Thai Green Curry	Spicy and aromatic coconut curry.	15	25	4
14	Classic Burger	Juicy beef burger with all the fixings.	10	10	1
15	Lentil Soup	Hearty and vegan-friendly soup.	10	40	4
16	Pad Thai	Classic Thai street food noodles.	20	15	2
17	French Onion Soup	Rich onion soup with melted cheese.	20	90	4
18	Salmon Sushi Roll	Fresh salmon and cucumber rolls.	40	0	3
19	Greek Gyro	Spiced lamb in a warm pita.	20	20	2
20	Fried Chicken	Crispy, buttermilk-soaked chicken.	30	20	4
21	Spinach Lasagna	Vegetarian lasagna with ricotta.	30	45	6
22	Mushroom Risotto	Creamy Italian rice with wild mushrooms.	10	30	2
23	Caesar Salad	The gold standard of salads.	15	0	2
24	Ratatouille	Classic French vegetable stew.	20	60	4
25	Shepherd Pie	Savory lamb topped with mashed potatoes.	20	30	4
26	Buffalo Chicken Ranch Fries	Gracie’s special - fries, chicken, and spice.	10	25	2
27	ally bootyhole	\N	\N	\N	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, username) FROM stdin;
\.


--
-- Name: calorie_limits_limit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.calorie_limits_limit_id_seq', 1, false);


--
-- Name: daily_intake_intake_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.daily_intake_intake_id_seq', 1, false);


--
-- Name: ingredients_ingredient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ingredients_ingredient_id_seq', 69, true);


--
-- Name: recipe_steps_step_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recipe_steps_step_id_seq', 23, true);


--
-- Name: recipes_recipe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recipes_recipe_id_seq', 27, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 1, false);


--
-- Name: calorie_limits calorie_limits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calorie_limits
    ADD CONSTRAINT calorie_limits_pkey PRIMARY KEY (limit_id);


--
-- Name: daily_intake daily_intake_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_intake
    ADD CONSTRAINT daily_intake_pkey PRIMARY KEY (intake_id);


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
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: calorie_limits calorie_limits_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calorie_limits
    ADD CONSTRAINT calorie_limits_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: daily_intake daily_intake_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_intake
    ADD CONSTRAINT daily_intake_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


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

\unrestrict QbYXD68Jtrsp1C57iFR63YK91yrIViSk0EH3hkkhMekoBi5dn1DUTsZOfPSKB7d

