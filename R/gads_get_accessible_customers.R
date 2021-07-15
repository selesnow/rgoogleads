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
  out <- request_build(
    method   = "GET",
    path     = str_glue('{options("gads.api.version")}/customers:listAccessibleCustomers'),
    token    = gads_token(),
    base_url = getOption('gads.base.url')
  )

  # send request
  ans <- request_retry(
    out,
    add_headers(`developer-token`= gads_developer_token())
  )

  # get result
  rawres <- response_process(ans, error_message = gads_check_errors2)

  rq_ids <- unique(ans$headers$`request-id`)
  rgoogleads$last_request_id <- rq_ids

  # check for error
  gads_check_errors(out = rawres, request_id = rq_ids)

  # processing result
  unlist(rawres$resourceNames) %>%
    str_replace_all('customers/', '') -> account_ids

  # info
  cli_alert_info(c("Your accessible accounts ids: ", str_replace_all(account_ids, '(\\d{3})(\\d{3})(\\d{4})', '\\1-\\2-\\3') %>% str_c(collapse = ', ')))

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
         rename_with(getOption('gads.column.name.case.fun'))

  # success msg
  cli_alert_success('Success! Loaded {nrow(res)} rows!')

  # return data
  return(res)
}
