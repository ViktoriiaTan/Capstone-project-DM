# Set the HTTP version to 1.1 (none, 1.0, 1.1, 2)
#httr::set_config(config(http_version = 2)) 

#' Retrieve Content from the PubMed Database
#'
#' This function retrieves content from the PubMed database based on a given search query and
#' the maximum number of rows to be returned.
#'
#' @param db A character string specifying the database to search in. Default is "pubmed".
#' @param query A character string specifying the search query for finding articles.
#' @param max_rows An integer specifying the maximum number of articles to return.
#'
#' @return A data frame containing content from the specified PubMed articles.
#'
#' @import tidyverse
#' 
#' @examples
#' \dontrun{
#' # Retrieve content from PubMed articles related to "cancer" (max 100 articles)
#' cancer_articles <- search_pubmed(db = "pubmed", query = "cancer", max_rows = 100)
#' }
#'
#' @export
search_pubmed <- function(db = "pubmed", query, max_rows) {
  
  api_key <- get_key_opt()
  
  if (is.null(api_key)) {
    print("NCBI API key is not set. Call set_ncbi_apikey first.")
    return()
  }
  
  page_size <- 50
  item_index <- 0
  
  df <- tibble()
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