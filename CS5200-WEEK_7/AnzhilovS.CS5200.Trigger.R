# CS5200 Week 7 – ASSIGNMENT 07.1 -- Build Triggers in SQLite
# Name: Shorena K. Anzhilov
# Date: June, 2025 Summer Term
# Objectives: This R script connects to the OrderDB SQLite database,
#              displays existing data, and sets up infrastructure
#              for triggers and a fact table called SalesFacts.

library(DBI)
library(RSQLite)

# Connect to the correct SQLite database file.
con <- dbConnect(SQLite(), "OrdersDB.sqlitedb.db")

# Drop triggers and SalesFacts table if they already exist.
dbExecute(con, "DROP TRIGGER IF EXISTS trg_after_insert_orderdetail")
dbExecute(con, "DROP TRIGGER IF EXISTS trg_after_update_orderdetail")
dbExecute(con, "DROP TRIGGER IF EXISTS trg_after_delete_orderdetail")
dbExecute(con, "DROP TABLE IF EXISTS SalesFacts")

# List all existed tables of DB.
dbListTables(con)
 
---- 1 ----
# Creting new SalesFacts table.
dbExecute(con, "
CREATE TABLE SalesFacts (
    sfID INTEGER PRIMARY KEY AUTOINCREMENT,
    productID INTEGER,
    TotalUnits NUMERIC,
    TotalRevenue NUMERIC,
    FOREIGN KEY (productID) REFERENCES Products(ProductID)
)")

---- 2 ----
# Populate SalesFacts using SQL 
dbExecute(con, "
INSERT INTO SalesFacts (productID, TotalUnits, TotalRevenue)
SELECT 
    od.ProductID,
    SUM(od.Quantity),
    SUM(od.Quantity * p.Price)
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY od.ProductID")

---- 3 ----
# Triger for after INSERT, automatically recalculate the totals for a product in SalesFacts whenever a new row is inserted. 
dbExecute(con, "
CREATE TRIGGER trg_after_insert_orderdetail
AFTER INSERT ON OrderDetails
BEGIN
    DELETE FROM SalesFacts;
    INSERT INTO SalesFacts (productID, TotalUnits, TotalRevenue)
    SELECT 
        od.ProductID,
        SUM(od.Quantity),
        SUM(od.Quantity * p.Price)
    FROM OrderDetails od
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY od.ProductID;
END;")

---- 4 ----
# Trigger for after UPDATE,recalculate the SalesFacts totals when an order’s quantity or product changes.
dbExecute(con, "
CREATE TRIGGER trg_after_update_orderdetail
AFTER UPDATE ON OrderDetails
BEGIN
    DELETE FROM SalesFacts;
    INSERT INTO SalesFacts (productID, TotalUnits, TotalRevenue)
    SELECT 
        od.ProductID,
        SUM(od.Quantity),
        SUM(od.Quantity * p.Price)
    FROM OrderDetails od
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY od.ProductID;
END;")

---- 5 ----
# After DELETE trigger, recalculates SalesFacts totals when an order is deleted.
dbExecute(con, "
CREATE TRIGGER trg_after_delete_orderdetail
AFTER DELETE ON OrderDetails
BEGIN
    DELETE FROM SalesFacts;
    INSERT INTO SalesFacts (productID, TotalUnits, TotalRevenue)
    SELECT 
        od.ProductID,
        SUM(od.Quantity),
        SUM(od.Quantity * p.Price)
    FROM OrderDetails od
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY od.ProductID;
END;")

---- 6 ----
# Triggers with Test Operations Delete, Insert , Update.
dbExecute(con, "DELETE FROM SalesFacts") # cleanyp any prevouse test data
dbExecute(con, "DELETE FROM OrderDetails WHERE OrderDetailID = 111")

dbExecute(con, "INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity) VALUES (111, 10250, 1, 5)")
dbExecute(con, "UPDATE OrderDetails SET Quantity = 10 WHERE OrderDetailID = 111")

# Print statement for testing 
print(dbGetQuery(con, "SELECT * FROM SalesFacts LIMIT 10"))

# Disconnect
dbDisconnect(con)
