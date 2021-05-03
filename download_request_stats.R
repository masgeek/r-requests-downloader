# Load the package required to read JSON files.
library(jsonlite)
library(RCurl)

# Load sensitive information from environment file .env aat base of project, this wont be committed to github
readRenviron(".env")
user <- Sys.getenv("USER")
pass <- Sys.getenv("PASS")
base_url <- Sys.getenv("BASE_URL") #base URL for the api endpoint
jsonFile <- "json_application_requests.json"

uri <- paste(base_url,"/v1/stats/requests/json",sep="")
auth <- base64Encode(paste(user,sep=":",pass))

hdr=c(Authorization=paste("Basic",auth))

bdown=function(url, file){
  f = CFILE(file, mode="wb")
  a = curlPerform(url = url, writedata = f@ref, noprogress=FALSE, .opts = list(httpheader=hdr)  )
  close(f)
  return(a)
}

print(paste("Downloading from",uri))
ret = bdown(uri, jsonFile)

jsonRespParsed<-fromJSON(jsonFile) 
# convert to data frame
json_data_frame <- as.data.frame(jsonRespParsed$content)

print("Download completed, do something with the data now")
