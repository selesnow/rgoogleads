.onLoad <- function(libname, pkgname) {

  # auth object
  .auth <<- gargle::init_AuthState(
    package     = "rgoogleads",
    auth_active = TRUE
  )

  # where function
  utils::globalVariables("where")

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
  op.gads <- list(gads.developer.token      = developer_token,
                  gads.api.version          = "v8",
                  gads.login.customer.id    = login_customer_id,
                  gads.customer.id          = customer_id,
                  gads.multi.account.verbos = FALSE,
                  gads.base.url             = 'https://googleads.googleapis.com/')

  toset <- !(names(op.gads) %in% names(op))
  if (any(toset)) options(op.gads[toset])

  invisible()
}

.onAttach <- function(lib, pkg,...){

  packageStartupMessage(rgoogleadsWelcomeMessage())

}


rgoogleadsWelcomeMessage <- function(){
  # library(utils)

  paste0("\n",
         "---------------------\n",
         "Welcome to rgoogleads version ", utils::packageDescription("rgoogleads")$Version, "\n",
         "\n",
         "Author:           Alexey Seleznev (Head of analytics dept at Netpeak).\n",
         "Telegram channel: https://t.me/R4marketing \n",
         "YouTube channel:  https://www.youtube.com/R4marketing/?sub_confirmation=1 \n",
         "Email:            selesnow@gmail.com\n",
         "Site:             https://selesnow.github.io \n",
         "Blog:             https://alexeyseleznev.wordpress.com \n",
         "Facebook:         https://facebook.com/selesnown \n",
         "Linkedin:         https://www.linkedin.com/in/selesnow \n",
         "\n",
         "Type ?rgoogleads for the main documentation.\n",
         "The github page is: https://github.com/selesnow/rgoogleads/\n",
         "Package site: https://selesnow.github.io/rgoogleads/\n",
         "\n",
         "Suggestions and bug-reports can be submitted at: https://github.com/selesnow/rgoogleads/issues\n",
         "Or contact: <selesnow@gmail.com>\n",
         "\n",
         "\tTo suppress this message use:  ", "suppressPackageStartupMessages(library(rgoogleads))\n",
         "---------------------\n"
  )
}
