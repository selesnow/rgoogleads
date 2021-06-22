gads_check_errors <- function(out, client_id, verbose, request_id) {

  # check for empty data
  if ( length(out) == 0 ) {
    msg <- 'empty request, please check client_id, date_from, date_to and where arguments, fox and repeate query'
    if (verbose) cli_alert_warning(c(client_id, ": ", msg, ". Request ID: ", request_id))
    return(NULL)
  }

  # check for error
  if ( !is.null(out[[1]]$error) ) {
    msg <- ifelse(is.null(out[[1]]$error$details[[1]]$errors[[1]]$message), out[[1]]$error$message, paste(out[[1]]$error$message, out[[1]]$error$details[[1]]$errors[[1]]$message, sep = ": "))
    cli_alert_danger(c(client_id, ": ", msg))
    cli_alert_danger(c("Request ID: ", request_id))
    stop(paste(client_id, msg))
  }

}
