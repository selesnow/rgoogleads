#' Get Ad Group Criterions Dictionary From Google Ads Client Account
#'
#' @inheritParams gads_get_report
#'
#' @param fields character vector, list of report fields, all report has own fields list, for example \href{https://developers.google.com/google-ads/api/fields/v8/ad_group}{see field list of ad group report}.
#'
#' @seealso \href{https://developers.google.com/google-ads/api/fields/v8/ad_group_criterion_query_builder}{Google Ads Query Builder}
#'
#' @return tibble with ad group criterions dicrionary
#' @export
gads_get_ad_group_criterions <- function(
  customer_id           = getOption('gads.customer.id'),
  fields                = c('ad_group_criterion.ad_group',
                            'ad_group_criterion.age_range.type',
                            'ad_group_criterion.app_payment_model.type',
                            'ad_group_criterion.approval_status',
                            'ad_group_criterion.bid_modifier',
                            'ad_group_criterion.combined_audience.combined_audience',
                            'ad_group_criterion.cpc_bid_micros',
                            'ad_group_criterion.cpm_bid_micros',
                            'ad_group_criterion.cpv_bid_micros',
                            'ad_group.id',
                            'customer.id',
                            'customer.descriptive_name',
                            'ad_group_criterion.criterion_id',
                            'ad_group_criterion.custom_affinity.custom_affinity',
                            'ad_group_criterion.custom_audience.custom_audience',
                            'ad_group_criterion.custom_intent.custom_intent',
                            'ad_group_criterion.disapproval_reasons',
                            'ad_group_criterion.display_name',
                            'ad_group_criterion.effective_cpc_bid_micros',
                            'ad_group_criterion.effective_cpc_bid_source',
                            'ad_group_criterion.effective_cpm_bid_micros',
                            'ad_group_criterion.effective_cpm_bid_source',
                            'ad_group_criterion.effective_cpv_bid_micros',
                            'ad_group_criterion.effective_cpv_bid_source',
                            'ad_group_criterion.effective_percent_cpc_bid_micros',
                            'ad_group_criterion.effective_percent_cpc_bid_source',
                            'ad_group_criterion.final_mobile_urls',
                            'ad_group_criterion.final_url_suffix',
                            'ad_group_criterion.final_urls',
                            'ad_group_criterion.gender.type',
                            'ad_group_criterion.income_range.type',
                            'ad_group_criterion.keyword.match_type',
                            'ad_group_criterion.keyword.text',
                            'ad_group_criterion.labels',
                            'ad_group_criterion.listing_group.case_value.hotel_city.city_criterion',
                            'ad_group_criterion.listing_group.case_value.hotel_class.value',
                            'ad_group_criterion.listing_group.case_value.hotel_id.value',
                            'ad_group_criterion.listing_group.case_value.hotel_state.state_criterion',
                            'ad_group_criterion.listing_group.case_value.product_bidding_category.country_code',
                            'ad_group_criterion.listing_group.case_value.product_bidding_category.id',
                            'ad_group_criterion.listing_group.case_value.product_bidding_category.level',
                            'ad_group_criterion.listing_group.case_value.product_brand.value',
                            'ad_group_criterion.listing_group.case_value.product_channel.channel',
                            'ad_group_criterion.listing_group.case_value.product_condition.condition',
                            'ad_group_criterion.listing_group.case_value.product_custom_attribute.index',
                            'ad_group_criterion.listing_group.case_value.product_custom_attribute.value',
                            'ad_group_criterion.listing_group.case_value.product_type.level',
                            'ad_group_criterion.listing_group.case_value.product_item_id.value',
                            'ad_group_criterion.listing_group.case_value.product_type.value',
                            'ad_group_criterion.listing_group.parent_ad_group_criterion',
                            'ad_group_criterion.listing_group.type',
                            'ad_group_criterion.mobile_app_category.mobile_app_category_constant',
                            'ad_group_criterion.mobile_application.app_id',
                            'ad_group_criterion.mobile_application.name',
                            'ad_group_criterion.negative',
                            'ad_group_criterion.parental_status.type',
                            'ad_group_criterion.percent_cpc_bid_micros',
                            'ad_group_criterion.placement.url',
                            'ad_group_criterion.position_estimates.estimated_add_cost_at_first_position_cpc',
                            'ad_group_criterion.position_estimates.estimated_add_clicks_at_first_position_cpc',
                            'ad_group_criterion.position_estimates.first_page_cpc_micros',
                            'ad_group_criterion.position_estimates.first_position_cpc_micros',
                            'ad_group_criterion.position_estimates.top_of_page_cpc_micros',
                            'ad_group_criterion.quality_info.creative_quality_score',
                            'ad_group_criterion.quality_info.post_click_quality_score',
                            'ad_group_criterion.quality_info.quality_score',
                            'ad_group_criterion.quality_info.search_predicted_ctr',
                            'ad_group_criterion.resource_name',
                            'ad_group_criterion.status',
                            'ad_group_criterion.system_serving_status',
                            'ad_group_criterion.topic.path',
                            'ad_group_criterion.topic.topic_constant',
                            'ad_group_criterion.tracking_url_template',
                            'ad_group_criterion.type',
                            'ad_group_criterion.url_custom_parameters',
                            'ad_group_criterion.user_interest.user_interest_category',
                            'ad_group_criterion.user_list.user_list',
                            'ad_group_criterion.webpage.conditions',
                            'ad_group_criterion.webpage.coverage_percentage',
                            'ad_group_criterion.webpage.criterion_name',
                            'ad_group_criterion.webpage.sample.sample_urls',
                            'ad_group_criterion.youtube_channel.channel_id',
                            'ad_group_criterion.youtube_video.video_id'),
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
    resource          = 'ad_group_criterion',
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
  res <- rename_with(res, function(x) str_remove( str_to_lower(x), 'ad_?group_?criterion\\_?'), matches('ad\\_?group\\_?criterion\\_?', ignore.case = TRUE) ) %>%
    rename_with(getOption('gads.column.name.case.fun'))

  return(res)

}
