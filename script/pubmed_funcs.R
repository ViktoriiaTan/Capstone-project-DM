library(httr)

api_key <- rstudioapi::askForPassword()
api_key <- gsub('"', '', api_key)

base_address <- "https://www.ncbi.nlm.nih.gov/entrez/eutils/%s"
db <- "pubmed"
query <- "sepsis+AND+heparin+AND+2020[pdat]"

search_endp <- sprintf("esearch.fcgi?db=%s&term=%s&usehistory=y&api_key=%s", db, query, api_key)

url <- sprintf(base_address, search_endp)
resp <- GET(url)