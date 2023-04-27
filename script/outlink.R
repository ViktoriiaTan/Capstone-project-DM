
#Retrieving OutLink
pubmed_linkout <- function(db, ids) {
  values <- c()
  
  ids_str <- paste(ids, collapse = ",")
  link_pr <- glue("elink.fcgi?dbfrom={db}&id={ids_str}&cmd=prlinks&api_key={api_key}")
  link <- glue("{base_address}{link_pr}")
  
  response <- GET(link)
  xml <- read_xml(content(response, "text"))
  
  id_url_sets <- xml_find_all(xml, ".//IdUrlSet")
  
  for (id_url_set in id_url_sets) {
    url_element <- xml_find_first(id_url_set, ".//Url[not(../Provider/NameAbbr='PMC')]")
    
    if (is.null(url_element)) {
      url_element <- xml_find_first(id_url_set, ".//Url")
    }
    
    if (!is.null(url_element)) {
      values <- c(values, xml_text(url_element))
    } else {
      values <- c(values, NA)
    }
  }
  
  return(values)
}
