
get_xml_text_or_default <- function(xml_element, default) {
  
  if (is.na(xml_element)) {
    return(default)
  } else {
    return(xml_text(xml_element, trim = TRUE))
  }
}

#Get an article title
get_pubmed_article_title <- function(pubmed_article_element){
  title_element <- xml_find_first(pubmed_article_element, ".//Article/ArticleTitle")
  return(get_xml_text_or_default(title_element, "N/A"))
}

#Get journal title in which an article was published
get_pubmed_article_journal <- function(pubmed_article_element){
  title_element <- xml_find_first(pubmed_article_element, "//PubmedArticle")
  return(get_xml_text_or_default(title_element, "N/A"))
}

