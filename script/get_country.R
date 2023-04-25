#Get country where the journal is published
country <- xml_find_first(summary, ".//Country") %>% 
  xml_text()