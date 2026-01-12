# PostgreSQL Connection Guide (Python)

This guide explains how to set up a Python project to connect to a PostgreSQL database using **psycopg2**, environment variables, and **SQLAlchemy**.

---

## 1. Install Required Packages

Install the required dependencies using `pip`:

```bash
pip install python-dotenv psycopg2
```

If you plan to use SQLAlchemy as well, install it too:

```bash
pip install sqlalchemy psycopg2
```

---

## 2. Add the Main File to Your Project

Create a file named `main.py` in your project root and add the following code:

```python
import psycopg2
from dotenv import load_dotenv
import os

# Load environment variables from .env
load_dotenv()

# Fetch variables
USER = os.getenv("user")
PASSWORD = os.getenv("password")
HOST = os.getenv("host")
PORT = os.getenv("port")
DBNAME = os.getenv("dbname")

# Connect to the database
try:
    connection = psycopg2.connect(
        user=USER,
        password=PASSWORD,
        host=HOST,
        port=PORT,
        dbname=DBNAME
    )
    print("Connection successful!")
    
    # Create a cursor to execute SQL queries
    cursor = connection.cursor()
    
    # Example query
    cursor.execute("SELECT NOW();")
    result = cursor.fetchone()
    print("Current Time:", result)

    # Close the cursor and connection
    cursor.close()
    connection.close()
    print("Connection closed.")

except Exception as e:
    print(f"Failed to connect: {e}")
```

---

## 3. Configure Environment Variables

Create a `.env` file in your project root and add your database credentials.

### Example (Supabase PostgreSQL)

```env
DATABASE_URL=postgresql://postgres:[YOUR-PASSWORD]@db.vxlbohrtynivparbdahm.supabase.co:5432/postgres
```

If you are using individual variables instead of a single URL:

```env
user=postgres
password=YOUR_PASSWORD
host=db.vxlbohrtynivparbdahm.supabase.co
port=5432
dbname=postgres
```

---

## 4. Connecting Using SQLAlchemy

When using **SQLAlchemy**, always use `postgresql://` (not `postgres://`) as the dialect.

### Example SQLAlchemy Connection

```python
from sqlalchemy import create_engine

engine = create_engine(
    "postgresql+psycopg2://postgres:YOUR_PASSWORD@db.vxlbohrtynivparbdahm.supabase.co:5432/postgres"
)

connection = engine.connect()
print("SQLAlchemy connection successful")
connection.close()
```

### Important Note

✅ Always use:

```
postgresql://
```

❌ Avoid:

```
postgres://
```

This ensures compatibility with SQLAlchemy and avoids connection issues.

---

## Summary

* Use `python-dotenv` to manage environment variables
* Use `psycopg2` for direct PostgreSQL connections
* Use `postgresql+psycopg2://` when working with SQLAlchemy
* Keep credentials secure in a `.env` file
