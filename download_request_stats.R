# Load required packages for JSON file handling and HTTP requests
library(jsonlite)
library(RCurl)

# Load sensitive information from environment file (.env) at the project root. This file is not committed to version control.
readRenviron(".env")

# Retrieve credentials and base URL from environment variables
user <- Sys.getenv("USER")
pass <- Sys.getenv("PASS")
base_url <- Sys.getenv("BASE_URL")  # Base URL for the API endpoint

# Set target file for downloaded JSON data
json_file <- "json_application_requests.json"

# Construct the API URI
uri <- paste0(base_url, "/v1/stats/requests/json")

# Encode user credentials for Basic Authentication
auth <- base64Encode(paste(user, pass, sep=":"))
headers <- c(Authorization = paste("Basic", auth))

# Define a function to download data from a URL and save to file
download_json <- function(url, file) {
  file_connection <- CFILE(file, mode="wb")
  response <- curlPerform(
    url = url,
    writedata = file_connection@ref,
    noprogress = FALSE,
    .opts = list(httpheader = headers)
  )
  close(file_connection)
  return(response)
}

# Download JSON data from the API
print(paste("Downloading from", uri))
response <- download_json(uri, json_file)

# Parse the downloaded JSON file and convert content to a data frame
json_response <- fromJSON(json_file)
json_data_frame <- as.data.frame(json_response$content)

# Print completion message
print("Download completed. Data is ready for processing.")
