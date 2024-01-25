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
                CREATE TABLE public.coffee_ingredients3 (id integer NOT NULL,coffee_id integer,ingredient_id integer,quantity integer NOT NULL,unit character varying(50) NOT NULL,created_at timestamp without time zone NOT NULL,updated_at timestamp without time zone NOT NULL,deleted_at timestamp without time zone);
                ALTER TABLE public.coffee_ingredients3 OWNER TO postgres;
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
