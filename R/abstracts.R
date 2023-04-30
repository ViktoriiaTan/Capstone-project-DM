#' Retrieve Abstracts, Conclusions, and Results from PubMed Articles
#'
#' These internal functions retrieve abstracts, conclusions, and results from PubMed articles.
#' They are used to process the XML elements returned by the PubMed API.
#'
#' @param pubmed_article_element An XML element representing a PubMed article.
#'
#' @return A character string containing the abstract, conclusion, or result, depending on the function.
#'
#' @keywords internal
#'
#' @import xml2
get_pubmed_article_abstract <- function(pubmed_article_element){
  abstract_element <- xml_find_first(pubmed_article_element, ".//Article/Abstract")
  return(get_xml_text_or_default(abstract_element, "N/A"))
}

#' @rdname get_pubmed_article_abstract
get_pubmed_article_conclusions <- function(pubmed_article_element) {
  
  element <- xml_find_first(pubmed_article_element, ".//Article/Abstract/AbstractText[@NlmCategory='CONCLUSIONS']")
  
  return(get_xml_text_or_default(element, "N/A"))
}

#' @rdname get_pubmed_article_abstract
get_pubmed_article_results <- function(pubmed_article_element) {
  
  element <- xml_find_first(pubmed_article_element, ".//Article/Abstract/AbstractText[@NlmCategory='RESULTS']")
  
  return(get_xml_text_or_default(element, "N/A"))
}