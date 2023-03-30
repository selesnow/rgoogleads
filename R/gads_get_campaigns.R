#' Get Campaigns Dictionary From Google Ads Client Account
#'
#' @inheritParams gads_get_report
#'
#' @param fields character vector, list of report fields, all report has own fields list, for example \href{https://developers.google.com/google-ads/api/fields/v10/campaign}{see field list of campaigns report}.
#'
#' @seealso \href{https://developers.google.com/google-ads/api/fields/v10/campaign_query_builder}{Google Ads Query Builder}
#'
#' @return tibble with campaings dicrionary
#' @export
#' @examples
#' \dontrun{
#' # set client customer id
#' gads_set_login_customer_id('xxx-xxx-xxxx')
#'
#' # set manager id if you work under MCC
#' gads_set_customer_id('xxx-xxx-xxxx')
#'
#' # load campaing list
#' camps <- gads_get_campaigns(
#'     where = "campaign.status = 'ENABLED'"
#' )
#'
#' }
gads_get_campaigns <- function(
  fields                = c('campaign.id',
                            'campaign.name',
                            'campaign.accessible_bidding_strategy',
                            'campaign.ad_serving_optimization_status',
                            'campaign.advertising_channel_sub_type',
                            'campaign.advertising_channel_type',
                            'campaign.app_campaign_setting.app_id',
                            'campaign.app_campaign_setting.app_store',
                            'campaign.base_campaign',
                            'campaign.bidding_strategy',
                            'campaign.app_campaign_setting.bidding_strategy_goal_type',
                            'campaign.campaign_budget',
                            'campaign.bidding_strategy_type',
                            'campaign.dynamic_search_ads_setting.language_code',
                            'campaign.start_date',
                            'campaign.end_date',
                            'campaign.status',
                            'campaign.manual_cpm',
                            'campaign.manual_cpv',
                            'campaign.maximize_conversion_value.target_roas',
                            'campaign.maximize_conversions.target_cpa_micros',
                            'campaign.network_settings.target_content_network',
                            'campaign.network_settings.target_google_search',
                            'campaign.network_settings.target_partner_search_network',
                            'campaign.network_settings.target_search_network',
                            'campaign.optimization_goal_setting.optimization_goal_types',
                            'campaign.optimization_score',
                            'campaign.payment_mode',
                            'campaign.serving_status',
                            'campaign.shopping_setting.campaign_priority',
                            'campaign.shopping_setting.sales_country',
                            'campaign.target_roas.target_roas',
                            'campaign.tracking_url_template',
                            'customer.descriptive_name',
                            'customer.id'),
  where                 = NULL,
  order_by              = NULL,
  limit                 = NULL,
  parameters            = NULL,
  customer_id           = getOption('gads.customer.id'),
  login_customer_id     = getOption('gads.login.customer.id'),
  include_resource_name = FALSE,
  cl                    = NULL,
  verbose               = TRUE
) {

  # user gads_get_report
  res <- gads_get_report(
    resource          = 'campaign',
    fields            = fields,
    where             = where,
    order_by          = order_by,
    limit             = limit,
    parameters        = parameters,
    customer_id       = customer_id,
    login_customer_id = login_customer_id,
    verbose           = verbose,
    date_from         = NULL,
    date_to           = NULL,
    cl                = cl
  )

  # renaming to snale case
  res <- rename_with(res, function(x) str_remove( str_to_lower(x), 'campaign\\_?'), matches('campaign', ignore.case = TRUE) ) %>%
         rename_with(getOption('gads.column.name.case.fun'))

  # fix date
  if ( any(str_detect(str_to_lower(names(res)), 'date')) ) {
    res <- mutate(res,
                  across(matches('date', ignore.case = TRUE), as.Date))
  }

}
