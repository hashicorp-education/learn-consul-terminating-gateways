--
-- PostgreSQL database dump
--

-- Dumped from database version 11.6 (Debian 11.6-1.pgdg90+1)
-- Dumped by pg_dump version 11.6 (Debian 11.6-1.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: coffee_ingredients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coffee_ingredients (
    id integer NOT NULL,
    coffee_id integer,
    ingredient_id integer,
    quantity integer NOT NULL,
    unit character varying(50) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.coffee_ingredients OWNER TO postgres;

--
-- Name: coffee_ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.coffee_ingredients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.coffee_ingredients_id_seq OWNER TO postgres;

--
-- Name: coffee_ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.coffee_ingredients_id_seq OWNED BY public.coffee_ingredients.id;


--
-- Name: coffees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coffees (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    teaser character varying(255),
    collection character varying(255),
    origin character varying(255),
    color character varying(7),
    description text,
    price integer NOT NULL,
    image text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.coffees OWNER TO postgres;

--
-- Name: coffees_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.coffees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.coffees_id_seq OWNER TO postgres;

--
-- Name: coffees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.coffees_id_seq OWNED BY public.coffees.id;


--
-- Name: ingredients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ingredients (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.ingredients OWNER TO postgres;

--
-- Name: ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ingredients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ingredients_id_seq OWNER TO postgres;

--
-- Name: ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ingredients_id_seq OWNED BY public.ingredients.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer,
    coffee_id integer,
    quantity integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_items_id_seq OWNER TO postgres;

--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_id_seq OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tokens (
    id integer NOT NULL,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.tokens OWNER TO postgres;

--
-- Name: tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tokens_id_seq OWNER TO postgres;

--
-- Name: tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tokens_id_seq OWNED BY public.tokens.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    password text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: coffee_ingredients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coffee_ingredients ALTER COLUMN id SET DEFAULT nextval('public.coffee_ingredients_id_seq'::regclass);


--
-- Name: coffees id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coffees ALTER COLUMN id SET DEFAULT nextval('public.coffees_id_seq'::regclass);


--
-- Name: ingredients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredients ALTER COLUMN id SET DEFAULT nextval('public.ingredients_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens ALTER COLUMN id SET DEFAULT nextval('public.tokens_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: coffee_ingredients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coffee_ingredients (id, coffee_id, ingredient_id, quantity, unit, created_at, updated_at, deleted_at) FROM stdin;
1	1	6	350	ml	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
2	2	1	40	ml	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
3	2	2	300	ml	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
4	2	4	5	g	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
5	3	1	40	ml	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
6	3	2	300	ml	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
7	4	1	20	ml	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
8	4	3	100	ml	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
9	5	1	20	ml	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
10	6	1	40	ml	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
11	7	1	40	ml	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
12	7	5	300	ml	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
13	8	1	30	ml	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
14	8	6	120	ml	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
15	9	1	60	ml	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
16	9	2	30	ml	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
\.


--
-- Data for Name: coffees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coffees (id, name, teaser, collection, origin, color, description, price, image, created_at, updated_at, deleted_at) FROM stdin;
1	HCP Aeropress	Automation in a cup	Foundations	Summer 2020	#444		200	/hashicorp.png	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
2	Packer Spiced Latte	Packed with goodness to spice up your images	Origins	Summer 2013	#1FA7EE		350	/packer.png	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
3	Vaulatte	Nothing gives you a safe and secure feeling like a Vaulatte	Foundations	Spring 2015	#FFD814		200	/vault.png	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
4	Nomadicano	Drink one today and you will want to schedule another	Foundations	Fall 2015	#00CA8E		150	/nomad.png	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
5	Terraspresso	Nothing kickstarts your day like a provision of Terraspresso	Origins	Summer 2014	#894BD1		150	/terraform.png	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
6	Vagrante espresso	Stdin is not a tty	Origins	2010	#0E67ED		200	/vagrant.png	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
7	Connectaccino	Discover the wonders of our meshy service	Origins	Spring 2014	#F44D8A		250	/consul.png	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
8	Boundary Red Eye	Perk up and watch out for your access management	Discoveries	Fall 2020	#F24C53		200	/boundary.png	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
9	Waypointiato	Deploy with a little foam	Discoveries	Fall 2020	#14C6CB		250	/waypoint.png	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
\.


--
-- Data for Name: ingredients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ingredients (id, name, created_at, updated_at, deleted_at) FROM stdin;
1	Espresso	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
2	Semi Skimmed Milk	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
3	Hot Water	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
4	Pumpkin Spice	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
5	Steamed Milk	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
6	Coffee	2024-01-22 00:00:00	2024-01-22 00:00:00	\N
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (id, order_id, coffee_id, quantity, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, user_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tokens (id, user_id, created_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Name: coffee_ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.coffee_ingredients_id_seq', 16, true);


--
-- Name: coffees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.coffees_id_seq', 9, true);


--
-- Name: ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ingredients_id_seq', 1, false);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_items_id_seq', 1, false);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 1, false);


--
-- Name: tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tokens_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: coffee_ingredients coffee_ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coffee_ingredients
    ADD CONSTRAINT coffee_ingredients_pkey PRIMARY KEY (id);


--
-- Name: coffees coffees_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coffees
    ADD CONSTRAINT coffees_name_key UNIQUE (name);


--
-- Name: coffees coffees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coffees
    ADD CONSTRAINT coffees_pkey PRIMARY KEY (id);


--
-- Name: ingredients ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT ingredients_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);


--
-- Name: coffee_ingredients unique_coffee_ingredient; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coffee_ingredients
    ADD CONSTRAINT unique_coffee_ingredient UNIQUE (coffee_id, ingredient_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: coffee_ingredients coffee_ingredients_coffee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coffee_ingredients
    ADD CONSTRAINT coffee_ingredients_coffee_id_fkey FOREIGN KEY (coffee_id) REFERENCES public.coffees(id);


--
-- Name: coffee_ingredients coffee_ingredients_ingredient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coffee_ingredients
    ADD CONSTRAINT coffee_ingredients_ingredient_id_fkey FOREIGN KEY (ingredient_id) REFERENCES public.ingredients(id);


--
-- Name: order_items order_items_coffee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_coffee_id_fkey FOREIGN KEY (coffee_id) REFERENCES public.coffees(id);


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: tokens tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

