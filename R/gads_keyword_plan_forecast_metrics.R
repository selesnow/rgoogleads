#' Returns the requested Keyword Plan forecasts.
#'
#' @param keyword_plan_id Keyword plan id, you can get list of your keyword plans using \code{\link{gads_get_report}} with recource keyword_plan
#' @inheritParams gads_get_report
#'
#' @return tibble with keyword plan historical metrics
#' @export
#' @seealso \href{https://developers.google.com/google-ads/api/docs/keyword-planning/overview?hl=en}{Keyword Planning API Documentation}
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
#' historical_plan_data <- gads_keyword_plan_forecast_metrics(
#'  keyword_plan_id = plan_data$keyword_plan_id[1]#'
#' )
#'
#' }
gads_keyword_plan_forecast_metrics <- function(
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
    path     = str_glue('{options("gads.api.version")}/customers/{customer_id}/keywordPlans/{keyword_plan_id}:generateForecastMetrics'),
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

  # camp data
  camp <- tibble(data = data$campaignForecasts) %>%
          unnest_wider('data') %>%
          unnest_wider('campaignForecast') %>%
          rename_with(to_snake_case)

  # adgroup data
  adgroup <- tibble(data = data$adGroupForecasts) %>%
             unnest_wider('data') %>%
             unnest_wider('adGroupForecast')%>%
             rename_with(to_snake_case)

  # camp data
  keyw <- tibble(data = data$keywordForecasts) %>%
          unnest_wider('data') %>%
          unnest_wider('keywordForecast')%>%
          rename_with(to_snake_case)

  # collect plan to one object
  res <- list(
    campaign_forecast = camp,
    ad_group_forecast = adgroup,
    keyword_forecast  = keyw
  )

  # fix cost
  if (verbose) cli_alert_info('Fix cost fields')
  for ( plan in names(res) ) {

    if ( any(str_detect(names(res[[plan]]), 'micros|cpc')) ) {

      res[[plan]] <- mutate(res[[plan]],
                            across(matches('micros|cpc'), function(x) round(as.numeric(x) / 1000000, 2 )) ) %>%
                     rename_with(gads_fix_names_regexp, matches('micros'), regexp = "\\_micros")

    }

  }

  # success msg
  if (verbose) cli_alert_success('Success!')
  if (verbose) cli_alert_info('For get data use res$campaign_forecast, res$ad_group_forecast and res$keyword_forecast')

  # return
  return(res)

}
