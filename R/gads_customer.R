# fix no visible binding for global variable '.'
. <- NULL

#' Get all information about Google Ads Customer
#'
#' @param customer_id Google Ads customer id
#' @param verbose Processing log output into console
#'
#' @return Google Ads customer data
#'
#' @seealso \href{https://developers.google.com/google-ads/api/rest/reference/rest/v8/customers/get}{Method: customers.get documentation}
#'
#' @export
gads_customer <- function(
  customer_id = getOption('gads.customer.id'),
  verbose = TRUE
) {

  # delete - in customer id
  customer_id <- str_replace_all(customer_id, '-', '')

  # to env
  gads_customer_id_to_env(customer_id)

  # build query
  out <- request_build(
    method = "GET",
    path   = str_glue('v8/customers/{customer_id}/'),
    token = gads_token(),
    base_url = 'https://googleads.googleapis.com/'
  )

  # send request
  ans <- request_make(
    out,
    add_headers(`developer-token`= gads_developer_token())
    )

  # request id
  rq_ids <- headers(ans)$`request-id`
  rgoogleads$last_request_id <- rq_ids

  # pars result
  data <- response_process(ans, error_message = gads_check_errors2)

  # return the data
  return(data)
}
