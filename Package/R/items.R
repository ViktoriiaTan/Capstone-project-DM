#' Retrieve Information from PubMed Articles
#'
#' These internal functions retrieve various information such as authors, country of publication, DOIs, and PMIDs from PubMed articles.
#' They are used to process the XML elements returned by the PubMed API.
#'
#' @param pubmed_article_element An XML element representing a PubMed article.
#'
#' @return A character string containing the requested information or "N/A" if not available.
#'
#' @keywords internal
#'
#' @import xml2
#' @import dplyr
#' 
#' @rdname items
get_authors <- function(pubmed_article_element){
  authors <- xml_find_all(pubmed_article_element, ".//AuthorList/Author") %>%
    lapply(function(x) {
      last_name <- xml_find_all(x, ".//LastName") %>% xml_text(trim = TRUE)
      initials <- xml_find_all(x, ".//Initials") %>% xml_text(trim = TRUE)
      paste(last_name, initials, sep = " ")
    }) %>%
    paste(collapse = ", ")
  
  return(authors)
}


#' Get Country of Publication from PubMed Articles
#'
#' @rdname items
get_country <- function(pubmed_article_element) {
  
  country_element <- xml_find_first(pubmed_article_element, ".//MedlineJournalInfo/Country")
  return(get_xml_text_or_default(country_element, "N/A"))
}


#' Retrieve DOI from PubMed Articles
#'
#' @rdname items
doi_results <- function(pubmed_article_element){
  doi_element <- xml_find_first(pubmed_article_element, ".//PubmedData/ArticleIdList/ArticleId[@IdType='doi']")
  
  return(get_xml_text_or_default(doi_element, "N/A"))
}

#' Get PMID from PubMed Articles
#'
#' @rdname items
get_pmid <- function(pubmed_article_element) {
  
  pmid_element <- xml_find_first(pubmed_article_element, ".//MedlineCitation/PMID")
  return(get_xml_text_or_default(pmid_element, "N/A"))
}