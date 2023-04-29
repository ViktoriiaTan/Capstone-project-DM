# Load required packages
library(httr)
library(glue)
library(xml2)
library(tidyverse)

api_key <- rstudioapi::askForPassword()
api_key <- gsub('"', '', api_key)

# Define the base URL for different API calls
PUBMED_BASE_ADDRESS <- "https://www.ncbi.nlm.nih.gov/entrez/eutils/"

# Define the search parameters
db <- "pubmed"
query <- "sepsis AND 2020[pdat]"
query <- gsub(" ", "+", query)


# Function to search for PubMed article IDs
find_pubmed_ids <- function(db = "pubmed", query, retmax= 100, retstart = 0){
  search_url <- glue("{PUBMED_BASE_ADDRESS}esearch.fcgi?db={db}&term={query}&usehistory=y&retmax={retmax}&api_key={api_key}")
  ids <- httr::GET(search_url) %>% 
    content("text") %>% 
    read_xml() %>% 
    xml_find_all(".//Id") %>% 
    xml_text()
  
  return(ids)
}

fetch_pubmed_content <- function(db = "pubmed", ids = NULL, 
                           retmode = "abstract", rettype = "xml") {
  ids_str <- paste(ids, collapse = ",")
  fetch_url <- glue("{PUBMED_BASE_ADDRESS}efetch.fcgi?db={db}&id={ids_str}&retmode={retmode}&rettype={rettype}&api_key={api_key}")
  
  sum <- httr::GET(fetch_url) %>% 
    content("text") %>% 
    read_xml()
  
  return(sum)
}
