# Define a function to build a date string
build_date <- function(date_node) {
  year <- xml_text(xml_find_first(date_node, ".//Year"))
  month <- xml_text(xml_find_first(date_node, ".//Month"))
  day <- xml_text(xml_find_first(date_node, ".//Day"))
  return (glue("{year}-{month}-{day}"))
}

# Get dates when manuscripts were received
date_r <- function(pubmed_article_element) {

  date_element <- xml_find_first(pubmed_article_element, ".//PubMedPubDate[@PubStatus='received']") 
  
  if (is.na(date_element)) {
    return("N/A")
  }
  return(build_date(date_element))
}

# Get dates when manuscripts were accepted
date_acc <- function(pubmed_article_element) {
  date_element <- xml_find_first(pubmed_article_element, ".//PubMedPubDate[@PubStatus='accepted']")
  
  if (is.na(date_element)) {
    return("N/A")
  }
  
  return(build_date(date_element))
}