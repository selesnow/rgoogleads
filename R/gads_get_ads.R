#' Get Ads Dictionary From Google Ads Client Account
#'
#' @inheritParams gads_get_report
#' @param fields character vector, list pf report fields, all report has own fields list, for example \href{https://developers.google.com/google-ads/api/fields/v10/ad_group_ad}{see field list of ads report}.
#'
#' @seealso \href{https://developers.google.com/google-ads/api/fields/v10/ad_group_ad_query_builder}{Google Ads Query Builder}
#' @return tibble with ads dicrionary
#' @export
#' @examples
#' \dontrun{
#' # set client customer id
#' gads_set_login_customer_id('xxx-xxx-xxxx')
#'
#' # set manager id if you work under MCC
#' gads_set_customer_id('xxx-xxx-xxxx')
#'
#' # load ads list
#' myads <- gads_get_ads(
#'    fields = c("ad_group_ad.ad.id",
#'               "customer.descriptive_name",
#'               "ad_group_ad.ad.call_ad.description1",
#'               "ad_group_ad.ad.call_ad.description2"),
#'    where = 'ad_group_ad.status = "ENABLED"'
#' )
#'
#' }
gads_get_ads <- function(
  fields                = c('ad_group_ad.ad.id',
                            'ad_group_ad.ad.name',
                            'ad_group_ad.ad.added_by_google_ads',
                            'ad_group_ad.ad.app_ad.descriptions',
                            'ad_group_ad.ad.app_ad.headlines',
                            'ad_group_ad.ad.app_ad.html5_media_bundles',
                            'ad_group_ad.ad.app_ad.images',
                            'ad_group_ad.ad.app_ad.mandatory_ad_text',
                            'ad_group_ad.ad.call_ad.business_name',
                            'ad_group_ad.ad.call_ad.call_tracked',
                            'ad_group_ad.ad.call_ad.conversion_action',
                            'ad_group_ad.ad.app_engagement_ad.videos',
                            'ad_group_ad.ad.call_ad.conversion_reporting_state',
                            'ad_group_ad.ad.call_ad.country_code',
                            'ad_group_ad.ad.call_ad.description1',
                            'ad_group_ad.ad.call_ad.description2',
                            'ad_group_ad.ad.call_ad.disable_call_conversion',
                            'ad_group_ad.ad.call_ad.headline1',
                            'ad_group_ad.ad.call_ad.headline2',
                            'ad_group_ad.ad.call_ad.path1',
                            'ad_group_ad.ad.call_ad.path2',
                            'ad_group_ad.ad.call_ad.phone_number',
                            'ad_group_ad.ad.call_ad.phone_number_verification_url',
                            'ad_group_ad.ad.device_preference',
                            'ad_group_ad.ad.display_upload_ad.display_upload_product_type',
                            'ad_group_ad.ad.display_upload_ad.media_bundle',
                            'ad_group_ad.ad.display_url',
                            'ad_group_ad.ad.expanded_dynamic_search_ad.description',
                            'ad_group_ad.ad.expanded_dynamic_search_ad.description2',
                            'ad_group_ad.ad.expanded_text_ad.description',
                            'ad_group_ad.ad.expanded_text_ad.description2',
                            'ad_group_ad.ad.expanded_text_ad.headline_part1',
                            'ad_group_ad.ad.expanded_text_ad.headline_part2',
                            'ad_group_ad.ad.expanded_text_ad.headline_part3',
                            'ad_group_ad.ad.expanded_text_ad.path1',
                            'ad_group_ad.ad.expanded_text_ad.path2',
                            'ad_group_ad.ad.final_url_suffix',
                            'ad_group_ad.ad.final_urls',
                            'ad_group_ad.ad.final_mobile_urls',
                            'ad_group_ad.ad.gmail_ad.header_image',
                            'ad_group_ad.ad.gmail_ad.marketing_image',
                            'ad_group_ad.ad.gmail_ad.marketing_image_description',
                            'ad_group_ad.ad.gmail_ad.marketing_image_display_call_to_action.text',
                            'ad_group_ad.ad.gmail_ad.marketing_image_display_call_to_action.text_color',
                            'ad_group_ad.ad.gmail_ad.marketing_image_display_call_to_action.url_collection_id',
                            'ad_group_ad.ad.gmail_ad.marketing_image_headline',
                            'ad_group_ad.ad.gmail_ad.product_images',
                            'ad_group_ad.ad.gmail_ad.teaser.business_name',
                            'ad_group_ad.ad.gmail_ad.teaser.description',
                            'ad_group_ad.ad.gmail_ad.teaser.headline',
                            'ad_group_ad.ad.gmail_ad.teaser.logo_image',
                            'ad_group_ad.ad.hotel_ad',
                            'ad_group_ad.ad.image_ad.image_url',
                            'ad_group_ad.ad.image_ad.mime_type',
                            'ad_group_ad.ad.image_ad.name',
                            'ad_group_ad.ad.image_ad.pixel_height',
                            'ad_group_ad.ad.image_ad.pixel_width',
                            'ad_group_ad.ad.image_ad.preview_image_url',
                            'ad_group_ad.ad.image_ad.preview_pixel_height',
                            'ad_group_ad.ad.image_ad.preview_pixel_width',
                            'ad_group_ad.ad.legacy_app_install_ad',
                            'ad_group_ad.ad.legacy_responsive_display_ad.accent_color',
                            'ad_group_ad.ad.legacy_responsive_display_ad.allow_flexible_color',
                            'ad_group_ad.ad.legacy_responsive_display_ad.business_name',
                            'ad_group_ad.ad.legacy_responsive_display_ad.description',
                            'ad_group_ad.ad.legacy_responsive_display_ad.call_to_action_text',
                            'ad_group_ad.ad.legacy_responsive_display_ad.format_setting',
                            'ad_group_ad.ad.legacy_responsive_display_ad.logo_image',
                            'ad_group_ad.ad.legacy_responsive_display_ad.long_headline',
                            'ad_group_ad.ad.legacy_responsive_display_ad.main_color',
                            'ad_group_ad.ad.legacy_responsive_display_ad.marketing_image',
                            'ad_group_ad.ad.legacy_responsive_display_ad.price_prefix',
                            'ad_group_ad.ad.legacy_responsive_display_ad.promo_text',
                            'ad_group_ad.ad.legacy_responsive_display_ad.short_headline',
                            'ad_group_ad.ad.legacy_responsive_display_ad.square_logo_image',
                            'ad_group_ad.ad.legacy_responsive_display_ad.square_marketing_image',
                            'ad_group_ad.ad.local_ad.call_to_actions',
                            'ad_group_ad.ad.local_ad.descriptions',
                            'ad_group_ad.ad.local_ad.headlines',
                            'ad_group_ad.ad.local_ad.logo_images',
                            'ad_group_ad.ad.local_ad.marketing_images',
                            'ad_group_ad.ad.local_ad.path1',
                            'ad_group_ad.ad.local_ad.path2',
                            'ad_group_ad.ad.resource_name',
                            'ad_group_ad.ad.responsive_display_ad.accent_color',
                            'ad_group_ad.ad.responsive_display_ad.allow_flexible_color',
                            'ad_group_ad.ad.responsive_display_ad.business_name',
                            'ad_group_ad.ad.responsive_display_ad.call_to_action_text',
                            'ad_group_ad.ad.responsive_display_ad.control_spec.enable_asset_enhancements',
                            'ad_group_ad.ad.responsive_display_ad.control_spec.enable_autogen_video',
                            'ad_group_ad.ad.responsive_display_ad.format_setting',
                            'ad_group_ad.ad.responsive_display_ad.headlines',
                            'ad_group_ad.ad.responsive_display_ad.long_headline',
                            'ad_group_ad.ad.responsive_display_ad.main_color',
                            'ad_group_ad.ad.responsive_display_ad.price_prefix',
                            'ad_group_ad.ad.responsive_display_ad.promo_text',
                            'ad_group_ad.ad.responsive_display_ad.square_marketing_images',
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
    resource          = 'ad_group_ad',
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

  # fix names
  res <- rename_with(res, function(x) str_remove( str_to_lower(x), 'ad_group_ad\\_?'), matches('ad_group_ad', ignore.case = TRUE) ) %>%
         rename_with(getOption('gads.column.name.case.fun'))

}
