# Function to get authors from xml
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


#Get country where the journal is published
get_country <- function(pubmed_article_element) {
  
  country_element <- xml_find_first(pubmed_article_element, ".//MedlineJournalInfo/Country")
  return(get_xml_text_or_default(country_element, "N/A"))
}


# Retrieve the DOI for a given PubMed article
doi_results <- function(pubmed_article_element){
  doi_element <- xml_find_first(pubmed_article_element, ".//PubmedData/ArticleIdList/ArticleId[@IdType='doi']")
  
  return(get_xml_text_or_default(doi_element, "N/A"))
}

# Get article ID
get_pmid <- function(pubmed_article_element) {
  
  pmid_element <- xml_find_first(pubmed_article_element, ".//MedlineCitation/PMID")
  return(get_xml_text_or_default(pmid_element, "N/A"))
}