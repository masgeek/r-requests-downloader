# Load the package required to read JSON files.
library(jsonlite)
library(httr)


# Load sensitive information from environment file .env aat base of project, this wont be committed to github
readRenviron(".env")
user <- Sys.getenv("USER")
pass <- Sys.getenv("PASS")
base_url <- Sys.getenv("BASE_URL") #base URL for the api endpoint
jsonFile <- "application_requests.json"

uri <- paste(base_url,"/v1/stats/requests/json",sep="")


resp <- httr::GET(uri,write_disk(jsonFile, overwrite = TRUE),authenticate(user = user,password = pass),verbose())


if(http_error(resp)==TRUE){
  # error occurred do something I think
}
http_type(resp)


jsonRespParsed<-fromJSON(jsonFile) 

print(jsonRespParsed$content)

#convert to data frame
json_data_frame <- as.data.frame(jsonRespParsed)# do something with the data now

