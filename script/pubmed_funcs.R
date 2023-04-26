# Load required packages
library(httr)
library(glue)
library(xml2)
library(tidyverse)

api_key <- rstudioapi::askForPassword()
api_key <- gsub('"', '', api_key)

# Define the base URL and URL templates for different API calls
base_address <- "https://www.ncbi.nlm.nih.gov/entrez/eutils/"
search_url <- "esearch.fcgi?db={db}&term={query}&usehistory=y&retmax={retmax}&api_key={api_key}"
fetch_url <- "efetch.fcgi?db={db}&id={ids_str}&retmode={retmode}&rettype={rettype}&api_key={api_key}"
link_check <- "elink.fcgi?dbfrom={db}&id={ids}&cmd=lcheck&api_key={api_key}"
link_pr <- "elink.fcgi?dbfrom={db}&id={ids}&cmd=prlinks&api_key={api_key}"

# Define the search parameters
db <- "pubmed"
query <- "sepsis AND heparin AND 2020/11[pdat]"
query <- gsub(" ", "+", query)

# Function to search for PubMed article IDs
pubmed_ids <- function(db = "pubmed", query, retmax= 20){
  search_url <- glue(search_url)
  
  ids <- glue("{base_address}{search_url}") %>% 
    httr::GET() %>% 
    content("text") %>% 
    read_xml() %>% 
    xml_find_all(".//Id") %>% 
    xml_text()
  
  return(ids)
}
art_ids <- pubmed_ids(db, "endometriosis", 4)

#Retrieving OutLink
pubmed_linkout <- function(db, ids) {
  link_check <- glue(link_check)
  
  haslink <- glue("{base_address}{link_check}") %>% 
    GET() %>% 
    content("text") %>% 
    read_xml() %>% 
    xml_find_all(".//Id") %>% 
    xml_attr("HasLinkOut")
  
  if (haslink == "Y"){
    link_pr <- glue(link_pr)
    
    link <- glue("{base_address}{link_pr}") %>% 
      httr::GET() %>% 
      content("text") %>% 
      read_xml() %>% 
      xml_find_all(".//Url") %>% 
      xml_text()
    
    return(link)
  }else {
    return("No link")
  }
}

linkout <- pubmed_linkout(db, 2011359)

# Retrieve the DOI for a given PubMed article
doi <- xml_find_all(summary, ".//ArticleId[@IdType='doi']") %>%
  xml_text()
