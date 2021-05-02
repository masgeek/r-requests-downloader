# Load the package required to read JSON files.
library(jsonlite)
library(httr)


# Load sensitive information from environment file .ev aat base of project
readRenviron(".env")

uri <- "http://localhost:8098/api/v1/stats/requests/json"

user <- Sys.getenv("USER")
pass <- Sys.getenv("PASS")
jsonFile <- "application_requests.json"

resp <- httr::GET(uri,write_disk(jsonFile, overwrite = TRUE),authenticate(user = user,password = pass),verbose())


if(http_error(resp)==TRUE){
  # error occurred do something I think
}
http_type(resp)


jsonRespParsed<-fromJSON(jsonFile) 

print(jsonRespParsed$content)

#convert to data frame
json_data_frame <- as.data.frame(jsonRespParsed)# do something with the data now

