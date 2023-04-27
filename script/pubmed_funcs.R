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
query <- "sepsis AND 2020[pdat]"
query <- gsub(" ", "+", query)

# Function to search for PubMed article IDs
pubmed_ids <- function(db = "pubmed", query, retmax= 100){
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
  values <- c()
  
  for (id in ids) {
    ids_str <- paste(id, collapse = ",")
    link_pr <- glue("elink.fcgi?dbfrom={db}&id={id}&cmd=prlinks&api_key={api_key}")
    link <- glue("{base_address}{link_pr}")
    
    response <- GET(link)
    xml <- read_xml(content(response, "text"))
    
    link_set_element <- xml_find_first(xml, ".//LinkSet")
    
    url_element <- xml_find_first(link_set_element, ".//Url[not(../Provider/NameAbbr='PMC')]")
    
    if (is.null(url_element)) {
      url_element <- xml_find_first(link_set_element, ".//Url")
    }
    
    if (!is.null(url_element)) {
      values <- c(values, xml_text(url_element))
    } else {
      values <- c(values, NA)
    }
  }
  return(values)
}

linkout <- pubmed_linkout(db, art_ids)

# Retrieve the DOI for a given PubMed article
doi_results <- function(sum){
  pubmed_articles <- xml_find_all(sum, ".//PubmedArticle")
  lapply(pubmed_articles, function(article) {
  doi <- xml_find_first(article, ".//PubmedData/ArticleIdList/ArticleId[@IdType='doi']")
  if (is.null(doi)) {
    return()
  } else {
    return(xml_text(doi))
  }
})
}
doi <- doi_results(summary)


