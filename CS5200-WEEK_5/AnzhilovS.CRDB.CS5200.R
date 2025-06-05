# CS5200 Week 5 " ASSIGNMENT 05.1: Implement a Relational Database"
# Name: Shorena K. Anzhilov
# Date: June, 2025 (Summer Term)
# Description: This script creates and populates an SQLite database in R 

# Load SQLite library 
library(DBI)
library(RSQLite)

# To create and connect to database with name of " assignmentDB-AnzhilovS.sqlitedb "
dbcon <- dbConnect(SQLite(), dbname = "assignmentDB-AnzhilovS.sqlitedb")

# To enable foreign key constraint
dbExecute(dbcon, "PRAGMA foreign_keys = ON;")

# Drop tables if they already exist 
# Dropping from the bottom of the dependency chain up order matters. 
dbExecute(dbcon, "DROP TABLE IF EXISTS EmployeeSupervisor")
dbExecute(dbcon, "DROP TABLE IF EXISTS Organization")
dbExecute(dbcon, "DROP TABLE IF EXISTS OfficeAssignment")
dbExecute(dbcon, "DROP TABLE IF EXISTS Employee")
dbExecute(dbcon, "DROP TABLE IF EXISTS Office")
dbExecute(dbcon, "DROP TABLE IF EXISTS employeeType")
dbExecute(dbcon, "DROP TABLE IF EXISTS amenities")


# ---- Tables Section ----

# Crete Amenities Table
dbExecute(dbcon,
  "CREATE TABLE amenities(
   aID INTEGER PRIMARY KEY,
   name TEXT NOT NULL
  );"
)

# Create EmployeeType Table
dbExecute(dbcon,
  "CREATE TABLE EmployeeType (
  etID INTEGER PRIMARY KEY,
  typeName TEXT NOT NULL
 );"
)

# Create Office Table
dbExecute(dbcon, 
  "CREATE TABLE Office (
    oID INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    perDiemRate REAL NOT NULL,
    aID INTEGER,
    FOREIGN KEY (aID) REFERENCES amenities(aID)
  );"
)

# Crete Employee Table
dbExecute(dbcon, 
 "CREATE TABLE Employee (
    eID TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    title TEXT NOT NULL,
    etID INTEGER NOT NULL,
    FOREIGN KEY (etID) REFERENCES employeeType(etID)
  );"
)

# Junction Table OfficeAssignment (Office ↔ Employee)
dbExecute(dbcon, 
  "CREATE TABLE OfficeAssignment (
    oID INTEGER,
    eID TEXT,
    PRIMARY KEY (oID, eID),
    FOREIGN KEY (oID) REFERENCES Office(oID),
    FOREIGN KEY (eID) REFERENCES Employee(eID)
  );"
)

# Main: Organization (optional grouping entity)
dbExecute(dbcon, 
  "CREATE TABLE Organization (
    oID INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    eID TEXT,
    esID INTEGER,
    FOREIGN KEY (eID) REFERENCES Employee(eID),
    FOREIGN KEY (esID) REFERENCES Employee(eID)
  );"
)

# Junction: EmployeeSupervisor 
dbExecute(dbcon, 
   "CREATE TABLE EmployeeSupervisor (
    eID TEXT,
    esID INTEGER,
    PRIMARY KEY (eID, esID),
    FOREIGN KEY (eID) REFERENCES Employee(eID),
    FOREIGN KEY (esID) REFERENCES Employee(eID)
  );"
)

# ---- Inseration Section to Insert data ----

# Amenities
dbExecute(dbcon, "INSERT INTO Amenities (aID, name) VALUES (1, 'WiFi')")
dbExecute(dbcon, "INSERT INTO Amenities (aID, name) VALUES (2, 'Projector')")

# EmployeeType
dbExecute(dbcon, "INSERT INTO EmployeeType (etID, typeName) VALUES (1, 'Internal')")
dbExecute(dbcon, "INSERT INTO EmployeeType (etID, typeName) VALUES (2, 'External')")

# Office
dbExecute(dbcon, "INSERT INTO Office (oID, name, perDiemRate, aID) VALUES (101, 'Main Office', 111.00, 1)")
dbExecute(dbcon, "INSERT INTO Office (oID, name, perDiemRate, aID) VALUES (102, 'Conference Room', 222.00, 2)")

# Employee
dbExecute(dbcon, "INSERT INTO Employee (eID, name, title, etID) VALUES ('E001', 'Mike Hall', 'Manager', 1)")
dbExecute(dbcon, "INSERT INTO Employee (eID, name, title, etID) VALUES ('E002', 'Shorena Anzhilov', 'Developer', 2)")

# OfficeAssignment
dbExecute(dbcon, "INSERT INTO OfficeAssignment (oID, eID) VALUES (101, 'E001')")
dbExecute(dbcon, "INSERT INTO OfficeAssignment (oID, eID) VALUES (102, 'E002')")

# Organization
dbExecute(dbcon, "INSERT INTO Organization (oID, name, eID, esID) VALUES (1, 'Engineering', 'E001', NULL)")

# EmployeeSupervisor
dbExecute(dbcon, "INSERT INTO EmployeeSupervisor (eID, esID) VALUES ('E002', 'E001')")

# List all tables in the database
print(dbListTables(dbcon))

# Preview Employees
print(dbGetQuery(dbcon, "SELECT * FROM Employee"))

# Show Employee Types with Names
print(dbGetQuery(dbcon, "
  SELECT e.eID, e.name, t.typeName
  FROM Employee e
  JOIN EmployeeType t ON e.etID = t.etID
"))

# -------- Verification queries ----------

# Preview Office Assignments
print(dbGetQuery(dbcon, "
  SELECT oa.oID, oa.eID, e.name
  FROM OfficeAssignment oa
  JOIN Employee e ON oa.eID = e.eID
"))

# Employees and their Supervisors
print(dbGetQuery(dbcon, "
  SELECT emp.name AS employee, sup.name AS supervisor
  FROM EmployeeSupervisor es
  JOIN Employee emp ON es.eID = emp.eID
  JOIN Employee sup ON es.esID = sup.eID
"))

# Offices with Amenities 
print(dbGetQuery(dbcon, "
  SELECT o.oID AS officeID, a.name AS amenity
  FROM Office o
  JOIN amenities a ON o.aID = a.aID
"))

# Employees in Organizations 
print(dbGetQuery(dbcon, "
  SELECT org.name AS orgName, emp.name AS employee
  FROM Organization org
  JOIN Employee emp ON org.eID = emp.eID
"))

# Disconnect from DB
dbDisconnect(dbcon)