#' Download CSV of geo targets
#'
#' @param doc_page Link to Google Ads API Reference page
#' @param file_link Link to csv file, default is 'auto'
#'
#' @return data.frame with geo targets dictionary
#' @export
#' @seealso \href{https://developers.google.com/google-ads/api/reference/data/geotargets?hl=en}{Google Ads Geo Targets document page}
#'
#' @examples
#' \dontrun{
#' geo_dict <- gads_get_geo_targets()
#' }
gads_get_geo_targets <- function(
  doc_page  = 'https://developers.google.com/google-ads/api/reference/data/geotargets',
  file_link = 'auto'
  ) {

  # if auto detect file link
  if (file_link == 'auto') {

    file_link <- read_html(doc_page) %>%
                 html_element(xpath = "//a[contains(text(), 'Latest')]") %>%
                 html_attr('href') %>%
                 str_c('https://developers.google.com/', ., collapse = '')

  }

  # download zip
  zip_file <- tempfile(fileext = '.zip')
  download.file(file_link, zip_file)

  # unzip csv file
  file_name <- unzip(zipfile = zip_file, list = T)
  unzip(zipfile = zip_file)

  # read file
  data <- read.csv(file_name$Name) %>%
          rename_with(getOption('gads.column.name.case.fun'))

  # remove temp file
  file.remove(c(zip_file, file_name$Name))

  # success msg
  cli_alert_success('Success! Loaded {nrow(data)} rows!')

  # return
  return(data)

}
