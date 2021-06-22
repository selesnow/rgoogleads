gads_get_accessible_customers <- function() {

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

  # check for error
  gads_check_errors(rawres)

  # processing result
  unlist(rawres$resourceNames) %>%
    str_replace_all('customers/', '') -> account_ids

  # get detail
  customers_data <- lapply(account_ids, gads_customers)

  # list to table
  res <- map_df(customers_data, ~ list.filter(.x, class(.) != "list")) %>%
         select(-resourceName)

  # success msg
  cli_alert_success('Success! Loaded {nrow(res)} rows!')

  # return data
  return(res)
}
