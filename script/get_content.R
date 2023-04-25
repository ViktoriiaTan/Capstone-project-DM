
pubmed_content <- function(db , ids = NULL, 
                           retmode = "abstract", rettype = "xml") {
  ids_str <- paste(ids, collapse = ",")
  url <- glue("https://www.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db={db}&id={ids_str}&retmode={retmode}&rettype={rettype}&api_key={api_key}")
  response <- httr::GET(url)
  
  summary <- read_xml(content(response, "text"))
  #Get authors
  authors <- xml_find_all(summary, "//Author") %>%
    lapply(function(x) {
      last_name <- xml_find_all(x, ".//LastName") %>% xml_text(trim = TRUE)
      initials <- xml_find_all(x, ".//Initials") %>% xml_text(trim = TRUE)
      paste(last_name, initials, sep = " ")
    }) %>%
    paste(collapse = ", ")

  
  return(authors)
}
pubmed_content(db, 20113659)

