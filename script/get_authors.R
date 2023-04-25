#Get authors
authors <- xml_find_all(summary, "//Author") %>%
  lapply(function(x) {
    last_name <- xml_find_all(x, ".//LastName") %>% xml_text(trim = TRUE)
    initials <- xml_find_all(x, ".//Initials") %>% xml_text(trim = TRUE)
    paste(last_name, initials, sep = " ")
  }) %>%
  paste(collapse = ", ")