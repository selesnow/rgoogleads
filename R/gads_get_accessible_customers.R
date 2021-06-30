#' Get all data of customers directly accessible by the user authenticating the call.
#'
#' @return List of your accessible accounts from top level
#' @export
#'
#' @seealso \href{https://developers.google.com/google-ads/api/rest/reference/rest/v8/customers/listAccessibleCustomers}{Method: customers.listAccessibleCustomers documentation}
#'
#' @examples
#' \dontrun{
#' accounts <- gads_get_accessible_customers()
#' }
gads_get_accessible_customers <- function()
  {

  # check token
  gargle::token_tokeninfo(gads_token())

  # send query
  ans <- GET(
    url = str_glue('https://googleads.googleapis.com/{options("gads.api.version")}/customers:listAccessibleCustomers'),
    add_headers(
      Authorization    = str_glue("Bearer {gads_token()$auth_token$credentials$access_token}"),
      `developer-token`= gads_developer_token()
    )
  )

  # get result
  rawres <- content(ans)

  rq_ids <- unique(ans$headers$`request-id`)
  rgoogleads$last_request_id <- rq_ids

  # check for error
  gads_check_errors(out = rawres, request_id = rq_ids)

  # processing result
  unlist(rawres$resourceNames) %>%
    str_replace_all('customers/', '') -> account_ids

  # get detail
  customers_data <- pblapply(account_ids, safely(gads_customer), verbose = FALSE)

  # get res and errors
  res <- transpose(customers_data)

  # check errors
  if ( length(res$error) > 0 ) {

    for ( err in res$error ) {

      if ( is.null(err) ) next

      cli_alert_danger(err$message)

    }

  }

  # bind
  res <- tibble(data = list.filter(res$result, length(.) > 1)) %>%
         unnest_wider('data') %>%
         select(!where(is.list)) %>%
         select(-"resourceName") %>%
         rename_with(to_snake_case)

  # success msg
  cli_alert_success('Success! Loaded {nrow(res)} rows!')

  # return data
  return(res)
}
