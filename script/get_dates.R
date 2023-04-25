#Getting Date Revised
revised_date <- xml_find_first(summary, ".//DateRevised")
year <- xml_find_first(revised_date, ".//Year") %>% xml_text()
month <- xml_find_first(revised_date, ".//Month") %>% xml_text()
day <- xml_find_first(revised_date, ".//Day") %>% xml_text()

revised_date <- as.Date(paste(year, month, day, sep="-"))




accepted_date <- function(){
  xml_find_all(summary, ".//PubMedPubDate") 
  if ( !== NA)
    accepted_date <- paste(xml_text(xml_find_first(accepted_dates, ".//Year")),
                           xml_text(xml_find_first(accepted_dates, ".//Month")),
                           xml_text(xml_find_first(accepted_dates, ".//Day")), 
                           sep = "-")
  accepted_date <- as.Date(accepted_date, format = "%Y-%m-%d")
}

