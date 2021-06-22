rgoogleads <- new.env(parent = emptyenv())
rgoogleads$last_request_id <- NULL
invisible(rgoogleads)

gads_last_request_ids <- function() {
  return(rgoogleads$last_request_id)
}
