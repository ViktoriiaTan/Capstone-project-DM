# Define a function to build a date string
build_date <- function(date_node) {
  year <- xml_text(xml_find_first(date_node, ".//Year"))
  month <- xml_text(xml_find_first(date_node, ".//Month"))
  day <- xml_text(xml_find_first(date_node, ".//Day"))
  return (glue("{year}-{month}-{day}"))
}
# Get dates when manuscripts were received
date_r <- function(art) {

  articles <- xml_find_all(art, "//PubmedArticle")
  
  res_dates <- c()
  
  for (i in 1:length(articles)) {
    article <- articles[[i]]
    pm_id <- xml_text(xml_find_first(article, ".//PMID"))
    
    pub_dates <- xml_find_all(article, ".//PubMedPubDate[@PubStatus='received']") 
    
    if (length(pub_dates) == 0){
      res_dates <- c(res_dates, glue("N/A"))
      next
    }
    
    for (j in 1:length(pub_dates)) {
      pub_date <- pub_dates[[j]]
      res_dates <- c(res_dates, build_date(pub_date))
    }
  }
  return(res_dates)
}


# Get dates when manuscripts were accepted
date_acc <- function(art) {
  articles <- xml_find_all(art, "//PubmedArticle")
  
  accept_dates <- c()
  
  for (i in 1:length(articles)) {
    article <- articles[[i]]
    pm_id <- xml_text(xml_find_first(article, ".//PMID"))
    
    pub_dates <- xml_find_all(article, ".//PubMedPubDate[@PubStatus='accepted']") 
    
    if (length(pub_dates) == 0){
      accept_dates <- c(accept_dates, glue("N/A"))
      next
    }
    
    for (j in 1:length(pub_dates)) {
      pub_date <- pub_dates[[j]]
      accept_dates <- c(accept_dates, build_date(pub_date))
    }
  }
  return(accept_dates)
}

