gads_get_report_helper <- function(
  gaql_query,
  customer_id           = getOption('gads.customer.id'),
  login_customer_id     = getOption('gads.login.customer.id'),
  include_resource_name = FALSE,
  verbose               = TRUE
) {

  if (verbose) message('---------------------------')
  # delete _
  customer_id <- str_replace_all(customer_id, '-', '')
  login_customer_id <- str_replace_all(login_customer_id, '-', '')

  # manager_customer id
  login_customer_id <- ifelse(length(login_customer_id) == 0, customer_id, login_customer_id)

  # check login and custimer ids
  if ( is.null(customer_id) ) {
    gads_abort('customer_id is require argument, please set it and retry your request.')
  }

  # info
  if (verbose) cli_alert_info(c('Loading data: ', str_replace(customer_id, '(\\d{3})(\\d{3})(\\d{4})', '\\1-\\2-\\3')))

  # info
  if (verbose) cli_alert_info('Compose query')

  # --------------
  # build GAQL Query
  body <- list(query = gaql_query) %>%
          toJSON(auto_unbox = T, pretty = T)

  # --------------
  # info
  if (verbose) cli_alert_info('Send request')

  # send query
  out <- request_build(
    method   = "POST",
    body     = body,
    path     = str_glue('{options("gads.api.version")}/customers/{customer_id}/googleAds:searchStream'),
    token    = gads_token(),
    base_url = getOption('gads.base.url')
  )

  # send request
  ans <- request_retry(
    out,
    encode = 'json',
    add_headers(`developer-token`= gads_developer_token(),
                `login-customer-id` = login_customer_id)
  )

  # --------------
  # get answer
  if (verbose) cli_alert_info('Get answer query')
  out <- response_process(ans, error_message = gads_check_errors2)

  # requests_ids
  if ( !is.null(ans$headers$`request-id`) ) {

    rq_ids <- unique(ans$headers$`request-id`)
    rgoogleads$last_request_id <- rq_ids
    if (verbose) cli_alert_info(c("Your request ids: ", rq_ids))

  } else {

    rgoogleads$last_request_id <- unique(sapply(out, function(x) x$requestId))
    rq_ids <- str_c(rgoogleads$last_request_id, collapse = ', ')
    if (verbose) cli_alert_info(c("Your request ids: ", rq_ids))

  }

  # check for errors
  #gads_check_errors(out, customer_id, verbose, rq_ids)

  # empty answer handler
  if ( length(out) == 0 ) return(tibble() )

  # --------------
  # parsing answer
  # result df object
  res <- list()

  # get result
  if (verbose) cli_alert_info('Parsing result')
  for ( result in out ) {

    # get parts of answer
    parts_name <- names(result$results[[1]])

    # start unnesting - top level
    temp <- tibble(data = result$results) %>%
            unnest_wider('data')

      # unnest all parts
      for ( part in parts_name ) {

        temp <- unnest_wider(temp, col = part, names_sep = '_')

      }

    # add to result list
    res <- append(res, list(temp))
  }

  # binding
  res <- bind_rows(res)

  # detect other list columns
  list_col <- sapply(res, class)[sapply(res, class, USE.NAMES = F) == "list"]

  # unnesting each list column
  for ( col in names(list_col) ) {

    res <- unnest_wider(res, col, names_sep = "_")

  }

  # convert metrics to numeric
  if (verbose) cli_alert_info('Convert metrics to numeric type')
  res <- mutate(res,
                across(matches('metrics'), as.numeric)
  )

  # renaming to snale case
  if (verbose) cli_alert_info('Rename columns to gads.column.name case')
  res <- rename_with(res, getOption('gads.column.name.case.fun')) %>%
         rename_with(gads_fix_names, matches('metrics|segments', ignore.case = TRUE) )


  # fix date
  if ( any(str_detect(str_to_lower(names(res)), 'date')) ) {
    if (verbose) cli_alert_info('Fix date fields')
    try( {
      res <- mutate(res,
                    across(matches('date', ignore.case = TRUE) & !matches('interval', ignore.case = TRUE), as.Date))
    },
    silent = TRUE)
  }

  # fix cost
  if ( any(str_detect(str_to_lower(names(res)), 'micros')) ) {
    if (verbose) cli_alert_info('Fix cost fields')

    res <- mutate(res,
                  across(matches('micros', ignore.case = TRUE), function(x) round(as.numeric(x) / 1000000, 2 )) ) %>%
           rename_with(gads_fix_names_regexp, matches('micros', ignore.case = TRUE), regexp = "\\_micros|micros")

  }

  # remove resource names
  if ( isFALSE(include_resource_name) ) {

    res <- select(res, -matches('resource\\_?name'))

  }

  # success msg
  if (verbose) cli_alert_success('Success! Loaded {nrow(res)} rows!')

  # return
  return(res)

}
