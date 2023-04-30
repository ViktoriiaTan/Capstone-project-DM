#' Set NCBI API Key
#'
#' This function sets the NCBI API key for use in the current R session. The key can be provided
#' interactively or retrieved from an environment variable. The validity of the API key is checked
#' against the NCBI API by making a test request.
#'
#' @param check_env Logical. If TRUE, the function will attempt to find the API key in the
#' "ncbi_apikey" environment variable. If FALSE, the function will prompt the user to enter the API
#' key interactively. Default is FALSE.
#'
#' @return This function does not return any value. It sets the "ncbi.api.key" session option if the
#' API key is valid.
#'
#' @examples
#' \dontrun{
#' # Set API key from environment variable
#' set_ncbi_apikey(check_env = TRUE)
#'
#' # Set API key interactively
#' set_ncbi_apikey(check_env = FALSE)
#' }
#'
#' @export
set_ncbi_apikey <- function(check_env = FALSE) {
  if (check_env) {
    key <- Sys.getenv("ncbi_apikey")
    if (identical(key, "")) {
      print("Couldn't find environment variable 'ncbi_apikey'")
    }
  }
  else {
    if (interactive()) {
      key <- readline("Please enter your NCBI API key and press enter: ")
    } else {
      cat("Please enter your NCBI API key and press enter: ")
      key <- readLines(con = "stdin", n = 1)
    }
    
    if (identical(key, "")) {
      print("NCBI API key entry failed")
    }
  }
  
  # Check if user is registered
  response <- httr::GET(paste0("https://www.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=1&rettype=abstract&api_key=", key))
  
  if (response$status_code == 200) {
    message("User is registered with NCBI API key")
    options("ncbi.api.key" = key)
    message("Updated ncbi.api.key session variable")
  } else {
    print("NCBI API key is not valid for registered user")
  }
  
}
