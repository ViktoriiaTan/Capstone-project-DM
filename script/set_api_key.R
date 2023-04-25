library(glue)

set_ncbi_apikey <- function(check_env = FALSE) {
  if (check_env) {
    key <- Sys.getenv("ncbi_apikey")
    if (key != "") {
      message("Updating ncbi.api.key session variable...")
      options("ncbi.api.key" = key)
      return(invisible())
    } else {
      warning("Couldn't find environment variable 'ncbi_apikey'")
    }
  }
  
  if (interactive()) {
    key <- readline("Please enter your NCBI API key and press enter: ")
  } else {
    cat("Please enter your NCBI API key and press enter: ")
    key <- readLines(con = "stdin", n = 1)
  }
  
  if (identical(key, "")) {
    stop("NCBI API key entry failed", call. = FALSE)
  }
}
set_ncbi_apikey()