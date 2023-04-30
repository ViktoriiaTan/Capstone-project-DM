#Retrieve abstracts

get_pubmed_article_abstract <- function(pubmed_article_element){
  abstract_element <- xml_find_first(pubmed_article_element, ".//Article/Abstract")
  return(get_xml_text_or_default(abstract_element, "N/A"))
}

get_pubmed_article_conclusions <- function(pubmed_article_element) {
  
  element <- xml_find_first(pubmed_article_element, ".//Article/Abstract/AbstractText[@NlmCategory='CONCLUSIONS']")
  
  return(get_xml_text_or_default(element, "N/A"))
}

get_pubmed_article_results <- function(pubmed_article_element) {
  
  element <- xml_find_first(pubmed_article_element, ".//Article/Abstract/AbstractText[@NlmCategory='RESULTS']")
  
  return(get_xml_text_or_default(element, "N/A"))
}