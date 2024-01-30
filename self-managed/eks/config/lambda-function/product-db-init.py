import psycopg2
import os

def lambda_handler(event, context):
    # Retrieve PostgreSQL connection details from environment variables
    host = os.environ['DB_HOST']
    port = os.environ['DB_PORT']
    dbname = os.environ['DB_NAME']
    user = os.environ['DB_USER']
    password = os.environ['DB_PASSWORD']

    # Connect to the PostgreSQL database
    conn = psycopg2.connect(host=host, port=port, dbname=dbname, user=user, password=password)

    try:
        # Open a cursor to perform database operations
        with conn.cursor() as cursor:
            # Define SQL commands
            schema_commands = """
                CREATE TABLE public.coffee_ingredients (id integer NOT NULL,coffee_id integer,ingredient_id integer,quantity integer NOT NULL,unit character varying(50) NOT NULL,created_at timestamp without time zone NOT NULL,updated_at timestamp without time zone NOT NULL,deleted_at timestamp without time zone);
                ALTER TABLE public.coffee_ingredients OWNER TO postgres;
                CREATE SEQUENCE public.coffee_ingredients_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
                ALTER TABLE public.coffee_ingredients_id_seq OWNER TO postgres;
                ALTER SEQUENCE public.coffee_ingredients_id_seq OWNED BY public.coffee_ingredients.id;
                CREATE TABLE public.coffees (id integer NOT NULL, name character varying(255) NOT NULL, teaser character varying(255), collection character varying(255), origin character varying(255), color character varying(7), price integer NOT NULL, image text, created_at timestamp without time zone NOT NULL, updated_at timestamp without time zone NOT NULL, deleted_at timestamp without time zone);
                ALTER TABLE public.coffees OWNER TO postgres;
                CREATE SEQUENCE public.coffees_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
                ALTER TABLE public.coffees_id_seq OWNER TO postgres;
                ALTER SEQUENCE public.coffees_id_seq OWNED BY public.coffees.id;
                CREATE TABLE public.ingredients (id integer NOT NULL, name character varying(255) NOT NULL, created_at timestamp without time zone NOT NULL, updated_at timestamp without time zone NOT NULL, deleted_at timestamp without time zone);
                ALTER TABLE public.ingredients OWNER TO postgres;
                CREATE SEQUENCE public.ingredients_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
                ALTER TABLE public.ingredients_id_seq OWNER TO postgres;
                ALTER SEQUENCE public.ingredients_id_seq OWNED BY public.ingredients.id;
                CREATE TABLE public.order_items (id integer NOT NULL, order_id integer, coffee_id integer, quantity integer NOT NULL, created_at timestamp without time zone NOT NULL, updated_at timestamp without time zone NOT NULL, deleted_at timestamp without time zone);
                ALTER TABLE public.order_items OWNER TO postgres;
                CREATE SEQUENCE public.order_items_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
                ALTER TABLE public.order_items_id_seq OWNER TO postgres;
                ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;
                CREATE TABLE public.orders (id integer NOT NULL, user_id integer, created_at timestamp without time zone NOT NULL, updated_at timestamp without time zone NOT NULL, deleted_at timestamp without time zone);
                ALTER TABLE public.orders OWNER TO postgres;
                CREATE SEQUENCE public.orders_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
                ALTER TABLE public.orders_id_seq OWNER TO postgres;
                ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;
                CREATE TABLE public.tokens (id integer NOT NULL, user_id integer, created_at timestamp without time zone NOT NULL, deleted_at timestamp without time zone);
                ALTER TABLE public.tokens OWNER TO postgres;
                CREATE SEQUENCE public.tokens_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
                ALTER TABLE public.tokens_id_seq OWNER TO postgres;
                ALTER SEQUENCE public.tokens_id_seq OWNED BY public.tokens.id;
                CREATE TABLE public.users (id integer NOT NULL, username character varying(255) NOT NULL, password text NOT NULL, created_at timestamp without time zone NOT NULL, updated_at timestamp without time zone NOT NULL, deleted_at timestamp without time zone);
                ALTER TABLE public.users OWNER TO postgres;
                CREATE SEQUENCE public.users_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
                ALTER TABLE public.users_id_seq OWNER TO postgres;
                ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
                ALTER TABLE ONLY public.coffee_ingredients ALTER COLUMN id SET DEFAULT nextval('public.coffee_ingredients_id_seq'::regclass);
                ALTER TABLE ONLY public.coffees ALTER COLUMN id SET DEFAULT nextval('public.coffees_id_seq'::regclass);
                ALTER TABLE ONLY public.ingredients ALTER COLUMN id SET DEFAULT nextval('public.ingredients_id_seq'::regclass);
                ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);
                ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);
                ALTER TABLE ONLY public.tokens ALTER COLUMN id SET DEFAULT nextval('public.tokens_id_seq'::regclass);
                ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
                INSERT INTO public.coffee_ingredients (id, coffee_id, ingredient_id, quantity, unit, created_at, updated_at, deleted_at) VALUES (1,1,6,350,'ml','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffee_ingredients (id, coffee_id, ingredient_id, quantity, unit, created_at, updated_at, deleted_at) VALUES (2,2,1,40,'ml','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffee_ingredients (id, coffee_id, ingredient_id, quantity, unit, created_at, updated_at, deleted_at) VALUES (3,2,2,300,'ml','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffee_ingredients (id, coffee_id, ingredient_id, quantity, unit, created_at, updated_at, deleted_at) VALUES (4,2,4,5,'ml','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffee_ingredients (id, coffee_id, ingredient_id, quantity, unit, created_at, updated_at, deleted_at) VALUES (5,3,1,40,'ml','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffee_ingredients (id, coffee_id, ingredient_id, quantity, unit, created_at, updated_at, deleted_at) VALUES (6,3,2,300,'ml','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffee_ingredients (id, coffee_id, ingredient_id, quantity, unit, created_at, updated_at, deleted_at) VALUES (7,4,1,20,'ml','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffee_ingredients (id, coffee_id, ingredient_id, quantity, unit, created_at, updated_at, deleted_at) VALUES (8,4,3,100,'ml','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffee_ingredients (id, coffee_id, ingredient_id, quantity, unit, created_at, updated_at, deleted_at) VALUES (9,5,1,20,'ml','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffee_ingredients (id, coffee_id, ingredient_id, quantity, unit, created_at, updated_at, deleted_at) VALUES (10,6,1,40,'ml','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffee_ingredients (id, coffee_id, ingredient_id, quantity, unit, created_at, updated_at, deleted_at) VALUES (11,7,1,40,'ml','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffee_ingredients (id, coffee_id, ingredient_id, quantity, unit, created_at, updated_at, deleted_at) VALUES (12,7,5,300,'ml','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffee_ingredients (id, coffee_id, ingredient_id, quantity, unit, created_at, updated_at, deleted_at) VALUES (13,8,1,30,'ml','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffee_ingredients (id, coffee_id, ingredient_id, quantity, unit, created_at, updated_at, deleted_at) VALUES (14,8,6,120,'ml','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffee_ingredients (id, coffee_id, ingredient_id, quantity, unit, created_at, updated_at, deleted_at) VALUES (15,9,1,60,'ml','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffee_ingredients (id, coffee_id, ingredient_id, quantity, unit, created_at, updated_at, deleted_at) VALUES (16,9,2,30,'ml','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffees (id, name, teaser, collection, origin, color, price, image, created_at, updated_at, deleted_at) VALUES (1,'HCP Aeropress','Automation in a cup','Foundations','Summer 2020','#444',200,'/hashicorp.png','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffees (id, name, teaser, collection, origin, color, price, image, created_at, updated_at, deleted_at) VALUES (2,'Packer Spiced Latte','Packed with goodness to spice up your images','Origins','Summer 2013','#1FA7EE',350,'/packer.png','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffees (id, name, teaser, collection, origin, color, price, image, created_at, updated_at, deleted_at) VALUES (3,'Vaulatte','Nothing gives you a safe and secure feeling like a Vaulatte','Foundations','Spring 2015','#FFD814',200,'/vault.png','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffees (id, name, teaser, collection, origin, color, price, image, created_at, updated_at, deleted_at) VALUES (4,'Nomadicano','Drink one today and you will want to schedule another','Foundations','Fall 2015','#00CA8E',150,'/nomad.png','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffees (id, name, teaser, collection, origin, color, price, image, created_at, updated_at, deleted_at) VALUES (5,'Terraspresso','Nothing kickstarts your day like a provision of Terraspresso','Origins','Summer 2014','#894BD1',150,'/terraform.png','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffees (id, name, teaser, collection, origin, color, price, image, created_at, updated_at, deleted_at) VALUES (6,'Vagrante espresso','Stdin is not a tty','Origins','Summer 2010','#0E67ED',200,'/vagrant.png','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffees (id, name, teaser, collection, origin, color, price, image, created_at, updated_at, deleted_at) VALUES (7,'Connectaccino','Discover the wonders of our meshy service','Origins','Spring 2014','#F44D8A',250,'/consul.png','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffees (id, name, teaser, collection, origin, color, price, image, created_at, updated_at, deleted_at) VALUES (8,'Boundary Red Eye','Perk up and watch out for your access management','Discoveries','Fall 2020','#F24C53',200,'/boundary.png','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.coffees (id, name, teaser, collection, origin, color, price, image, created_at, updated_at, deleted_at) VALUES (9,'Waypointiato','Deploy with a little foam','Discoveries','Fall 2020','#14C6CB',250,'/waypoint.png','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.ingredients (id, name, created_at, updated_at, deleted_at) VALUES (1,'Espresso','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.ingredients (id, name, created_at, updated_at, deleted_at) VALUES (2,'Semi Skimmed Milk','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.ingredients (id, name, created_at, updated_at, deleted_at) VALUES (3,'Hot Water','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.ingredients (id, name, created_at, updated_at, deleted_at) VALUES (4,'Pumpkin Spice','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.ingredients (id, name, created_at, updated_at, deleted_at) VALUES (5,'Steamed Milk','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                INSERT INTO public.ingredients (id, name, created_at, updated_at, deleted_at) VALUES (6,'Coffee','2024-01-22 00:00:00','2024-01-22 00:00:00',null);
                SELECT pg_catalog.setval('public.coffee_ingredients_id_seq', 16, true);
                SELECT pg_catalog.setval('public.coffees_id_seq', 9, true);
                SELECT pg_catalog.setval('public.ingredients_id_seq', 1, false);
                SELECT pg_catalog.setval('public.order_items_id_seq', 1, false);
                SELECT pg_catalog.setval('public.orders_id_seq', 1, false);
                SELECT pg_catalog.setval('public.tokens_id_seq', 1, false);
                SELECT pg_catalog.setval('public.users_id_seq', 1, false);
            """
            
            # Execute SQL commands to recreate schema
            cursor.execute(schema_commands)
        
        # Commit the changes
        conn.commit()

    finally:
        # Close the connection
        conn.close()

    return {
        'statusCode': 200,
        'body': 'Data successfully written to PostgreSQL'
    }
