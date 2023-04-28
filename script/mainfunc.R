# source the dependent functions from other files
#setwd("...")
source("pubmed_funcs.R")
source("abstracts.R")
source("items.R")
source("get_dates.R")
source("get_titles.R")
source("outlink.R")

get_content <- function(db = "pubmed", query, retmax = 20) {
  
  # Retrieve PubMed article IDs
  art_ids <- pubmed_ids(db = db, query = query, retmax = retmax)
  print (art_ids)
  # Retrieve PubMed article content
  articles <- pubmed_content(ids = art_ids, db = db, retmode = "xml", rettype = "abstract")
  article_title <- title(articles)
  journal_title <- journal_t(articles)
  
  abstract <- abstract_function(articles)
  
  pub_received <- date_r(articles)
  pub_accepted <- date_acc(articles)
  print(pub_received )
  print(pub_accepted )
  country <- get_country(articles)
  
  authors <- get_authors(articles)
  
  linkout <- pubmed_linkout(db, art_ids)
  
  doi <- doi_results(articles)
  
  # Create data frame with results
  df <- tibble("PMID" = art_ids, "Title" = article_title, "Abstract" = abstract, 
                   "Journal" = journal_title, "Country" = country, "Outlink" = linkout,
                   "Article received" = pub_received, "Article accepted"= pub_accepted, "DOI"= doi)
  
  return(df)
}
b<- get_content(db,query, 2500)
