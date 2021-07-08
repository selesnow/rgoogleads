#' Get data from Google Ads API
#'
#' @param resource Report type, you can get list of all acessible resource using \code{\link{gads_get_metadata}}. For more information see \href{https://developers.google.com/google-ads/api/fields/v8/overview#list-of-all-resources}{link with list of all resources}
#' @param fields character vector, list of report fields, all report has own fields list. You can get list of accesible resource fields using \code{\link{gads_get_fields}} for example \href{https://developers.google.com/google-ads/api/fields/v8/campaign}{see field list of campaign report}.
#' @param where Filter, for example you can filter campaigns by status \code{where = "campaign.status = 'ENABLED'"}.
#' @param order_by Sorting, character vectors of fields and sorting directions, for example \code{order_by = c("campaign.name DESC", "metrics.clicks")}.
#' @param limit Maximun rows in report
#' @param parameters Query parameters, for example \code{parameters = "include_drafts=true"}.
#' @param date_from Beginning of date range. Format: 2018-01-01
#' @param date_to End of date rage. Format: 2018-01-10
#' @param customer_id Google Ads client customer id, supports a single account id: "xxx-xxx-xxxx" or a vector of ids from the same Google Ads MCC: c("xxx-xxx-xxxx", "xxx-xxx-xxxx")
#' @param login_customer_id Google Ads manager customer id
#' @param include_resource_name Get resource names fields in report
#' @param verbose Console log output
#' @param cl A cluster object created by \code{\link{makeCluster}}, or an integer to indicate number of child-processes (integer values are ignored on Windows) for parallel evaluations (see Details on performance).
#'
#' @return tibble with the Google Ads Data.
#' @seealso
#' \itemize{
#'   \item \href{https://developers.google.com/google-ads/api/fields/v8/overview}{Oficial Google Ads API Reports documantation}
#'   \item \href{https://developers.google.com/google-ads/api/fields/v8/overview_query_builder}{Google Ads Query Builder}
#' }
#' @export
#'
#' @examples
#' \dontrun{
#' # set client id
#' gads_set_login_customer_id('xxx-xxx-xxxx')
#'
#' # set manager id if you work under MCC
#' gads_set_customer_id('xxx-xxx-xxxx')
#'
#' # default paramas is campaign performance report
#' campaign_stat <- gads_get_report()
#'
#'
#' # you can load data from several client accounts at once
#' # from the same Google Ads MCC
#' # client ids
#' accounts <- c('xxx-xxx-xxxx', 'yyy-yyy-yyyy')
#' # loading data
#' multi_rep <- gads_get_report(
#'     date_from = as.Date('2021-06-10'),
#'     date_to = as.Date('2021-06-17'),
#'     customer_id = accounts
#' )
#'
#' # ------------------
#' # using more arguments for other reports
#' group_report <- gads_get_report(
#' customer_id = 4732519773,
#' resource    = "ad_group",
#' fields = c("ad_group.campaign",
#'            "ad_group.id",
#'            "ad_group.name",
#'            "ad_group.status",
#'            "metrics.clicks",
#'            "metrics.cost_micros"),
#' date_from   = "2021-06-10",
#' date_to     = "2021-06-17",
#' where       = "ad_group.status = 'ENABLED'",
#' order_by    = c("metrics.clicks DESC", "metrics.cost_micros"),
#' limit       = 30000
#' )
#'
#' # ------------------
#' # parallel loading mode
#' # note: you must using login_customer_id agrument in parallel mode
#' # because oprions gads_set_login_customer_id() does't work in parallel mode loading
#' library(parallel)
#'
#' # make core cluster
#' cl <- makeCluster(4)
#'
#' multi_rep <- gads_get_report(
#'   date_from         = as.Date('2021-06-10'),
#'   date_to           = as.Date('2021-06-17'),
#'   customer_id       = c('111-111-1111',
#'                         '222-222-2222',
#'                         '333-333-3333',
#'                         '444-444-4444',
#'                         '555-555-5555'),
#'   login_customer_id = "999-999-9999",
#'   cl                = cl
#' )
#' }
gads_get_report <- function(
  resource              = 'campaign',
  fields = c('campaign.id',
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
  customer_id           = getOption('gads.customer.id'),
  login_customer_id     = getOption('gads.login.customer.id'),
  include_resource_name = FALSE,
  cl                    = NULL,
  verbose               = TRUE
) {

  # check token
  gargle::token_tokeninfo(gads_token())

  # check how many accounts
  if ( length(customer_id) == 1 ) {

    # if only one account use gads_get_report
    res <- gads_get_report_helper(
      resource              = resource,
      fields                = fields,
      where                 = where,
      order_by              = order_by,
      limit                 = limit,
      parameters            = parameters,
      date_from             = date_from,
      date_to               = date_to,
      customer_id           = customer_id,
      login_customer_id     = login_customer_id,
      include_resource_name = include_resource_name,
      verbose               = verbose)

  } else {

    cli_alert_info('Multi account request')

    # check parallel
    if (!is.null(cl)) {
      # optins
      oldpar <- options('gads.multi.account.verbos')
      on.exit(options(oldpar))
      cli_alert_info('Verbose mode is deactive because you run loading in parallel mode!')
      options('gads.multi.account.verbos' = FALSE)
    }

    # define apply function
    if (getOption('gads.multi.account.verbos')) {

      cli_alert_info('Verbose mode is active for multi account loading!')
      cli_alert_info('start------------------------------------------->')

      mfun    <- 'lapply'
      verbose <- TRUE

      mfun_args <- list(
        customer_id,
        safely(
          function(x) {
            gads_get_report_helper(
              resource              = resource,
              fields                = fields,
              where                 = where,
              order_by              = order_by,
              limit                 = limit,
              parameters            = parameters,
              date_from             = date_from,
              date_to               = date_to,
              customer_id           = x,
              login_customer_id     = login_customer_id,
              include_resource_name = include_resource_name,
              verbose = verbose)
          }
        )
      )


    } else {

      mfun    <- 'pblapply'
      verbose <- FALSE

      mfun_args <- list(
        customer_id,
        safely(
          function(x) {
            gads_get_report_helper(
              resource              = resource,
              fields                = fields,
              where                 = where,
              order_by              = order_by,
              limit                 = limit,
              parameters            = parameters,
              date_from             = date_from,
              date_to               = date_to,
              customer_id           = x,
              login_customer_id     = login_customer_id,
              include_resource_name = include_resource_name,
              verbose = verbose)
          }),
        cl = cl
      )

    }

    # run function
    res <- do.call(mfun, mfun_args)

    # get res and errors
    res <- transpose(res)

    # check errors
    if ( length(res$error) > 0 ) {

      for ( err in res$error ) {

        if ( is.null(err) ) next

        cli_alert_danger(err$message)

      }

    }

    # check
    res_n <- list.filter(res$result, !is.null(.)) %>% length()
    err_n <- list.filter(res$error, !is.null(.)) %>% length()

    # bind
    res <- bind_rows(res$result)

    # res
    if (getOption('gads.multi.account.verbos') & verbose) cli_alert_info('end--------------------------------------------->')

    # number off error
    if (err_n > 0) {
      cli_alert_danger('Data loading was unsuccessful for {err_n} accounts.')
    }

    # check result
    if (nrow(res) == 0) {
      cli_alert_warning('The request you sent did not return any results, check the entered parameters and repeat the opposition.')
    } else if (res_n > err_n) {
      cli_alert_success('Success! Loaded {nrow(res)} rows!')
    } else if (res_n == err_n) {
      cli_alert_danger('!!! LOADING ERROR: see previos messages for details information')
    }

  }

  return(res)

}
