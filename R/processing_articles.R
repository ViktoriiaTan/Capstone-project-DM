#' Process a Set of PubMed Articles
#'
#' This internal function processes a set of PubMed articles and extracts relevant information from the XML elements.
#'
#' @param pubmed_article_set An XML document containing a set of PubMed articles.
#'
#' @return A data frame containing information about the processed PubMed articles.
#'
#' @import dplyr
#' @import xml2
#' @import tidyverse
#'
#' @keywords internal
process_pubmed_articleset <- function(pubmed_article_set) {
  
  df <- tibble()
  
  pubmed_article_elements <- xml_find_all(pubmed_article_set, "//PubmedArticle")
  
  for (pubmed_article_element in pubmed_article_elements) {
    
    article_df <- process_pubmed_article(pubmed_article_element)
    
    df <- rbind(df, article_df)
  }
  
  return(df)
}

#' Process a PubMed Article Element
#'
#' This internal function processes a PubMed article element and extracts relevant information.
#'
#' @param pubmed_article_element An XML element representing a PubMed article.
#'
#' @return A data frame containing information about the processed PubMed article.
#'
#' @import dplyr
#' @import xml2
#'
#' @keywords internal
process_pubmed_article <- function(pubmed_article_element) {
  
  # Extract various information about the article
  article_id <- get_pmid(pubmed_article_element)
  article_title <- get_pubmed_article_title(pubmed_article_element)
  journal_title <- get_pubmed_article_journal(pubmed_article_element)
  abstract <- get_pubmed_article_abstract(pubmed_article_element)
  conclusions <- get_pubmed_article_conclusions(pubmed_article_element)
  results <- get_pubmed_article_results(pubmed_article_element)
  pub_received <- date_r(pubmed_article_element)
  pub_accepted <- date_acc(pubmed_article_element)
  country <- get_country(pubmed_article_element)
  authors <- get_authors(pubmed_article_element)
  doi <- doi_results(pubmed_article_element)
  
  # Create data frame with results
  df <- tibble(
    "PMID" = article_id,
    "Title" = article_title,
    "Abstract" = abstract, 
    "Conclusions" = conclusions,
    "Results" = results,
    "Journal" = journal_title,
    "Authors" = authors,
    "Country" = country,
    "Article received" = pub_received,
    "Article accepted"= pub_accepted,
    "DOI"= doi
  )
  
  return(df)
}