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
article_title <- title(articles)


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
journal_title <- journal_t(articles)

#Retrieve abstracts

abstracts <- xml_find_all(articles, "//Article/Abstract") %>%
  xml_text()

abstract_function <- function(art){
  
  values <- c()
  
  articles <- xml_find_all(art, "//Article")
  
  for (i in 1:length(articles)) {
    article <- articles[[i]]
    abstract_element <- xml_find_first(article, "Abstract")
    
    if (is.null(abstract_element)){
      values <- c(values, "No abstract")
      next
    }
    
    values <- c(values, xml_text(abstract_element))
  }
  return(values)
}

abstract <- abstract_function(articles)

#Get country where the journal is published
country <- xml_find_all(articles, ".//MedlineJournalInfo/Country") %>% 
  xml_text()

