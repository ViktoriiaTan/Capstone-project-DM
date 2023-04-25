
pubmed_content <- function(db , ids = NULL, 
                           retmode = "abstract", rettype = "xml") {
  ids_str <- paste(ids, collapse = ",")
  url <- glue("https://www.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db={db}&id={ids_str}&retmode={retmode}&rettype={rettype}&api_key={api_key}")
  response <- httr::GET(url)
  sum <- read_xml(content(response, "text"))
  
  return(sum)
}
summary <- pubmed_content(db, 37087741)

