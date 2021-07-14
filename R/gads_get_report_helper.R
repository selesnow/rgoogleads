gads_get_report_helper <- function(
  resource              = 'campaign',
  fields                = c('campaign.id',
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
  where                 = NULL,
  order_by              = NULL,
  limit                 = NULL,
  parameters            = NULL,
  date_from             = Sys.Date() - 15,
  date_to               = Sys.Date() - 1,
  during                = c(NA, "TODAY", "YESTERDAY", "LAST_7_DAYS", "LAST_BUSINESS_WEEK", "THIS_MONTH", "LAST_MONTH", "LAST_14_DAYS", "LAST_30_DAYS", "THIS_WEEK_SUN_TODAY", "THIS_WEEK_MON_TODAY", "LAST_WEEK_SUN_SAT", "LAST_WEEK_MON_SUN"),
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

  # check args
  during <- match.arg(during)

  # info
  if (verbose) cli_alert_info(c('Loading data: ', str_replace(customer_id, '(\\d{3})(\\d{3})(\\d{4})', '\\1-\\2-\\3')))

  # info
  if (verbose) cli_alert_info('Compose query')

  # --------------
  # compose query
  # select block
  fields <- gsub("[\\s\\n\\t]", "",  fields, perl = TRUE) %>%
            tolower() %>%
            str_c(collapse = ', ')

  # where block
  if (resource %in% c('ad_group_criterion', 'keyword_plan', 'keyword_plan_ad_group', 'keyword_plan_ad_group_keyword', 'keyword_plan_campaign', 'keyword_plan_campaign_keyword')) {
    date_from <- NULL
    date_to   <- NULL
    during    <- NA
  }

  if ( any(is.null(date_from), is.null(date_to)) & is.null(where) ) {
    where_clause <- ""
  } else if ( !is.na(during) ) {
    where <- str_c(where, collapse = " AND ")
    where_clause <- str_glue("WHERE segments.date DURING '{during}' AND {where}")
  } else if ( any(is.null(date_from), is.null(date_to)) ) {
    where <- str_c(where, collapse = " AND ")
    where_clause <- str_glue("WHERE {where}")
  } else {
    sd <- format(as.Date(date_from), '%Y-%m-%d')
    fd <- format(as.Date(date_to), '%Y-%m-%d')
    where_clause <- ifelse( is.null(where), str_glue("WHERE segments.date BETWEEN '{sd}' AND '{fd}'"), str_glue("WHERE segments.date BETWEEN '{sd}' AND '{fd}' AND {where}") )
  }

  # params block
  params_clause <- ifelse( is.null(parameters), '', str_glue('PARAMETERS {parameters}') )

  # order by block
  order_by_clause <- ifelse( is.null(order_by), '', str_glue('ORDER BY {str_c(order_by, collapse=", ")}'))

  # limit block
  limit_clause <- ifelse( is.null(limit), '', str_glue('LIMIT {limit}') )

  # --------------
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

  # renaming to snale case
  if (verbose) cli_alert_info('Rename columns to snake_case')
  res <- rename_with(res, gads_fix_names, matches('metrics|segments') ) %>%
         rename_with(to_snake_case)

  # fix date
  if ( any(str_detect(names(res), 'date'))) {
    if (verbose) cli_alert_info('Fix date fields')
    res <- mutate(res,
                  across(matches('date') & !matches('interval'), as.Date))
  }

  # fix cost
  if ( 'cost_micros' %in% names(res) ) {
    if (verbose) cli_alert_info('Fix cost fields')
    res$cost_micros <-  round(as.numeric(res$cost_micros) / 1000000, 2)
    res <- rename(res, cost = 'cost_micros')
  }

  # remove resource names
  if ( isFALSE(include_resource_name) ) {

    res <- select(res, -matches('resource_name'))

  }

  # success msg
  if (verbose) cli_alert_success('Success! Loaded {nrow(res)} rows!')

  # return
  return(res)

}

