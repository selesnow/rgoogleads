#' Get metada of object, RESOURCE, ATTRIBUTE, METRIC or SEGMENT
#'
#' @param category Object category
#' @param fields Metadata fields
#'
#' @return tibble with object metadata
#' important arrays in result:
#' \describe{
#'   \item{attributeResources}{Resources that can be using in \code{resource} argument in \code{\link{gads_get_report}}.}
#'   \item{metrics}{Metrics that are available to be selected with the resource in the \code{field} argument in \code{\link{gads_get_report}}. Only populated for fields where the category is RESOURCE.}
#'   \item{segments}{Segment keys that can be selected with the resource in the \code{field} argument in \code{\link{gads_get_report}}. These segment the metrics specified in the query. Only populated for fields where the category is RESOURCE.}
#'   \item{selectableWith}{Fields that can be selected alongside a given field, when not in the FROM clause. This attribute is only relevant when identifying resources or segments that are able to be selected in a query where they are not included by the resource in the FROM clause. As an example, if we are selecting \code{ad_group.id} and \code{segments.date} from \code{ad_group}, and we want to include attributes from \code{campaign}, we would need to check that \code{segments.date} is in the selectableWith attribute for campaign, since it's being selected alongside the existing \code{segments.date} field.}
#' }
#' @export
#'
#' @seealso \href{https://ads-developers.googleblog.com/2021/04/the-query-builder-blog-series-part-3.html}{The Query Builder Blog Series: Part 3 - Creating a Resource Schema}
#' and \href{https://developers.google.com/google-ads/api/docs/concepts/field-service}{Resource Metadata API documentation}
#'
#' @examples
#' \dontrun{
#' # get resource list
#' resources <- gads_get_metadata("RESOURCE")
#'
#' # get list of all objects
#' metadata <- gads_get_metadata("ALL")
#'
#' }
gads_get_metadata <- function(
  category = c("RESOURCE", "ATTRIBUTE", "METRIC", "SEGMENT", 'ALL'),
  fields   = c("name",
               "category",
               "data_type",
               "selectable",
               "filterable",
               "sortable",
               "selectable_with",
               "metrics",
               "segments",
               "is_repeated",
               "type_url",
               "enum_values",
               "attribute_resources")
) {

  # check category
  category <- toupper(category)
  match.arg(category)

  # --------------
  # compose query
  # select block
  fields <- gsub("[\\s\\n\\t]", "", tolower(fields), perl = TRUE) %>%
            tolower() %>%
            str_c(collapse = ', ')

  # where block
  if ( category == "ALL" ) {
    where_clause <- ""
  } else {
    where_clause <- str_glue("WHERE category = '{category}'")
  }

  # --------------
  # build GAQL Query
  body <- list(query =
                 str_glue('
       SELECT {fields}

       {where_clause}')) %>%
    toJSON(auto_unbox = T, pretty = T)

  # --------------
  # build query
  out <- request_build(
    method   = "POST",
    path     = str_glue('{options("gads.api.version")}/googleAdsFields:search'),
    body     = body,
    token    = gads_token(),
    base_url = getOption('gads.base.url')
  )

  # send request
  ans <- request_retry(
    out,
    encode = "json",
    add_headers(`developer-token`= gads_developer_token())
  )

  # request id
  rq_ids <- headers(ans)$`request-id`
  rgoogleads$last_request_id <- rq_ids

  # pars result
  data <- response_process(ans, error_message = gads_check_errors2)

  # parse
  res <- tibble(data = data$results) %>%
         unnest_wider(data) %>%
         rowwise() %>%
         mutate( across( where(is.list), function(col) if_else(is.null(col), list(col), list(unlist(col))) ) ) %>%
         rename_with( to_snake_case )

  # success msg
  cli_alert_success('Success! Loaded {nrow(res)} rows!')

  # return
  return(res)

}
