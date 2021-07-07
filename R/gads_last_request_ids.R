rgoogleads <- new.env(parent = emptyenv())
rgoogleads$last_request_id <- NULL
rgoogleads$customer_id     <- NULL
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

#' Write customer id for error message
#' @param customer_id Your client customer id
#' @return only set customer id into env
gads_customer_id_to_env <- function(customer_id) {
  customer_id <- str_replace_all(customer_id, "-", "") %>%
                 str_replace('(\\d{3})(\\d{3})(\\d{4})', '\\1-\\2-\\3')

  rgoogleads$customer_id <- customer_id
}

#' Get customer id for error message
#'
#' @return only set customer id into env
#'
gads_customer_id_from_env <- function() {
  return(rgoogleads$customer_id)
}
