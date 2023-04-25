base_address<-  "https://www.ncbi.nlm.nih.gov/entrez/eutils/"

pubmed_content <- function(ids){
  sum_endp <- glue("esummary.fcgi?db={db}&id={ids}&api_key={api_key}")
  url <- glue("{base_address}{sum_endp}")
  
  response <- httr::GET(url)
  summary <- read_xml(content(response, "text"))
  
  #Get authors
  author_elements <- xml_find_all(summary, "//Item[@Name='AuthorList']//Item[@Name='Author']") %>%
    xml_text()%>%
    paste(collapse = ", ")
  
  
  
  return(author_elements)
}
pubmed_content(20113659)

