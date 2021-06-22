gads_get_account_hierarchy <- function(
  manager_customer_id,
  include_drafts    = FALSE,
  login_customer_id = getOption('gads.login.customer.id')
) {

  # remove - from manager_customer id
  manager_customer_id <- str_replace_all(manager_customer_id, '-', '')

  # drafts
  drafts <- ifelse(include_drafts, 'PARAMETERS include_drafts=true', '')

  # build GAQL Query
  body <- list(query =
  str_glue('
       SELECT
          customer_client.applied_labels,
          customer_client.client_customer,
          customer_client.currency_code,
          customer_client.descriptive_name,
          customer_client.hidden,
          customer_client.id,
          customer_client.level,
          customer_client.manager,
          customer_client.test_account,
          customer_client.time_zone,
          customer.currency_code,
          customer.descriptive_name,
          customer.final_url_suffix,
          customer.has_partners_badge,
          customer.id,
          customer.manager,
          customer.optimization_score,
          customer.optimization_score_weight,
          customer.pay_per_conversion_eligibility_failure_reasons,
          customer.test_account,
          customer.time_zone,
          customer.tracking_url_template

       FROM customer_client

       {drafts}')) %>%
    toJSON(auto_unbox = T, pretty = T)

  # send query
  ans <- POST(
    url = str_glue('https://googleads.googleapis.com/v8/customers/{manager_customer_id}/googleAds:searchStream'),
    encode = 'json',
    body = body,
    add_headers(
      Authorization    = str_glue("Bearer {gads_token()$auth_token$credentials$access_token}"),
      `developer-token`= gads_developer_token(),
      `login-customer-id` = login_customer_id
    )
  )

  # read answer
  out <- content(ans)

  # check for error
  gads_check_errors(out)

  # parse answer
  tibble(data = out) %>%
    unnest_wider(data) %>%
    select(results) %>%
    unnest_longer(results) %>%
    unnest_wider(results) %>%
    unnest_wider(customer) %>%
    unnest_wider(customerClient, names_sep = "_") %>%
    rename_with(to_snake_case) -> res

  # success msg
  cli_alert_success('Success! Loaded {nrow(res)} rows!')

  # return result
  return(res)

}
