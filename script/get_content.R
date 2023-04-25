
pubmed_content <- function(db , ids = NULL, 
                           retmode = "abstract", rettype = "xml") {
  ids_str <- paste(ids, collapse = ",")
  url <- glue("https://www.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db={db}&id={ids_str}&retmode={retmode}&rettype={rettype}&api_key={api_key}")
  response <- httr::GET(url)
  print(url)
  summary <- read_xml(content(response, "text"))
  
  #Get authors
  authors <- xml_find_all(summary, "//Author") %>%
    lapply(function(x) {
      last_name <- xml_find_all(x, ".//LastName") %>% xml_text(trim = TRUE)
      initials <- xml_find_all(x, ".//Initials") %>% xml_text(trim = TRUE)
      paste(last_name, initials, sep = " ")
    }) %>%
    paste(collapse = ", ")
  
  #Get title
  article_title <- xml_find_all(summary, "//ArticleTitle") %>% 
    xml_text(trim = TRUE)
  
  #Retrieve abstracts
  abstract_objective <- foreach(node = xml_find_all(summary, "//AbstractText")) %do% {
    label <- xml_attr(node, "Label")
    text <- xml_text(node, trim = TRUE)
    paste0(label, ": ", text)
  } %>% 
    paste(collapse = "\n")
  
  #Get journal title 
  journal_title <- xml_find_first(summary, ".//Journal/Title") %>% 
    xml_text()
  
  #Getting Date Revised
  revised_date <- xml_find_first(summary, ".//DateRevised")
  year <- xml_find_first(revised_date, ".//Year") %>% xml_text()
  month <- xml_find_first(revised_date, ".//Month") %>% xml_text()
  day <- xml_find_first(revised_date, ".//Day") %>% xml_text()
  
  revised_date <- as.Date(paste(year, month, day, sep="-"))

  
  
  return(revised_date)
}
pubmed_content(db, 37096423)

