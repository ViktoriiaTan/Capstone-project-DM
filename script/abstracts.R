#Retrieve abstracts
abstract_objective <- foreach(node = xml_find_all(summary, "//AbstractText")) %do% {
  label <- xml_attr(node, "Label")
  text <- xml_text(node, trim = TRUE)
  paste0(label, ": ", text)
} %>% 
  paste(collapse = "\n")
