gads_get_report_helper <- function(
  resource = 'campaign',
  fields = c('campaign.id',
             'campaign.name',
             'customer.id',
             'customer.descriptive_name',
             'campaign.status',
             'segments.date',
             'metrics.all_conversions',
             'metrics.clicks',
             'metrics.cost_micros',
             'metrics.ctr',
             'metrics.impressions',
             'metrics.interaction_rate',
             'metrics.interactions',
             'metrics.invalid_clicks'),
  where = NULL,
  order_by = NULL,
  limit = NULL,
  parameters = NULL,
  date_from = Sys.Date() - 15,
  date_to = Sys.Date() - 1,
  customer_id       = getOption('gads.customer.id'),
  login_customer_id = getOption('gads.login.customer.id'),
  include_resource_name = FALSE,
  verbose = TRUE
) {

  if (verbose) message('---------------------------')
  # delete _
  customer_id <- str_replace_all(customer_id, '-', '')

  # manager_customer id
  login_customer_id <- ifelse(is.null(login_customer_id), customer_id, login_customer_id)

  # info
  if (verbose) cli_alert_info(c('Loading data: ', str_replace(customer_id, '(\\d{3})(\\d{3})(\\d{4})', '\\1-\\2-\\3')))

  # compose query
  if (verbose) cli_alert_info('Compose query')

  # fields
  fields <- str_c(fields, collapse = ', ')

  # where
  sd <- format(as.Date(date_from), '%Y-%m-%d')
  fd <- format(as.Date(date_to), '%Y-%m-%d')
  where_clause <- ifelse( is.null(where), str_glue("WHERE segments.date BETWEEN '{sd}' AND '{fd}'"), str_glue("WHERE segments.date BETWEEN '{sd}' AND '{fd}' AND {where}") )

  # params
  params_clause <- ifelse( is.null(parameters), '', str_glue('PARAMETERS {parameters}') )

  # order
  order_by_clause <- ifelse( is.null(order_by), '', str_glue('ORDER BY {str_c(order_by, collapse=", ")}'))

  # limit
  limit_clause <- ifelse( is.null(limit), '', str_glue('LIMIT {limit}') )

  # build GAQL Query
  body <- list(query =
                 str_glue('
       SELECT {fields}

       FROM {resource}

       {where_clause}

       {order_by_clause}
       {limit_clause}
       {params_clause}')) %>%
    toJSON(auto_unbox = T, pretty = T)

  # send query
  if (verbose) cli_alert_info('Send request')

  ans <- POST(
    url = str_glue('https://googleads.googleapis.com/v8/customers/{customer_id}/googleAds:searchStream'),
    encode = 'json',
    body = body,
    add_headers(
      Authorization    = str_glue("Bearer {gads_token()$auth_token$credentials$access_token}"),
      `developer-token`= gads_developer_token(),
      `login-customer-id` = login_customer_id
      )
  )

  # get answer
  if (verbose) cli_alert_info('Get answer query')
  out <- content(ans)

  # requests_ids
  if ( !is.null(ans$headers$`request-id`) ) {

    rq_ids <- ans$headers$`request-id`
    rgoogleads$last_request_id <- rq_ids
    if (verbose) cli_alert_info(c("Your request ids: ", ans$headers$`request-id`))

  } else {

    rgoogleads$last_request_id <- sapply(out, function(x) x$requestId)
    rq_ids <- str_c(rgoogleads$last_request_id, collapse = ', ')
    if (verbose) cli_alert_info(c("Your request ids: ", rq_ids))

  }

  # check for errors
  gads_check_errors(out, customer_id, verbose, rq_ids)

  # empty error
  if ( length(out) == 0 ) return(tibble())

  # result df
  res <- list()

  # get result
  if (verbose) cli_alert_info('Parsing result')
  for ( result in out ) {

    # get parts of answer
    parts_name <- names(result$results[[1]])

    # start unnesting
    temp <- tibble(data = result$results) %>%
            unnest_wider(data)

      # unnest all parts
      for ( part in parts_name ) {

        temp <- unnest_wider(temp, col = part, names_sep = '_')

      }

    # add to result list
    res <- append(res, list(temp))
  }

  # binding
  res <- bind_rows(res)

  # unnest list columns
  list_col <- sapply(res, class)[sapply(res, class, USE.NAMES = F) == "list"]

  # unnesting
  for ( col in names(list_col) ) {

    res <- unnest_wider(res, col)

  }

  # renaming
  if (verbose) cli_alert_info('Rename columns to snake_case')
  res <- rename_with(res, gads_fix_names, matches('metrics|segments') ) %>%
         rename_with(to_snake_case)

  # fix date
  if ( 'date' %in% names(res) ) {
    if (verbose) cli_alert_info('Fix date fields')
    res$date <- as.Date(res$date)
  }

  # fix cost
  if ( 'cost_micros' %in% names(res) ) {
    if (verbose) cli_alert_info('Fix cost fields')
    res$cost_micros <-  round(as.numeric(res$cost_micros) / 1000000, 2)
    res <- rename(res, cost = cost_micros)
  }

  # resource names
  if ( isFALSE(include_resource_name) ) {

    res <- select(res, -matches('resource_name'))

  }

  # success msg
  if (verbose) cli_alert_success('Success! Loaded {nrow(res)} rows!')

  # return
  return(res)

}

