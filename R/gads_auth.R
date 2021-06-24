## This file is the interface between bigrquery and the
## auth functionality in gargle.

# initialization happens in .onLoad
.auth <- NULL

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
#' httr's class \code{request}, i.e. a token that has been prepared with
#' \code{\link[httr:config]{httr::config()}} and has a \link[httr:Token-class]{Token2.0} in the
#' \code{auth_token} component.
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
#' ## use a service account token
#' gads_auth(path = "foofy-83ee9e7c9c48.json")
#' }
gads_auth <- function(
  email           = gargle::gargle_oauth_email(),
  path            = NULL,
  cache           = gargle::gargle_oauth_cache(),
  use_oob         = gargle::gargle_oob_default(),
  developer_token = options('gads.developer.token'),
  token           = NULL) {

  if ( is.null(gads_oauth_app()) )

  cred <- gargle::token_fetch(
    scopes = 'https://www.googleapis.com/auth/adwords',
    app = gads_oauth_app() %||% gads_default_ouath_app(),
    email = email,
    path = path,
    package = "rgoogleads",
    cache = cache,
    use_oob = use_oob,
    token = token,
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

# deauth
gads_deauth <- function() {
  .auth$set_auth_active(FALSE)
  .auth$clear_cred()

  invisible()
}

# token
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
gads_has_token <- function() {
  inherits(.auth$cred, "Token2.0")
}

# auth config
gads_auth_configure <- function(app, path, api_key) {
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

  invisible(.auth)
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
gads_api_key <- function() .auth$api_key
gads_developer_token <- function() .auth$cred$params$user_params$developer_token
gads_oauth_app <- function() .auth$app

# setters


# default app
gads_default_ouath_app <- function() {

  app <- httr::oauth_app(
    'rgoogleads',
    '2288143445-af03i872746r73fnslk8k2q5msa1umao.apps.googleusercontent.com',
    '9Jh5Ax9rE4HnhNM8YHIXqTae'
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
