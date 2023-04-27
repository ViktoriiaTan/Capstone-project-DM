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
pubmed_ids <- function(db = "pubmed", query, retmax= 250){
  search_url <- glue("esearch.fcgi?db={db}&term={query}&usehistory=y&retmax={retmax}&api_key={api_key}")
  ids <- glue("{base_address}{search_url}") %>% 
    httr::GET() %>% 
    content("text") %>% 
    read_xml() %>% 
    xml_find_all(".//Id") %>% 
    xml_text()
  
  return(ids)
}

pubmed_content <- function(db= "pubmed", ids = NULL, 
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
articles <- pubmed_content(ids = art_ids)
 
#Retrieving OutLink
pubmed_linkout <- function(db, ids) {
  values <- c()
  
  ids_str <- paste(ids, collapse = ",")
  link_pr <- glue("elink.fcgi?dbfrom={db}&id={ids_str}&cmd=prlinks&api_key={api_key}")
  link <- glue("{base_address}{link_pr}")
  
  response <- GET(link)
  xml <- read_xml(content(response, "text"))
  
  id_url_sets <- xml_find_all(xml, ".//IdUrlSet")
  
  for (id_url_set in id_url_sets) {
    url_element <- xml_find_first(id_url_set, ".//Url[not(../Provider/NameAbbr='PMC')]")
    
    if (is.null(url_element)) {
      url_element <- xml_find_first(id_url_set, ".//Url")
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

doi_results <- function(art){
  pubmed_articles <- xml_find_all(art, ".//PubmedArticle")
  lapply(pubmed_articles, function(article) {
    doi <- xml_find_first(article, ".//PubmedData/ArticleIdList/ArticleId[@IdType='doi']")
    if (is.null(doi)) {
      return()
    } else {
      return(xml_text(doi))
    }
  })
}
doi <- doi_results(articles)


