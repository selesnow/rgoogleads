#' Get Keyword Dictionary From Google Ads Client Account
#'
#' @inheritParams gads_get_report
#' @param fields character vector, list of report fields, all report has own fields list, for example \href{https://developers.google.com/google-ads/api/fields/v10/keyword_view_query_builder}{see field list of keyword report}.
#'
#' @return tibble with Keyword criterions dicrionary
#' @export
#'
#' @seealso \href{https://developers.google.com/google-ads/api/fields/v10/keyword_view_query_builder}{Google Ads Query Builder}
gads_get_keywords <- function(
    customer_id = getOption('gads.customer.id'),
    fields      = c('ad_group_criterion.criterion_id',
                    'ad_group_criterion.keyword.text',
                    'ad_group_criterion.keyword.match_type',
                    'ad_group_criterion.status',
                    'ad_group_criterion.approval_status',
                    'ad_group_criterion.system_serving_status',
                    'ad_group_criterion.quality_info.quality_score',
                    'ad_group_criterion.quality_info.creative_quality_score',
                    'ad_group_criterion.quality_info.post_click_quality_score',
                    'ad_group.id',
                    'ad_group.name',
                    'ad_group.status',
                    'campaign.id',
                    'campaign.name',
                    'customer.id',
                    'customer.descriptive_name',
                    'metrics.average_cpc',
                    'metrics.average_cost',
                    'metrics.ctr',
                    'metrics.bounce_rate'),
    where                 = NULL,
    order_by              = NULL,
    limit                 = NULL,
    parameters            = NULL,
    login_customer_id     = getOption('gads.login.customer.id'),
    include_resource_name = FALSE,
    cl                    = NULL,
    verbose               = TRUE
) {

  # user gads_get_report
  res <- gads_get_report(
    resource          = 'keyword_view',
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

  # renaming to snake case
  res <- rename_with(res, function(x) str_remove( str_to_lower(x), 'ad_?group_?criterion\\_?'), matches('ad\\_?group\\_?criterion\\_?', ignore.case = TRUE) ) %>%
         rename_with(getOption('gads.column.name.case.fun'))

  return(res)

}
