#' Helper function for check api answer on error
#'
#' @param out API answer
#' @param client_id Google Ads Customer id
#' @param verbose Console output
#' @param request_id Api request id
#'
#' @return stop the function when api request faild
#'
gads_check_errors <- function(out, client_id = NULL, verbose = FALSE, request_id) {

  # check for empty data
  if ( length(out) == 0 ) {
    msg <- 'empty request, please check client_id, date_from, date_to and where arguments, fox and repeate query'
    if (verbose) cli_alert_warning(c(client_id, ": ", msg, ". Request ID: ", request_id))
    return(NULL)
  }

  # check simple answer
  if ( !is.null(out$error) ) {
    msg <- try(out$error$details[[1]]$errors[[1]]$message)
    cli_alert_danger(c(client_id, ": ", msg))
    cli_alert_danger(c("Request ID: ", request_id))
    gads_abort(paste(client_id, msg))
  }

  # check multi answer
  err <- try(!is.null(out[[1]]$error), silent = TRUE)

  # if answer is multiple
  if ( ! "try-error" %in% class(err) ) {

    if ( !is.null(out[[1]]$error) ) {
      msg <- ifelse(is.null(out[[1]]$error$details[[1]]$errors[[1]]$message), out[[1]]$error$message, paste(out[[1]]$error$message, out[[1]]$error$details[[1]]$errors[[1]]$message, sep = ": "))
      cli_alert_danger(c(client_id, ": ", msg))
      cli_alert_danger(c("Request ID: ", request_id))
      cli_alert_danger("You can use gads_last_request_ids() for get last request id, if you want send ticket to google ads api support.")
      gads_abort(paste(client_id, msg))
     }

  }

}
