#' Get resource or field information.
#'
#' @return List of resource or field metadata
#' @param object_name name of resource, resource's field, segmentation field or metric
#' @export
#'
#' @seealso \href{https://developers.google.com/google-ads/api/docs/concepts/field-service}{Resource Metadata API documentation}
#'
#' @examples
#' \dontrun{
#' ad_group_info <- gads_get_fields("ad_group")
#' }
gads_get_fields <- function(
  object_name
)
{

  # check token
  gargle::token_tokeninfo(gads_token())

  # send query
  ans <- GET(
    url = str_glue('https://googleads.googleapis.com/{options("gads.api.version")}/googleAdsFields/{object_name}'),
    add_headers(
      Authorization    = str_glue("Bearer {gads_token()$auth_token$credentials$access_token}"),
      `developer-token`= gads_developer_token()
    )
  )

  # get result
  rawres <- content(ans)

  # rq id
  rq_ids <- unique(ans$headers$`request-id`)
  rgoogleads$last_request_id <- rq_ids

  # check for error
  gads_check_errors(out = rawres, client_id = object_name, request_id = rq_ids)

  # parsing
  for ( x in names(rawres) ) {
    if (is.list(rawres[[x]])) rawres[[x]] <- unlist(rawres[[x]])
  }

  # success msg
  cli_alert_success('Success!')

  # return data
  return(rawres)
}
