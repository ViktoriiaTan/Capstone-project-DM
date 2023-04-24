#install.packages("httr")
#install.packages("glue")
#install.packages("xml2")
library(httr)
library(glue)
library(xml2)
library(tidyverse)
api_key <- rstudioapi::askForPassword()
api_key <- gsub('"', '', api_key)

base_address <- "https://www.ncbi.nlm.nih.gov/entrez/eutils/"
db <- "pubmed"
query <- "sepsis+AND+heparin+AND+2020[pdat]"

ids_search <- function(db, query, retmax, api){
  url <- glue("https://www.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db={db}&term={query}&usehistory=y&retmax={retmax}&api_key={api}")
  response <- httr::GET(url)
  doc <- read_xml(response)
  ids <- xml_find_all(doc, ".//Id") %>% 
    xml_text()
  return(ids)
}
article_ids <- ids_search(db, query, 100, api_key)