# Load the package required to read JSON files.

#This package exposes some additional functions to convert json/text to data frame
library(rlist)
#This package exposes some additional functions to convert json/text to data frame
library(jsonlite)

# This package is required for Accessing APIS (HTTP or HTTPS URLS from Web)
library(httr)
#library(curl)

# Load sensitive information from environment file .ev aat base of project
readRenviron(".env")

#url <- "http://localhost:8098/api/v1/stats/requests/json"

url <- "http://localhost:8098/api/v1/stats/requests?size=1"

user <- Sys.getenv("USER")
pass <- Sys.getenv("PASS")


resp <- httr::GET(url,authenticate(user = user,password = pass),verbose())


http_error(resp)
http_type(resp)

jsonRespText<-content(resp,as="text",encoding = 'UTF-8') 

write(jsonRespText, file="export.JSON") # save to a physical file for faster access

jsonRespParsed<-content(resp,as="parsed")

modJson<-jsonRespParsed$content #. Access content element of whole list and ignore other vectors

#Using dplyr and base R
requestData <- list.select(modJson,id,requestDate,countryCode,lat,lon,fullNames,gender,phoneNumber,userType,useCase)

myData <- list.stack(requestData)
