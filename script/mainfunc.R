# source the dependent functions from other files
setwd("/Users/viktoriiatantsiura/Downloads/University_Luzern/Data_Mining/Capstone-project-DM/script")
source("pubmed_funcs.R")

source("get_authors.R")
source("get_dates.R")
source("get_titles.R")


df <- data_frame("PMID" = art_ids, "Title" = article_title, "Abstract" = abstracts, 
                 "Journal" = journal_title, "Country" = country, "Outlink" = linkout,
                 "Article received" = pub_received, "Article accepted"= pub_accepted, "DOI"= doi)
