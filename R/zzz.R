.onLoad <- function(libname, pkgname) {

  .auth <<- gargle::init_AuthState(
    package     = "rgoogleads",
    auth_active = TRUE
  )

  ## adwords developer token
  if ( Sys.getenv("GADS_DEVELOPER_TOKEN") != "" ) {

    developer_token <- Sys.getenv("GADS_DEVELOPER_TOKEN")
    cli_alert_info('Set developer token from environt variables')

  } else {

    developer_token <- 'EBkkx-znu2cZcEY7e74smg'

  }

  ## login customer id
  if ( Sys.getenv("GADS_LOGIN_CUSTOMER_ID") != "" ) {

    login_customer_id <- Sys.getenv("GADS_LOGIN_CUSTOMER_ID")
    cli_alert_info('Set login customer id from environt variables')

  } else {

    login_customer_id <- NULL

  }

  ## login customer id
  if ( Sys.getenv("GADS_CUSTOMER_ID") != "" ) {

    customer_id <- Sys.getenv("GADS_CUSTOMER_ID")
    cli_alert_info('Set customer id from environt variables')

  } else {

    customer_id <- NULL

  }

  # options
  op <- options()
  op.gads <- list(gads.developer.token   = developer_token,
                  gads.api.version       = "v8",
                  gads.login.customer.id = login_customer_id,
                  gads.customer.id       = customer_id)

  toset <- !(names(op.gads) %in% names(op))
  if (any(toset)) options(op.gads[toset])

  invisible()
}
