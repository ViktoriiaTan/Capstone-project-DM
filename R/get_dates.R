#' Build Date Strings and Retrieve Manuscript Dates
#'
#' These internal functions build date strings and retrieve manuscript dates (received and accepted) from PubMed articles.
#' They are used to process the XML elements returned by the PubMed API.
#'
#' @param date_node An XML node representing a date element.
#' @param pubmed_article_element An XML element representing a PubMed article.
#'
#' @return A character string containing the formatted date or "N/A" if not available.
#'
#' @import glue
#' @import xml2
#' 
#' @keywords internal
build_date <- function(date_node) {
  year <- xml_text(xml_find_first(date_node, ".//Year"))
  month <- xml_text(xml_find_first(date_node, ".//Month"))
  day <- xml_text(xml_find_first(date_node, ".//Day"))
  return (glue("{year}-{month}-{day}"))
}

#' Date Received
#'
#' This function extracts the received date from a PubMed article element.
#'
#' @param pubmed_article_element An XML node containing a PubMed article element.
#' @return A character string representing the received date or "N/A" if not found.
#' @rdname date
date_r <- function(pubmed_article_element) {

  date_element <- xml_find_first(pubmed_article_element, ".//PubMedPubDate[@PubStatus='received']") 
  
  if (is.na(date_element)) {
    return("N/A")
  }
  return(build_date(date_element))
}

#' Date Accepted
#'
#' This function extracts the accepted date from a PubMed article element.
#'
#' @param pubmed_article_element An XML node containing a PubMed article element.
#' @return A character string representing the accepted date or "N/A" if not found.
#' @rdname date
date_acc <- function(pubmed_article_element) {
  date_element <- xml_find_first(pubmed_article_element, ".//PubMedPubDate[@PubStatus='accepted']")
  
  if (is.na(date_element)) {
    return("N/A")
  }
  
  return(build_date(date_element))
}