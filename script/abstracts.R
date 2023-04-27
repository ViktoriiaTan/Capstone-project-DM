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
