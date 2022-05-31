# fix no visible binding for global variable '.'
. <- NULL

#' Get all information about Google Ads Customer
#'
#' @param customer_id Google Ads customer id
#' @param verbose Processing log output into console
#'
#' @return Google Ads customer data
#'
#' @seealso \href{https://developers.google.com/google-ads/api/rest/common/search}{Method: SearchStream documentation}
#'
#' @export
gads_customer <- function(
  customer_id = getOption('gads.customer.id'),
  verbose = TRUE
) {

  # pars result
  data <- gads_get_report(
    resource          = "customer",
    fields            = c("customer.id",
                          "customer.descriptive_name",
                          "customer.manager",
                          "customer.currency_code",
                          "customer.time_zone",
                          "customer.auto_tagging_enabled",
                          "customer.has_partners_badge",
                          "customer.test_account"),
    customer_id       = customer_id,
    login_customer_id = customer_id,
    verbose           = verbose
  )

  data <- rename_with(data, gads_fix_names_regexp, everything(), regexp = 'customer\\_')

  # return the data
  return(data)
}
