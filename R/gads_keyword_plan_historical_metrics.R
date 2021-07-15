#' Returns the requested Keyword Plan historical metrics.
#'
#' @param keyword_plan_id Keyword plan id, you can get list of your keyword plans using \code{\link{gads_get_report}} with recource keyword_plan
#' @inheritParams gads_get_report
#'
#' @return tibble with keyword plan historical metrics
#' @export
#'
#' @examples
#' \dontrun{
#' # set client id
#' gads_set_customer_id('xxx-xxx-xxxx')
#'
#' # set manager id
#' gads_set_login_customer_id('xxx-xxx-xxxx')
#'
#' # get list of plan
#' plan_data <- gads_get_report(
#'   resource = 'keyword_plan',
#'   fields = c('keyword_plan.id')
#' )
#'
#' # get keyword historical data
#' historical_plan_data <- gads_keyword_plan_historical_metrics(
#'  keyword_plan_id = plan_data$keyword_plan_id[1]#'
#' )
#'
#' # main plan data
#' data <- historical_plan_data$main_data
#' historical_data <- historical_plan_data$historical_data
#'
#' }
gads_keyword_plan_historical_metrics <- function(
  keyword_plan_id,
  customer_id       = getOption('gads.customer.id'),
  login_customer_id = getOption('gads.login.customer.id'),
  verbose           = TRUE
) {

  # delete - in customer id
  customer_id <- str_replace_all(customer_id, '-', '')

  # to env
  gads_customer_id_to_env(customer_id)

  # info
  if (verbose) cli_alert_info(c('Loading data: ', str_replace(customer_id, '(\\d{3})(\\d{3})(\\d{4})', '\\1-\\2-\\3')))

  # info
  if (verbose) cli_alert_info('Send query')

  # build query
  out <- request_build(
    method   = "POST",
    path     = str_glue('{options("gads.api.version")}/customers/{customer_id}/keywordPlans/{keyword_plan_id}:generateHistoricalMetrics'),
    token    = gads_token(),
    base_url = getOption('gads.base.url')
  )

  # send request
  ans <- request_retry(
    out,
    encode = "multipart",
    add_headers(`developer-token`= gads_developer_token(),
                `login-customer-id` = login_customer_id)
  )

  # request id
  rq_ids <- headers(ans)$`request-id`
  rgoogleads$last_request_id <- rq_ids

  # info
  if (verbose) cli_alert_info('Get response')

  # pars result
  data <- response_process(ans, error_message = gads_check_errors2)

  # info
  if (verbose) cli_alert_info('Parsing result')

  # main data
  res <- tibble(data = data$metrics) %>%
    unnest_wider('data') %>%
    unnest_wider('keywordMetrics') %>%
    select(-'monthlySearchVolumes') %>%
    relocate('searchQuery', .before = everything()) %>%
    rename_with(getOption('gads.column.name.case.fun'))

  # fix cost
  if ( any(  str_detect(str_to_lower(names(res) ), 'micros')) ) {

    if (verbose) cli_alert_info('Fix cost fields')

    res <- mutate(res,
                  across(matches('micros', ignore.case = TRUE), function(x) round(as.numeric(x) / 1000000, 2 )) ) %>%
      rename_with(gads_fix_names_regexp, matches('micros', ignore.case = TRUE), regexp = "\\_micros|micros")

  }

  # historical data
  historical <- tibble(data = data$metrics) %>%
    unnest_wider('data') %>%
    unnest_wider('keywordMetrics') %>%
    select('searchQuery', 'monthlySearchVolumes') %>%
    unnest_longer('monthlySearchVolumes') %>%
    unnest_wider('monthlySearchVolumes')%>%
    rename_with(getOption('gads.column.name.case.fun'))

  # success msg
  if (verbose) cli_alert_success('Success! Loaded {nrow(res)} rows!')
  if (verbose) cli_alert_info('For get data use res$main_data and res$historical_data')

  # to list
  res <- list(main_data = res, historical_data = historical)

  # return
  return(res)

}
