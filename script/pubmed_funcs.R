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
query <- "sepsis AND heparin AND 2020/11[pdat]"
query <- gsub(" ", "+", query)

#Search for articles ids
ncbi_ids <- function(db, query, retmax= 20){
  url <- glue("https://www.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db={db}&term={query}&usehistory=y&retmax={retmax}&api_key={api_key}")
  response <- httr::GET(url)
  doc <- read_xml(response)
  ids <- xml_find_all(doc, ".//Id") %>% 
    xml_text()
  
  return(ids)
}
ncbi_ids <- ids_search(db, query)

#
ncbi_abstract <- function(db = NULL , ids = NULL, 
                         retmode = "uilist", rettype = "xml") {
  ids_str <- paste(ids, collapse = ",")
  url <- glue("https://www.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db={db}&id={ids_str}&retmode={retmode}&rettype={rettype}&api_key={api_key}")
  print(url)
  response <- httr::GET(url)
  doc <- read_xml(response)
  abstracts <- xml_find_all(doc, ".//AbstractText") %>% 
    xml_text()
  
  return(abstracts)
}
abstracts <- ncbi_abstract(db, 33520534)

art_linkout <- function(db, ids) {
  url <- glue("https://www.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom={db}&id={ids}&cmd=lcheck&api_key={api_key}")
  response <- httr::GET(url)
  summary_link <- read_xml(content(response, "text"))
  haslink <- summary_link %>% 
    xml_find_all(".//Id") %>% 
    xml_attr("HasLinkOut")
  
  if (haslink == "Y"){
    url <- glue("https://www.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom={db}&id={ids}&cmd=prlinks&api_key={api_key}")
    response <- httr::GET(url)
    summary_link <- read_xml(content(response, "text"))
    link <- xml_find_all(summary_link, ".//Url") %>% 
    xml_text()
    return(link)
  }
  else {
    return("No link")
  }
}

art_linkout(db, 2011359)
