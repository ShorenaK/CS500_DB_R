# {r inspect_csv, eval = T, warning = F}

# Clear workspace
rm(list = ls())

# Load required libraries
if (!require("tidyverse")) install.packages("tidyverse")
library(tidyverse)

# Load the CSV file (full path to the file)
csv_file <- "restaurant-visits-139874.csv"

# Read the file
restaurant_data <- read_csv(csv_file)
file.exists(csv_file)
# Read first few lines of the file directly
readLines(csv_file, n = 10)


# Look at first few rows
head(restaurant_data)

# Check structure of data
str(restaurant_data)

# Quick summary of data types and values
summary(restaurant_data)

