#' Get Ad Groups Dictionary From Google Ads Client Account
#'
#' @inheritParams gads_get_report
#'
#' @param fields character vector, list of report fields, all report has own fields list, for example \href{https://developers.google.com/google-ads/api/fields/v8/ad_group}{see field list of ad group report}.
#'
#' @seealso \href{https://developers.google.com/google-ads/api/fields/v8/ad_group_query_builder}{Google Ads Query Builder}
#'
#' @return tibble with ad group dicrionary
#' @export
gads_get_ad_groups <- function(
  customer_id           = getOption('gads.customer.id'),
  fields                = c('ad_group.id',
                            'ad_group.name',
                            'ad_group.status',
                            'ad_group.ad_rotation_mode',
                            'ad_group.base_ad_group',
                            'ad_group.campaign',
                            'campaign.id',
                            'ad_group.display_custom_bid_dimension',
                            'ad_group.effective_target_cpa_source',
                            'ad_group.effective_target_roas',
                            'ad_group.effective_target_roas_source',
                            'ad_group.final_url_suffix',
                            'ad_group.target_roas',
                            'ad_group.type',
                            'ad_group.url_custom_parameters',
                            'ad_group.tracking_url_template',
                            'customer.id',
                            'customer.descriptive_name'),
  where                 = NULL,
  order_by              = NULL,
  limit                 = NULL,
  parameters            = NULL,
  login_customer_id     = getOption('gads.login.customer.id'),
  include_resource_name = FALSE,
  verbose               = TRUE
) {

  # user gads_get_report
  res <- gads_get_report(
    resource          = 'ad_group',
    fields            = fields,
    where             = where,
    order_by          = order_by,
    limit             = limit,
    parameters        = parameters,
    customer_id       = customer_id,
    login_customer_id = login_customer_id,
    verbose           = verbose,
    date_from         = NULL,
    date_to           = NULL
  )

  # renaming to snale case
  res <- rename_with(res, function(x) str_remove(x, 'ad_group\\_'), matches('ad_group') ) %>%
    rename_with(to_snake_case)

  # fix date
  if ( any(str_detect(names(res), 'date')) ) {
    res <- mutate(res,
                  across(matches('date'), as.Date))
  }

}
