# Load necessary library
library(RSQLite)

# Create a new SQLite database
db <- dbConnect(SQLite(), dbname = "sample.db")
# Drop the table
dbExecute(db, "DROP TABLE IF EXISTS customers")
# Create a table named 'customers'
dbExecute(db, "
  CREATE TABLE IF NOT EXISTS customers (
    cid INTEGER PRIMARY KEY,
    name TEXT,
    email TEXT
  )
")

# Insert 3 rows of synthetic data into the 'customers' table
dbExecute(db, "INSERT INTO customers (cid, name, email) VALUES (1, 'Alice', 'alice@example.com')")

dbExecute(db, "INSERT INTO customers (cid, name, email) VALUES (2, 'Bob', 'bob@example.com')")

dbExecute(db, "INSERT INTO customers (cid, name, email) VALUES (3, 'Charlie', 'charlie@example.com')")


# dbGetQuery(db, "SELECT * FROM customers")
# Retrieve all rows in the 'customers' table and display them
customers <- dbGetQuery(db, "SELECT * FROM customers")
print(customers)
