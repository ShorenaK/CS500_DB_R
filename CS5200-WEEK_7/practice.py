### SQLight and Pyham 
# Shorena Anzhilov pracitce 


# conn = sqlite3.connect('newDB.db')

import sqlite3
import os

# Get the current working directory and define DB path
cwd = os.getcwd()
dbfile = os.path.join(cwd, "committeeDB.sqlite")

# Connect to the database (creates it if it doesn't exist)
dbcon = sqlite3.connect(dbfile)
cursor = dbcon.cursor()

# Drop faculty table if it exists
cursor.execute("DROP TABLE IF EXISTS faculty")

# Create the faculty table
cursor.execute("""
CREATE TABLE IF NOT EXISTS faculty (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    department TEXT NOT NULL
)
""")

# Insert sample data
try:
    cursor.executemany("INSERT INTO faculty (name, department) VALUES (?, ?)", [
        ("Dr. Smith", "Computer Science"),
        ("Dr. Lee", "Mathematics"),
        ("Dr. Patel", "Physics")
    ])
    dbcon.commit()
except sqlite3.IntegrityError:
    print("Could not insert data due to integrity error")

# Run a query to get data
sql = "SELECT * FROM faculty"
cursor.execute(sql)
rs = cursor.fetchall()

# Print each row
for row in rs:
    print(row[1], "/", row[2])  # row[1] = name, row[2] = department

# Confirm database file location
print("DB path:", dbfile)
print("Exists?", os.path.exists(dbfile))

# Close the database connection
dbcon.close()
