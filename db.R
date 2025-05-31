

# Step 0: We need to load the package /// load that package
library(DBI)
library(RSQLite)

# # Step 1: then we need to Create a connection to a SQLite database
condb <- dbConnect(SQLite(), dbname= "test_database.sqlite")  # Creates 'test_database.db' in the current directory
# # dbname= "test_database.sqlite" or dbname = "test_database.db"
# 
# 
# # Step 2: Write a sample table to the database
# # dbWriteTable(con, "example_table", data.frame(id = 1:5, value = letters[1:5]))
# 
# 
# # Step 2: SQL to create 'User' table, 
# create_table_sql = 
# " CREATE TABLE User (
#     uid INTEGER PRIMARY KEY, 
#     uname TEXT
# );"
# 
# # running action Exucte the SQL to create the table 
# dbExecute(condb, create_table_sql)
# 
# # Step 3: Read the table back for retrieve l
# # result <- dbReadTable(con, "example_table")
# # print(result)
# 
# # Step 4: Disconnect from the database
# dbDisconnect(condb)

dbcon = dbConnect(SQLite(), dbname = "myDB.db")
# if db does not exist new will be created 

# Once the connection to the database has been made, you can access the database
# from R using functions from the RSQLite package, such as dbExecute(), dbGetQuery(), and dbSendStatement().
#  create_tb = "CREATE TABLE lesson (
#   lname TEXT NOT NULL, 
#   llength INTEGER NOT NULL
# );"
#  class(dbcon)
#  
# # TO EXUCETE 
#  dbExecute(dbcon, create_tb)
 
 # 
 # insert_sql = "INSERT INTO lesson(lname, llength) VALUES 
 # ('Intro C++', 90),
 #  ('Intro Java', 90),
 #  ('SQL Joins', 60);
 # "
 # dbExecute(dbcon, insert_sql)
 
 # result = dbGetQuery(dbcon,"SELECT * FROM lesson;" )
 # print(result)
 tables = dbListTables(dbcon)
 print(tables)
 
 dbListFields(dbcon, "lesson")
 
 columns = dbListFields
 
 
 
 
 
 
 
 
 
 
 
 
 dbDisconnect(dbcon)