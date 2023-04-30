# Capstone-project-DM

# pubmedart package

The `pubmedart` package is designed to simplify the process of searching and retrieving articles from the PubMed database. By providing an intuitive interface and R wrapper function, the package allows users to quickly obtain relevant article information in a formatted data frame.

## Installation

You can install the `pubmedart` package using the following command:
1.Install the remotes package if it's not already installed:
install.packages("remotes")

2.Load the remotes package:
library(remotes)

3.Install the pubmedart package from the release URL:
remotes::install_url("https://github.com/ViktoriiaTan/Capstone-project-DM/releases/download/v0.0.0.9000/pubmedart_0.0.0.9000.tar.gz")

### Usage
 To use the pubmedart package, first load it in your R session:
 library(pubmedart)

 Run this function in order to set your NCBI API key
 set_ncbi_apikey()

 Search for articles related to a specific topic
 search_results <- search_pubmed(db = "pubmed", query = "cancer AND 2020", max_rows = 100)
 
 IMPORTANT:
 * db = "pubmed" should be always specified;
 
 * queries can be combined with OR or NOT in addition to AND
 and have such format "cancer AND 2020 OR 2021";
 
 * max_row are limited to 10000 by PUBMED system;
 
 * if you have 
 Error in curl::curl_fetch_memory(url, handle = handle) : 
  Error in the HTTP2 framing layer
  
  * ---> Set the HTTP version to 1.1
  library(http)
  httr::set_config(config(http_version = 2)) 
 
####Documentation
The functions in the pubmedart package are documented using Roxygen2.

#####License
This package is released under the Unlicense. For more information, please refer to the LICENSE file.
 
 