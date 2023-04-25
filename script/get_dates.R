#Getting history dates

#date when the manuscript was received
date_r <- function(sum){
  pub_date <- xml_find_all(sum, ".//PubMedPubDate") 
  if (length(pub_date) > 0){
    accepted <- xml_find_all(summary, ".//PubMedPubDate[@PubStatus='received']") %>% 
      xml_children() %>% 
      xml_text() %>% 
      paste(collapse = "-") %>% 
      as.Date(format = "%Y-%m-%d")
    
    return(accepted)
  }
  else {
    return("not found")
  }
}
pub_received<- date_r(summary)


# date when the article was accepted for publication
date_a <- function(sum){
  pub_date <- xml_find_all(sum, ".//PubMedPubDate") 
  if (length(pub_date) > 0){
    accepted <- xml_find_all(summary, ".//PubMedPubDate[@PubStatus='accepted']") %>% 
      xml_children() %>% 
      xml_text() %>% 
      paste(collapse = "-") %>% 
      as.Date(format = "%Y-%m-%d")
    
    return(accepted)
  }
  else {
    return("not found")
  }
}
pub_accepted <- date_a(summary)
