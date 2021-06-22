# function for fix names in get_report
gads_fix_names <- function(x) {
  out <- str_remove(x, 'metrics\\_|segments\\_')
  return(out)
}
