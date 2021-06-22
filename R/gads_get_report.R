gads_get_report <- function(
  resource = 'campaign',
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
  where = NULL,
  order_by = NULL,
  limit = NULL,
  parameters = NULL,
  date_from = Sys.Date() - 15,
  date_to = Sys.Date() - 1,
  customer_id       = getOption('gads.customer.id'),
  login_customer_id = getOption('gads.login.customer.id'),
  include_resource_name = FALSE
) {


  # check how many accounts
  if ( length(customer_id) == 1 ) {

    # if only one account use gads_get_report
    res <- gads_get_report_helper(
      resource = resource,
      fields = fields,
      where = where,
      order_by = order_by,
      limit = limit,
      parameters = parameters,
      date_from = date_from,
      date_to = date_to,
      customer_id = customer_id,
      login_customer_id = login_customer_id,
      include_resource_name = include_resource_name)

  } else {

    cli_alert_info('Multi account request')
    # if multi accounts use pbapply
    res <- pblapply(customer_id,
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
                       verbose = FALSE)
                   })
    )

    # get res and errors
    res <- transpose(res)

    # check errors
    if ( length(res$error) > 0 ) {

      for ( err in res$error ) {

        if ( is.null(err) ) next

        cli_alert_danger(err$message)

      }

    }

    # bind
    res <- bind_rows(res$result)

    # res
    cli_alert_success('Success! Loaded {nrow(res)} rows!')

  }

  return(res)

}
