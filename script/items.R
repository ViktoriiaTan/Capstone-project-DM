
# Function to get authors from xml
get_authors <- function(articles){
  authors <- xml_find_all(articles, "//Author") %>%
    lapply(function(x) {
      last_name <- xml_find_all(x, ".//LastName") %>% xml_text(trim = TRUE)
      initials <- xml_find_all(x, ".//Initials") %>% xml_text(trim = TRUE)
      paste(last_name, initials, sep = " ")
    }) %>%
    paste(collapse = ", ")
  return(authors)
}


#Get country where the journal is published
get_country <- function(articles){
  country <- xml_find_all(articles, ".//MedlineJournalInfo/Country") %>% 
    xml_text()
  return(country)
}


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
