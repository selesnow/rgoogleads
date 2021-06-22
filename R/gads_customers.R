gads_customer <- function(
  customer_id
) {
  # delete _
  customer_id <- str_replace_all(customer_id, '-', '')

  # manager_customer id
  #manager_customer_id <- ifelse(is.null(manager_customer_id), customer_id, manager_customer_id)

  ans <- GET(str_glue('https://googleads.googleapis.com/v8/customers/{customer_id}/'),
             add_headers(Authorization = str_glue("Bearer {gads_token()$auth_token$credentials$access_token}"),
                         `developer-token`= gads_developer_token())
  )

  data <- content(ans)

  gads_check_errors(data)

  return(data)
}
