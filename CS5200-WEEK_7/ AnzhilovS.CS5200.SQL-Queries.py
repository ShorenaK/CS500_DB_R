# CS5200 Week 7 – ASSIGNMENT 07.2: Query a Database with SQL in Python
# Name: Shorena K. Anzhilov
# Date: June, 2025 - Summer Term
# Obective: This Python script connects to an SQLite database and executes
# multiple SQL queries to extract supplier and product data.

import sqlite3

# Connect to the SQLite database file 
conn = sqlite3.connect('OrdersDB.sqlitedb.db')

# Create a cursor object to execute SQL queries
cursor = conn.cursor()

# The print staemtn for testing 
print("Connected to OrdersDB.sqlitedb.db")

# Quering a Supplier name, contact name, and country sorted by name

cursor.execute("""
    SELECT SupplierName, ContactName, Country
    FROM Suppliers
    ORDER BY SupplierName ASC
""")
rows = cursor.fetchall()

for row in rows:
    print("Supplier name, contact name, and country sorted by name:", row[0], "|", row[1], "|", row[2])
    
    
# Quering a total number of different products per supplier

cursor.execute("""
    SELECT s.SupplierName, COUNT(p.ProductID) AS ProductCount
    FROM Suppliers s
    JOIN Products p ON s.SupplierID = p.SupplierID
    GROUP BY s.SupplierID
    ORDER BY ProductCount DESC
""")
rows = cursor.fetchall()

for row in rows:
    print("Total number of different products per supplier:", row[0], "|", row[1], "products")


# Quering countries with more than 10 suppliers
cursor.execute("""
    SELECT Country, COUNT(SupplierID) AS SupplierCount
    FROM Suppliers
    GROUP BY Country
    HAVING SupplierCount > 10
    ORDER BY SupplierCount DESC
""")
rows = cursor.fetchall()

for row in rows:
    print("Countries with more than 10 suppliers:", row[0], "|", row[1], "suppliers")
else:
    print("No countries have more than 10 suppliers.")


# Commit and close connection
conn.commit()
conn.close()
print("\nConnection closed. All tasks completed.")
