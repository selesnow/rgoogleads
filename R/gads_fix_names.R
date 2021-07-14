#' function for fix names in get_report
#'
#' @param x character, column names
#'
#' @return new columns names
#'
gads_fix_names <- function(x) {
  out <- str_remove(x, 'metrics\\_|segments\\_')
  return(out)
}


gads_fix_names_regexp <- function(x, regexp = 'metrics\\_|segments\\_') {
  out <- str_remove(x, regexp)
  return(out)
}
