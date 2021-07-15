## This file is the interface between bigrquery and the
## auth functionality in gargle.

# initialization happens in .onLoad
.auth <- NULL

## The roxygen comments for these functions are mostly generated from data
## in this list and template text maintained in gargle.
gargle_lookup_table <- list(
  PACKAGE     = "rgoogleads",
  YOUR_STUFF  = "your Google Ads Account",
  PRODUCT     = "Google Ads",
  API         = "Google Ads API",
  PREFIX      = "gads"
)

# main oauth function
#' Authorization in Google Ads API
#'
#'
#' @param email Optional. Allows user to target a specific Google identity.
#' @param path Path to JSON file with identifying the service account
#' @param cache Specifies the OAuth token cache.
#' @param use_oob Whether to prefer "out of band" authentication.
#' @param developer_token Your Google Ads Developer Token.
#' @param token A token with class \link[httr:Token-class]{Token2.0} or an object of
#' @eval gargle:::PREFIX_auth_description(gargle_lookup_table)
#' @eval gargle:::PREFIX_auth_details(gargle_lookup_table)
#' @eval gargle:::PREFIX_auth_params()
#' @family auth functions
#'
#' @return \link[httr:Token-class]{Token2.0}
#' @export
#'
#' @examples
#' \dontrun{
#' ## load/refresh existing credentials, if available
#' ## otherwise, go to browser for authentication and authorization
#' gads_auth()
#'
#' ## force use of a token associated with a specific email
#' gads_auth(email = "yourname@example.com")
#'
#' ## force a menu where you can choose from existing tokens or
#' ## choose to get a new one
#' gads_auth(email = NA)
#'
#' ## -----------------------
#' ## use own developer token
#' gads_auth(
#'     email = "yourname@example.com",
#'     developer_token = "your developer token"
#' )
#'
#' ## -----------------------
#' ## use own OAuth client app
#' gads_auth_configure(
#'     path = "path/to/your/oauth_client.json"
#' )
#'
#' gads_auth(email = "yourname@example.com")
#' }
gads_auth <- function(
  email           = gargle::gargle_oauth_email(),
  path            = NULL,
  cache           = gargle::gargle_oauth_cache(),
  use_oob         = gargle::gargle_oob_default(),
  developer_token = getOption('gads.developer.token'),
  token           = NULL) {

  # check default app
  app <- gads_oauth_app() %||% gads_default_ouath_app()

  # check link between app_secret and developer token
  if ( app$secret == "302158242268-eqkksdns6gbdl7qf0v59639pder9knql.apps.googleusercontent.com" & developer_token != "EBkkx-znu2cZcEY7e74smg" ) {
    gads_abort("You can`t use default oauth app with own developer token, please create default app and set it by gads_auth_configure()")
  }

  cred <- gargle::token_fetch(
    scopes  = 'https://www.googleapis.com/auth/adwords',
    app     = app,
    email   = email,
    path    = path,
    package = "rgoogleads",
    cache   = cache,
    use_oob = use_oob,
    token   = token,
    user_params = list(developer_token = developer_token)
  )

  if (!inherits(cred, "Token2.0")) {
    stop(
      "Can't get Google credentials.\n",
      "Are you running rgoogleads in a non-interactive session? Consider:\n",
      "  * Call `gads_auth()` directly with all necessary specifics.\n",
      call. = FALSE
    )
  }
  .auth$set_cred(cred)
  .auth$set_auth_active(TRUE)

  invisible()
}

#' Suspend authorization
#' @eval gargle:::PREFIX_deauth_description_with_api_key(gargle_lookup_table)
#' @family auth functions
#' @return only suspend authorization
#' @export
gads_deauth <- function() {
  .auth$set_auth_active(FALSE)
  .auth$clear_cred()

  invisible()
}

