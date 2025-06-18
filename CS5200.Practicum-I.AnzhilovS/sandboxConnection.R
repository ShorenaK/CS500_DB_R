# Clear workspace
rm(list = ls())

# Install/load required packages
if (!require("DBI")) install.packages("DBI")
if (!require("RMySQL")) install.packages("RMySQL")

library(DBI)
library(RMySQL)

# ✅ Replace these values with yours:
host <- "cs5200-practicum-db.c7cm4qiou66y.us-east-2.rds.amazonaws.com"
dbname <- "cs5200"
user <- "admin"
password <- "Ab20165555"

# ✅ Connect to your MySQL RDS
con <- dbConnect(
  RMySQL::MySQL(),
  host = host,
  port = 3306,
  dbname = dbname,
  user = user,
  password = password
)

# ✅ Check if connection is working
print("Connection successful. Here are your tables (if any):")
print(dbListTables(con))

# ✅ Always disconnect
dbDisconnect(con)
