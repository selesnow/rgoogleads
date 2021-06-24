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

  # check token
  gargle::token_tokeninfo(gads_token())

  # delete _
  customer_id <- str_replace_all(customer_id, '-', '')

  # send query
  ans <- GET(str_glue('https://googleads.googleapis.com/v8/customers/{customer_id}/'),
             add_headers(Authorization = str_glue("Bearer {gads_token()$auth_token$credentials$access_token}"),
                         `developer-token`= gads_developer_token())
  )

  # get result
  data <- content(ans)

  # request id
  rq_ids <- headers(ans)$`request-id`
  rgoogleads$last_request_id <- rq_ids

  # check for error
  # gads_check_errors(out = data, client_id = '', request_id = rq_ids, verbose = FALSE)
  if ( "error" %in% names(data) ) {
    msg <- ifelse(is.null(data$error$details[[1]]$errors[[1]]$message), data$error$message, paste(data$error$message, data$error$details[[1]]$errors[[1]]$message, sep = ": "))
    if(verbose) cli_alert_danger(c(customer_id, ": ", msg))
    if(verbose) cli_alert_danger(c("Request ID: ", rq_ids))
    if(verbose) cli_alert_danger("You can use gads_last_request_ids() for get last request id, if you want send ticket to google ads api support.")
    stop(paste(customer_id, ": ", msg, " Request ID: ", rq_ids))
  }

  # return the data
  return(data)
}
