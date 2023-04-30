#' Retrieve XML Text or Default Value
#'
#' These internal functions retrieve text from XML elements or return a default value if the element is not available.
#' They are used to process the XML elements returned by the PubMed API.
#'
#' @param xml_element An XML element from which to retrieve text.
#' @param default A default value to return if the XML element is not available.
#'
#' @return A character string containing the text from the XML element or the default value.
#'
#' @keywords internal
#'
#' @import xml2
get_xml_text_or_default <- function(xml_element, default) {
  
  if (is.na(xml_element)) {
    return(default)
  } else {
    return(xml_text(xml_element, trim = TRUE))
  }
}

#' Get Article and Journal Titles from PubMed Articles
#'
#' These internal functions retrieve article and journal titles from PubMed articles.
#' They are used to process the XML elements returned by the PubMed API.
#'
#' @param pubmed_article_element An XML element representing a PubMed article.
#'
#' @return A character string containing the article or journal title or "N/A" if not available.
#'
#' @keywords internal
#'
#' @import xml2
#' @rdname get_xml_text_or_default
get_pubmed_article_title <- function(pubmed_article_element){
  title_element <- xml_find_first(pubmed_article_element, ".//Article/ArticleTitle")
  return(get_xml_text_or_default(title_element, "N/A"))
}

#' @rdname get_xml_text_or_default
get_pubmed_article_journal <- function(pubmed_article_element){
  title_element <- xml_find_first(pubmed_article_element, ".//Journal/Title")
  return(get_xml_text_or_default(title_element, "N/A"))
}

