### CS5200 - ASSIGNMENT 02.1 - Build File Data Store
### Shorena K. Anzhilov 
# Summer 2025

# Global variables
rootDir <- "orderDB"
intakeDir <- "docTemp"
rejectDir <- "rejected"

# Setup folders if they don't exist
setupDB <- function() {
  for (folder in c(rootDir, intakeDir, rejectDir)) {
    if (!dir.exists(folder)) {
      dir.create(folder)
      cat("Created folder:", folder, "\n")
    } else {
      cat("Folder already exists:", folder, "\n")
    }
  }
}

# Validate file naming such as ClientName.Date.ext
checkFile <- function(fileName) {
  parts <- unlist(strsplit(fileName, "\\."))
  if (length(parts) != 3) return(FALSE)
  
  client <- parts[1]
  dateStr <- parts[2]
  ext <- parts[3]
  
  # Validate date format DD-MM-YY
  if (!grepl("^\\d{2}-\\d{2}-\\d{2}$", dateStr)) return(FALSE)
  
  # Validate extension
  validExt <- c("xml", "json", "csv")
  if (!(ext %in% validExt)) return(FALSE)
  
  return(TRUE)
}

# Extract customer name before first dot
getCustomerName <- function(fileName) {
  parts <- unlist(strsplit(fileName, "\\."))
  if (length(parts) >= 1) return(parts[1])
  return("Invalid")
}

# Extract order date between first and second dot
getOrderDate <- function(fileName) {
  parts <- unlist(strsplit(fileName, "\\."))
  if (length(parts) >= 2) return(parts[2])
  return("Invalid")
}

# Extract extension after last dot
getExtension <- function(fileName) {
  parts <- unlist(strsplit(fileName, "\\."))
  if (length(parts) >= 3) return(parts[3])
  return("Invalid")
}

# Generate destination path
genOrderPath <- function(root, fileName) {
  date <- getOrderDate(fileName)
  ext <- getExtension(fileName)
  return(file.path(root, date, ext))
}

# Store a single valid file
storeOrderFile <- function(intakeFolder, file, docFolder = rootDir) {
  if (!checkFile(file)) return(FALSE)
  
  srcPath <- file.path(intakeFolder, file)
  if (!file.exists(srcPath)) return(FALSE)
  
  customer <- getCustomerName(file)
  destPath <- genOrderPath(docFolder, file)
  destFile <- file.path(destPath, customer)
  
  if (!dir.exists(destPath)) {
    dir.create(destPath, recursive = TRUE)
  }
  
  # Copy and check file sizes
  if (file.copy(srcPath, destFile, overwrite = TRUE)) {
    if (file.info(srcPath)$size == file.info(destFile)$size) {
      file.remove(srcPath)
      return(TRUE)
    }
  }
  return(FALSE)
}

# Process all files from intake folder
storeAllOrders <- function(intakeFolder, rootFolder) {
  files <- list.files(intakeFolder, full.names = FALSE)
   
  if (length(files) == 0) {
    cat("No files to process.\n")
    return()
  }
  
  processedCount <- 0
  unprocessedFiles <- c()
  
  for (file in files) {
    cat("Processing file:", file, "\n")
    
    fullPath <- file.path(intakeFolder, file)
    
    if (!file.exists(fullPath) || file.info(fullPath)$size == 0 || !checkFile(file)) {
      cat("Rejected file:", file, "\n")
      file.copy(fullPath, file.path(rejectDir, file), overwrite = TRUE)
      file.remove(fullPath)
      unprocessedFiles <- c(unprocessedFiles, file)
      next
    }
    
    success <- storeOrderFile(intakeFolder, file, rootFolder)
    if (success) {
      processedCount <- processedCount + 1
    } else {
      file.copy(fullPath, file.path(rejectDir, file), overwrite = TRUE)
      file.remove(fullPath)
      unprocessedFiles <- c(unprocessedFiles, file)
    }
  }
  
  cat("\nSuccessfully processed", processedCount, "files.\n")
  if (length(unprocessedFiles) > 0) {
    cat("These files were not processed:\n")
    cat(unprocessedFiles, sep = "\n")
  }
}

# Reset document database
 resetDB <- function(root) {
 if (!dir.exists(root)) return()
  files <- list.files(root, recursive = TRUE, full.names = TRUE)
  subdirs <- list.dirs(root, recursive = TRUE, full.names = TRUE)[-1]

  for (f in files) {
    file.remove(f)
  }

  for (d in rev(subdirs)) {
    unlink(d, recursive = TRUE)
  }

  cat("Reset complete: cleared contents of", root, "\n")
}

# Main function
main <- function() {
  cat("=== Document Store Program Started ===\n\n")
  
  setupDB()
  
  # Run tests
  cat("\n--- Testing checkFile() ---\n")
  cat(checkFile("KlainerIndustries.26-11-24.xml"), "\n")  
  cat(checkFile("Wrong.Name.Format.txt"), "\n")         
  
  cat("\n--- Testing getCustomerName() ---\n")
  cat(getCustomerName("KlainerIndustries.26-11-24.xml"), "\n")
  
  cat("\n--- Testing getOrderDate() ---\n")
  cat(getOrderDate("KlainerIndustries.26-11-24.xml"), "\n")
  
  cat("\n--- Testing getExtension() ---\n")
  cat(getExtension("KlainerIndustries.26-11-24.xml"), "\n")
  
  cat("\n--- Testing genOrderPath() ---\n")
  cat(genOrderPath(rootDir, "KlainerIndustries.26-11-24.xml"), "\n")
  
  cat("\n--- Testing storeOrderFile() ---\n")
  storeOrderFile(intakeDir, "KlainerIndustries.26-11-24.xml")
  
  cat("\n--- Testing storeAllOrders() ---\n")
  storeAllOrders(intakeDir, rootDir)
  
  cat("\n--- Testing resetDB() ---\n")
  # Uncomment to clear document database after each run
  # resetDB(rootDir)
  
  cat("\n=== Program Complete ===\n")
}

# Run the program
main()