#' Produce configured token
#'
#' @eval gargle:::PREFIX_token_description(gargle_lookup_table)
#' @eval gargle:::PREFIX_token_return()
#' @family low-level API functions
#' @export
gads_token <- function() {
  if (isFALSE(.auth$auth_active)) {
    return(NULL)
  }
  if (!gads_has_token()) {
    gads_auth()
  }
  httr::config(token = .auth$cred)
}

# has token
#' Is there a token on hand?
#'
#' @eval gargle:::PREFIX_has_token_description(gargle_lookup_table)
#' @eval gargle:::PREFIX_has_token_return()
#' @family low-level API functions
#' @export
gads_has_token <- function() {
  inherits(.auth$cred, "Token2.0")
}

# auth config
#' Edit and view auth configuration
#'
#' @eval gargle:::PREFIX_auth_configure_description(gargle_lookup_table)
#' @eval gargle:::PREFIX_auth_configure_params()
#' @eval gargle:::PREFIX_auth_configure_return(gargle_lookup_table)
#' @param developer_token Your Google Ads Developer Token.
#'
#' @family auth functions
#' @export
#' @examples
#' \dontrun{
#' # see and store the current user-configured OAuth app (probaby `NULL`)
#' (original_app <- gads_oauth_app())
#'
#' # see and store the current user-configured API key (probaby `NULL`)
#' (original_api_key <- gads_api_key())
#'
#' if (require(httr)) {
#'   # bring your own app via client id (aka key) and secret
#'   google_app <- httr::oauth_app(
#'     "my-awesome-google-api-wrapping-package",
#'     key = "YOUR_CLIENT_ID_GOES_HERE",
#'     secret = "YOUR_SECRET_GOES_HERE"
#'   )
#'   google_key <- "YOUR_API_KEY"
#'   gads_auth_configure(app = google_app, api_key = google_key)
#'
#'   # confirm the changes
#'   gads_oauth_app()
#'   gads_api_key()
#'
#'   # bring your own app via JSON downloaded from Google Developers Console
#'   # this file has the same structure as the JSON from Google
#'   gads_auth_configure(path = app_path)
#'
#'   # confirm the changes
#'   gads_oauth_app()
#'
#'   # use own developer token
#'   gads_auth_configure(developer_token = 'Your developer token')
#'
#' }
#'
#' # restore original auth config
#' gs4_auth_configure(app = original_app, api_key = original_api_key)
#' }
#' @export
gads_auth_configure <- function(app, path, api_key, developer_token) {
  if (!missing(app) && !missing(path)) {
    gads_abort("Must supply exactly one of {.arg app} or {.arg path}, not both")
  }
  stopifnot(missing(api_key) || is.null(api_key) || is_string(api_key))

  if (!missing(path)) {
    stopifnot(is_string(path))
    app <- gargle::oauth_app_from_json(path)
  }
  stopifnot(missing(app) || is.null(app) || inherits(app, "oauth_app"))

  if (!missing(app) || !missing(path)) {
    .auth$set_app(app)
  }

  if (!missing(api_key)) {
    .auth$set_api_key(api_key)
  }

  if (!missing(developer_token)) {
    options('gads.developer.token' = developer_token)
  }

  invisible(.auth)
}

#' @export
#' @rdname gads_auth_configure
gads_auth_cache_path <- function() {

  if ( gads_has_token() ) {
    .auth$cred$cache_path
  } else {
    cli_alert_warning("You need to log in to google account")
  }

}

# gads abort
gads_abort <- function(message, ..., .envir = parent.frame()) {
  cli::cli_div(theme = gads_theme())
  cli::cli_abort(message = message, ..., .envir = .envir)
}

# is_path is_string
is_path <- function(x) is.character(x) && !inherits(x, "drive_id")
is_string <- function(x) length(x) == 1L && is_path(x)

# theme
gads_theme <- function() {
  list(
    span.field = list(transform = single_quote_if_no_color),
    # I want to style the Drive file names similar to cli's `.file` style,
    # except cyan instead of blue
    span.drivepath = list(
      color = "cyan",
      fmt = utils::getFromNamespace("quote_weird_name", "cli")
    ),
    # since we're using color so much elsewhere, e.g. Drive file names, I think
    # the standard bullet should be "normal" color
    ".memo .memo-item-*" = list(
      "text-exdent" = 2,
      before = function(x) paste0(cli::symbol$bullet, " ")
    )
  )
}

