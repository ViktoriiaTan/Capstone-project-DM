#Get title
article_title <- xml_find_all(summary, "//ArticleTitle") %>% 
  xml_text(trim = TRUE)


#Get journal title 
journal_title <- xml_find_first(summary, ".//Journal/Title") %>% 
  xml_text()