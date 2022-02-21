# cache
gads_get_fields_cached <- memoise(gads_get_fields)

# make query
gads_make_query <- function(
  resource              = 'campaign',
  fields                = c('campaign.id',
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
  during                = c(NA, "TODAY", "YESTERDAY", "LAST_7_DAYS", "LAST_BUSINESS_WEEK", "THIS_MONTH", "LAST_MONTH", "LAST_14_DAYS", "LAST_30_DAYS", "THIS_WEEK_SUN_TODAY", "THIS_WEEK_MON_TODAY", "LAST_WEEK_SUN_SAT", "LAST_WEEK_MON_SUN")
) {

  # check args
  during <- match.arg(during)

  # --------------
  # compose query
  # select block
  fields <- gsub("[\\s\\n\\t]", "",  fields, perl = TRUE) %>%
    tolower() %>%
    str_c('\t', .,collapse = ', \n')

  if ( any(is.null(date_from), is.null(date_to)) & is.null(where) ) {
    where_clause <- ""
  } else if ( !is.na(during) ) {
    where <- str_c(where, collapse = " \nAND ")

    if ( where == "" ) {
      where_clause <- str_glue("WHERE segments.date DURING {during}")
    } else {
      where <- str_c(where, collapse = " \nAND ")
      where_clause <- str_glue("WHERE segments.date DURING {during} \nAND {where}")
    }

  } else if ( any(is.null(date_from), is.null(date_to)) ) {
    where <- str_c(where, collapse = " \nAND ")
    where_clause <- str_glue("WHERE {where}")
  } else {
    sd <- format(as.Date(date_from), '%Y-%m-%d')
    fd <- format(as.Date(date_to), '%Y-%m-%d')
    where_clause <- ifelse( is.null(where), str_glue("WHERE segments.date BETWEEN '{sd}' AND '{fd}'"), str_glue("WHERE segments.date BETWEEN '{sd}' AND '{fd}' \nAND {where}") )
  }

  # params block
  params_clause <- ifelse( is.null(parameters), '', str_glue('PARAMETERS {parameters}') )

  # order by block
  order_by_clause <- ifelse( is.null(order_by), '', str_glue('ORDER BY {str_c(order_by, collapse=", ")}'))

  # limit block
  limit_clause <- ifelse( is.null(limit), '', str_glue('LIMIT {limit}') )

  gaql_query <- str_glue('
       SELECT\n
       {fields}

       FROM {resource}

       {where_clause}
       {order_by_clause}
       {limit_clause}
       {params_clause}')

  return(gaql_query)

}
