#Get an article title

title <- function(art){
  all_art <- xml_find_all(art, "//PubmedArticle")
  num_docs <- length(all_art)
  
  titles <- lapply(all_art, function(pubmed_article){
    article_node <- xml_find_first(pubmed_article, ".//Article")
    
    if (is.null(article_node)) {
      return("NA")
    } else {
      title <- xml_find_first(article_node, ".//ArticleTitle")
      
      if (is.null(title)) {
        return("NA")
      } else {
        return(xml_text(title, trim = TRUE))
      }
    }
  })
  
  return(titles)
}



#Get journal title in which an article was published

journal_t <- function(art){
  all_art <- xml_find_all(art, "//PubmedArticle")
  num_docs <- length(all_art)
  
  j_titles <- lapply(all_art, function(pubmed_article){
    journal_node <- xml_find_first(pubmed_article, ".//Journal")
    
    if (is.null(journal_node)) {
      return("NA")
    } else {
      title <- xml_find_first(journal_node, ".//Title")
      
      if (is.null(title)) {
        return("NA")
      } else {
        return(xml_text(title, trim = TRUE))
      }
    }
  })
  
  return(j_titles)
}

