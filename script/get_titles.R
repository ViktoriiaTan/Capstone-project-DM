#Get an article title
article_title <- xml_find_all(summary, "//ArticleTitle") %>% 
  xml_text(trim = TRUE)

#Get journal title in which an article was published
journal_title <- xml_find_all(summary, ".//Journal/Title") %>% 
  xml_text()

#Retrieve abstracts

abstracts <- xml_find_all(summary, "//Article/Abstract") %>%
  xml_text()

abstract_function <- function(summary){
  
  values <- c()
  
  articles <- xml_find_all(summary, "//Article")
  
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

abstract <- abstract_function(summary)

#Get country where the journal is published
country <- xml_find_all(summary, ".//MedlineJournalInfo/Country") %>% 
  xml_text()

