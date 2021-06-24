rgoogleads <- new.env(parent = emptyenv())
rgoogleads$last_request_id <- NULL
invisible(rgoogleads)

#' Get last API request ID for Google Ads API support ticket
#'
#' @return Request ID
#' @export
#'
#' @examples
#' \dontrun{
#' gads_last_request_ids()
#' }
gads_last_request_ids <- function() {
  return(rgoogleads$last_request_id)
}
