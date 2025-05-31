# Load libraries
library(DBI)
library(RSQLite)
library(sqldf)


# Create (or connect to) the SQLite database file
dbcon <- dbConnect(SQLite(), dbname = "callingin_lessons.sqlite") 

# Set up the prepared SQL
stmt <- dbSendStatement(dbcon, "INSERT INTO lesson (lname, llength) VALUES (?, ?)")

# Bind values
dbBind(stmt, list("Advanced SQL-", 1))


# Clear the result (important!)
dbClearResult(stmt)
# Confirm it was added
result <- dbGetQuery(dbcon, "SELECT * FROM lesson")
print(result)

# 
# # Append data
# dbWriteTable(dbcon, "lesson", new_lessons, append = TRUE)
#  
# # View updated table
# result <- dbGetQuery(dbcon, "SELECT * FROM lesson")
# print(result)

# new_lessons <- data.frame(
#   lname = c("Data Wrangling", "R Markdown"),
#   llength = c(75, 45)
# )
# 
# # Preview
# print(new_lessons)


# lessons <- dbGetQuery(dbcon, "SELECT * FROM lesson")
# print(lessons)
# 
# 
# write.csv(lessons, file = "lessons_export.csv", row.names = FALSE)

# Create a sample data frame
# lessons_df <- data.frame(
#   lname = c("Intro C++", "Intro Java", "SQL Joins"),
#   llength = c(90, 90, 60)
# )
# # Run SQL on it
# result <-  sqldf("SELECT * FROM lessons_df WHERE llength > 70")
# print(result)


# # Create the 'lesson' table
# create_table_sql <- "
# CREATE TABLE IF NOT EXISTS lesson (
#   lname TEXT NOT NULL,
#   llength INTEGER NOT NULL
# );"
# dbExecute(dbcon, create_table_sql)

# Insert sample data
# insert_sql <- "
# INSERT INTO lesson (lname, llength) VALUES 
#   ('Intro C++', 90),
#   ('Intro Java', 90),
#   ('SQL Joins', 60);
# "
# dbExecute(dbcon, insert_sql)


# Set filter variable
# maxLength <- 100

# # Build the SQL using paste0() to insert the value
# sql <- paste0("SELECT * FROM lesson WHERE llength < ", maxLength)
# # Run the query
# result = dbGetQuery(dbcon, sql)
# 
# 
# # View the result
# print(result)
 
# sql <- "SELECT COUNT(*) AS total, AVG(llength) AS avg_len FROM lesson"
# dbGetQuery(dbcon, sql)
dbClearResult(dbcon)
# Done!
dbDisconnect(dbcon)