is_testing <- function() {
  identical(Sys.getenv("TESTTHAT"), "true")
}

single_quote_if_no_color <- function(x) quote_if_no_color(x, "'")

quote_if_no_color <- function(x, quote = "'") {
  # TODO: if a better way appears in cli, use it
  # @gabor says: "if you want to have before and after for the no-color case
  # only, we can have a selector for that, such as:
  # span.field::no-color
  # (but, at the time I write this, cli does not support this yet)
  if (cli::num_ansi_colors() > 1) {
    x
  } else {
    paste0(quote, x, quote)
  }
}

# getters
#' @export
#' @rdname gads_auth_configure
gads_api_key <- function() .auth$api_key

#' @export
#' @rdname gads_auth_configure
gads_developer_token <- function() {

  dev_token <- .auth$cred$params$user_params$developer_token

  if ( is.null(dev_token) ) {
    dev_token <- getOption('gads.developer.token')
  }

  return(dev_token)

}


#' @export
#' @rdname gads_auth_configure
gads_oauth_app <- function() .auth$app

#' Get info on current user
#'
#' @eval gargle:::PREFIX_user_description()
#' @eval gargle:::PREFIX_user_seealso()
#' @eval gargle:::PREFIX_user_return()
#'
#' @export
gads_user <- function() {
  if (gads_has_token()) {
    gargle::token_email(gads_token())
  } else {
    cli_alert_info("Not logged in as any specific Google user")
    invisible()
  }
}


# default app
gads_default_ouath_app <- function() {

  app <- httr::oauth_app(
    'rgoogleads',
    '302158242268-eqkksdns6gbdl7qf0v59639pder9knql.apps.googleusercontent.com',
    'l5_BBLUcd-LFkWHdnjuS9ACt'
    )

  return(app)

}

# local deauth
local_deauth <- function(env = parent.frame()) {
  original_cred <- .auth$get_cred()
  original_auth_active <- .auth$auth_active
  gads_bullets(c("i" = "Going into deauthorized state"))
  withr::defer(
    gads_bullets(c("i" = "Restoring previous auth state")),
    envir = env
  )
  withr::defer({
    .auth$set_cred(original_cred)
    .auth$set_auth_active(original_auth_active)
  }, envir = env)
  gads_deauth()
}

gads_bullets <- function(text, .envir = parent.frame()) {
  quiet <- gads_quiet()
  if (quiet) {
    return(invisible())
  }
  cli::cli_div(theme = gads_theme())
  cli::cli_bullets(text = text, .envir = .envir)
}

gads_quiet <- function() {
  getOption("gads_quiet", default = NA)
}


#' Set manager customer id in current R session
#'
#' @param customer_id your manager customer id
#'
#' @return only set options
#' @export
gads_set_login_customer_id <- function(customer_id) {
  # delete _
  customer_id <- str_replace_all(customer_id, '-', '')
  # set option
  options(gads.login.customer.id = customer_id)
  # info
  out_msg_id <- gsub("(\\d{3})(\\d{3})(\\d{4})", "\\1-\\2-\\3", customer_id)
  cli_alert_info(str_glue('You set login_customer_id: {out_msg_id}'))
}


#' Set client customer id in current R session
#'
#' @param customer_id your client customer id
#'
#' @return only set options
#' @export
gads_set_customer_id <- function(customer_id) {
  # delete _
  customer_id <- str_replace_all(customer_id, '-', '')
  # set option
  options(gads.customer.id = customer_id)
  # info
  out_msg_id <- gsub("(\\d{3})(\\d{3})(\\d{4})", "\\1-\\2-\\3", customer_id)
  cli_alert_info(str_glue('You set customer_id: {out_msg_id}'))
}
