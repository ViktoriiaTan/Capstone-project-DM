#Get an article title
article_title <- xml_find_all(summary, "//ArticleTitle") %>% 
  xml_text(trim = TRUE)

#Get journal title in which an article was published
journal_title <- xml_find_all(summary, ".//Journal/Title") %>% 
  xml_text()

#Retrieve abstracts

abstracts <- xml_find_all(summary, "//Article/Abstract") %>%
  xml_text()

#Get country where the journal is published
country <- xml_find_all(summary, ".//Country") %>% 
  xml_text()

