#' PUBMED_BASE_ADDRESS
#'
#' A constant representing the base address for PubMed API queries.
PUBMED_BASE_ADDRESS <- "https://www.ncbi.nlm.nih.gov/entrez/eutils/"

#' Utility function to retrieve the NCBI API key from R options
#' 
get_key_opt <- function() {
  getOption("ncbi.api.key")
}

#' Find PubMed Article IDs
#'
#' This internal function searches for PubMed article IDs based on the given query.
#'
#' @param db A character string specifying the database to search in. Default is "pubmed".
#' @param query A character string specifying the search query for finding article IDs.
#' @param retmax An integer specifying the maximum number of article IDs to return. Default is 100.
#' @param retstart An integer specifying the starting position for the search. Default is 0.
#'
#' @return A character vector containing the PubMed article IDs that match the search query.
#'
#' @keywords internal
find_pubmed_ids <- function(db = "pubmed", query, retmax, retstart){
  api_key <- get_key_opt()
  query <- gsub(" ", "+", query)
  search_url <- glue("{PUBMED_BASE_ADDRESS}esearch.fcgi?db={db}&term={query}&usehistory=y&retmax={retmax}&retstart={retstart}&api_key={api_key}")
  ids <- httr::GET(search_url) %>% 
    content("text") %>% 
    read_xml() %>% 
    xml_find_all(".//Id") %>% 
    xml_text()
  
  return(ids)
}

#' Fetch PubMed Content
#'
#' This internal function retrieves content from PubMed articles based on a list of PubMed IDs.
#'
#' @param db A character string specifying the database to search in. Default is "pubmed".
#' @param ids A character vector specifying the PubMed article IDs for which to retrieve content.
#' @param retmode A character string specifying the desired format of the retrieved content. Default is "abstract".
#' @param rettype A character string specifying the type of content to retrieve. Default is "xml".
#'
#' @return An XML document containing the content of the specified PubMed articles.
#'
#' @keywords internal
fetch_pubmed_content <- function(db = "pubmed", ids = NULL, 
                           retmode = "abstract", rettype = "xml") {
  api_key <- get_key_opt()
  ids_str <- paste(ids, collapse = ",")
  fetch_url <- glue("{PUBMED_BASE_ADDRESS}efetch.fcgi?db={db}&id={ids_str}&retmode={retmode}&rettype={rettype}&api_key={api_key}")
  
  sum <- httr::GET(fetch_url) %>% 
    content("text") %>% 
    read_xml()
  
  return(sum)
}
