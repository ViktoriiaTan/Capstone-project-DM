#' Fetches outbound links for PubMed IDs
#'
#' This function fetches the outbound links from PubMed database for the given PubMed IDs. It constructs a URL using the PubMed API and fetches the XML response containing the outbound links.
#'
#' @param db A character string indicating the database to fetch the outbound links from.
#' This should be "pubmed" for PubMed.
#'
#' @param ids A numeric or character vector containing the PubMed IDs for which outbound links need to be fetched.
#'
#' @return An XML document containing the outbound links for the given PubMed IDs.
#'
#' @import glue
#' @import httr
#' @import xml2
#' @import dplyr
#' @import tidyverse
#'
#' @examples
#' \dontrun{
#' outlinks <- fetch_pubmed_outlinks("pubmed", c(12345678, 23456789))
#' }
#' @keywords internal
fetch_pubmed_outlinks <- function(db, ids) {
  api_key <- get_key_opt()
  ids_str <- paste(ids, collapse = ",")
  link <- glue("{PUBMED_BASE_ADDRESS}elink.fcgi?dbfrom={db}&id={ids_str}&cmd=prlinks&api_key={api_key}")
  
  xml_doc <- GET(link) %>%
    content("text") %>%
    read_xml()
  return(xml_doc)
}

#' Process PubMed Outlinks
#'
#' This function processes the outlinks from a PubMed XML document and returns a data frame containing PMIDs and their corresponding outlink URLs.
#'
#' @param xml_doc An XML document object representing the PubMed search results.
#' @return A data frame containing columns "PMID" and "Outlink", where "PMID" represents the PubMed ID and "Outlink" represents the outlink URL.
#' @keywords internal
process_pubmed_outlinks <- function(xml_doc) {
  
  create_row <- function(id, url) {
    return(data.frame(
      "PMID" = id,
      "Outlink" = url
    ))
  }
  
  df <- tibble()
  
  for (id_url_set in xml_find_all(xml_doc, ".//IdUrlSet")) {
    
    pmid <- xml_text(xml_find_first(id_url_set, "Id"))
    url_element <- xml_find_first(id_url_set, ".//Url[not(../Provider/NameAbbr='PMC')]")
    
    if (is.na(url_element)) {
      url_element <- xml_find_first(id_url_set, ".//Url")
    }
    url <- get_xml_text_or_default(url_element, "N/A")
    df <- rbind(df, create_row(pmid, url))
  }
  return(df)
}