source("pubmed_funcs.R")
source("abstracts.R")
source("items.R")
source("get_dates.R")
source("get_titles.R")
source("outlink.R")


# Set the HTTP version to 1.1 (none, 1.0, 1.1, 2)
httr::set_config(config(http_version = 2)) 

# Retrieve content from the PubMed database
get_content <- function(db = "pubmed", query, max_rows) {
  
  page_size <- 50
  item_index <- 0
  
  df <- data.frame()
  repeat {
    
    # Retrieve PubMed article IDs
    article_ids <- find_pubmed_ids(db = db, query = query, retmax = page_size, retstart = item_index)
    retcount <- length(article_ids)
    
    # Retrieve PubMed article content
    pubmed_article_set <- fetch_pubmed_content(db = db, ids = article_ids, retmode = "xml", rettype = "abstract")
    
    # Retrieve PubMed links out
    outlinks_xml <- fetch_pubmed_outlinks(db = db, ids = article_ids)
    
    # Process PubMed articles content
    articles_df <- process_pubmed_articleset(pubmed_article_set)
    
    # Process PubMed links out
    outlinks_df <- process_pubmed_outlinks(outlinks_xml)
    
    merged_df <- merge(articles_df, outlinks_df, by = "PMID", sort = FALSE)
    
    df <- rbind(df, merged_df)
    total_rows <- nrow(df)
    
    if (total_rows >= max_rows) {
      print(glue("Processed articles: {max_rows}"))
      return(df[1:max_rows,])
    }
    else {
      print(glue("Processed articles: {total_rows}"))
    }
    
    if (retcount < page_size) {
      break
    }
    
    item_index <- item_index + retcount
  }
  
  return(df)
}

get_content<- get_content(db, query, 1400) 