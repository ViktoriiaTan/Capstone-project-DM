# Load required packages
library(httr)
library(glue)
library(xml2)
library(tidyverse)

api_key <- rstudioapi::askForPassword()
api_key <- gsub('"', '', api_key)

# Define the base URL for different API calls
base_address <- "https://www.ncbi.nlm.nih.gov/entrez/eutils/"

# Define the search parameters
db <- "pubmed"
query <- "sepsis AND heparin AND 2020/11[pdat]"
query <- gsub(" ", "+", query)

# Function to search for PubMed article IDs
pubmed_ids <- function(db = "pubmed", query, retmax= 20){
  search_url <- glue("esearch.fcgi?db={db}&term={query}&usehistory=y&retmax={retmax}&api_key={api_key}")
  ids <- glue("{base_address}{search_url}") %>% 
    httr::GET() %>% 
    content("text") %>% 
    read_xml() %>% 
    xml_find_all(".//Id") %>% 
    xml_text()
  
  return(ids)
}

pubmed_content <- function(db , ids = NULL, 
                           retmode = "abstract", rettype = "xml") {
  
  ids_str <- paste(ids, collapse = ",")
  fetch_url <- glue("efetch.fcgi?db={db}&id={ids_str}&retmode={retmode}&rettype={rettype}&api_key={api_key}")
  
  sum <- glue("{base_address}{fetch_url}") %>% 
    httr::GET() %>% 
    content("text") %>% 
    read_xml()
  return(sum)
}
art_ids <- pubmed_ids( query = query)
summary <- pubmed_content(db, art_ids)
 
#Retrieving OutLink
pubmed_linkout <- function(db, ids) {
  ids_str <- paste(ids, collapse = ",")
  link_check <- glue("elink.fcgi?dbfrom={db}&id={ids_str}&cmd=lcheck&api_key={api_key}")
  link_url <- glue("{base_address}{link_check}")
  response <- GET(link_url)
  xml <- read_xml(content(response, "text")) 
  link_ids <- xml_text(xml_find_all(xml, "//Id[@HasLinkOut='Y']"))
  
  ids_str <- paste(link_ids, collapse = ",")
  link_pr <- glue("elink.fcgi?dbfrom={db}&id={ids_str}&cmd=prlinks&api_key={api_key}")
  link <- glue("{base_address}{link_pr}")
  
  response <- GET(link)
  xml <- read_xml(content(response, "text"))
  
  ext_links <- xml_text(xml_find_all(xml, ".//ObjUrl[not(Provider/NameAbbr='PMC')]/Url"))
    
  return(ext_links)
}

linkout <- pubmed_linkout(db, art_ids)

# Retrieve the DOI for a given PubMed article
doi <- xml_find_all(summary, ".//PubmedData/ArticleIdList/ArticleId[@IdType='doi']") %>%
  xml_text()
