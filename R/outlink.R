#Retrieving OutLink
fetch_pubmed_outlinks <- function(db, ids) {
  query <- gsub(" ", "+", query)
  ids_str <- paste(ids, collapse = ",")
  link <- glue("{PUBMED_BASE_ADDRESS}elink.fcgi?dbfrom={db}&id={ids_str}&cmd=prlinks&api_key={api_key}")
  
  xml_doc <- GET(link) %>%
    content("text") %>%
    read_xml()
  return(xml_doc)
}


process_pubmed_outlinks <- function(xml_doc) {
  
  create_row <- function(id, url) {
    return(tibble(
      "PMID" = id,
      "Outlink" = url
    ))
  }
  
  df <- data.frame()
  
  for (id_url_set in xml_find_all(xml_doc, ".//IdUrlSet")) {
    
    pmid <- xml_text(xml_find_first(id_url_set, "Id"))
    url_element <- xml_find_first(id_url_set, ".//Url[not(../Provider/NameAbbr='PMC')]")
    
    if (is.na(url_element)) {
      url_element <- xml_find_first(id_url_set, ".//Url")
    }
    url <- get_xml_text_or_default(url_element, "N/A")
    df <- rbind(df, create_row(pmid, url))
  }
  return(df)
}