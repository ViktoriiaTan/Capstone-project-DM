#Retrieve abstracts

abstract_function <- function(art){
  
  values <- c()
  
  articles <- xml_find_all(art, "//Article")
  
  for (i in 1:length(articles)) {
    article <- articles[[i]]
    abstract_element <- xml_find_first(article, "Abstract")
    
    if (is.na(abstract_element)){
      values <- c(values, "No abstract")
      next
    }
    
    values <- c(values, xml_text(abstract_element))
  }
  return(values)
}

