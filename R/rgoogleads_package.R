#' Loading Data From 'Google Ads API'
#'
#' @description
#' \if{html}{\figure{rgoogleads.png}{options: align='right' alt='logo' width='120'}}
#' Interface for loading data from 'Google Ads API',
#' see <https://developers.google.com/google-ads/api/docs/start>.
#' Package provide function for authorization and loading reports.
#'
#' Capabilities of \code{rgoogleads}:
#' \itemize{
#'   \item Authorization in the Google Ads API
#'   \item Loading a list of top-level accounts
#'   \item Loading the entire hierarchy of accounts from manager accounts
#'   \item Loading list of Google Ads client account objects: campaigns, ad groups, ads, etc.
#'   \item Loading statistics from Google Ads client account
#'   \item Loading resource metadata, resource fields, segments and metrics
#' }
#'
#' @examples
#' \dontrun{
#' library(rgoogleads)
#'
#' # set own oauth app
#' gads_auth_configure(path = 'C:/auth/app.json')
#' # set your developer token if needed, or use default developer token
#' gads_auth(email = 'me@gmail.com', developer_token = "own developer token")
#'
#' # get list of accessible accounts
#' my_accounts <- gads_get_accessible_customers()
#'
#' # set manager account id
#' gads_set_login_customer_id('xxx-xxx-xxxx')
#'
#' # set client account id
#' gads_set_customer_id('xxx-xxx-xxxx')
#'
#' # load report data
#' ad_group_report <- gads_get_report(
#'   resource    = "ad_group",
#'   fields = c("ad_group.campaign",
#'              "ad_group.id",
#'              "ad_group.name",
#'              "ad_group.status",
#'              "metrics.clicks",
#'              "metrics.cost_micros"),
#'   date_from   = "2021-06-10",
#'   date_to     = "2021-06-17",
#'   where       = "ad_group.status = 'ENABLED'",
#'   order_by    = c("metrics.clicks DESC", "metrics.cost_micros")
#' )
#' }
#' @
#' @author Alexey Seleznev
#' @seealso
#' \itemize{
#'   \item \href{https://developers.google.com/google-ads/api/docs/start}{Oficial Google Ads API documantation}
#'   \item \href{https://developers.google.com/google-ads/api/fields/v8/overview_query_builder}{Google Ads Query Builder}
#'   \item \href{https://selesnow.github.io/rgoogleads/}{rgoogleads home page}
#' }
#'
#' @docType package
#' @name rgoogleads-package
#' @aliases rgoogleads
NULL
