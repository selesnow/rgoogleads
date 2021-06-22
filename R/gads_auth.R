## This file is the interface between bigrquery and the
## auth functionality in gargle.

# initialization happens in .onLoad
.auth <- NULL

# main oauth function
gads_auth <- function(
  email    = gargle::gargle_oauth_email(),
  path     = NULL,
  cache    = gargle::gargle_oauth_cache(),
  use_oob  = gargle::gargle_oob_default(),
  developer_token = options('gads.developer.token'),
  token    = NULL) {

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
  drive_bullets(c("i" = "Going into deauthorized state"))
  withr::defer(
    drive_bullets(c("i" = "Restoring previous auth state")),
    envir = env
  )
  withr::defer({
    .auth$set_cred(original_cred)
    .auth$set_auth_active(original_auth_active)
  }, envir = env)
  gads_deauth()
}

# set login customer id
gads_set_login_customer_id <- function(customer_id) {
  # delete _
  customer_id <- str_replace_all(customer_id, '-', '')
  # set option
  options(gads.login.customer.id = customer_id)
  # info
  out_msg_id <- gsub("(\\d{3})(\\d{3})(\\d{4})", "\\1-\\2-\\3", customer_id)
  cli_alert_info(str_glue('You set login_customer_id: {out_msg_id}'))
}

# set login customer id
gads_set_customer_id <- function(customer_id) {
  # delete _
  customer_id <- str_replace_all(customer_id, '-', '')
  # set option
  options(gads.customer.id = customer_id)
  # info
  out_msg_id <- gsub("(\\d{3})(\\d{3})(\\d{4})", "\\1-\\2-\\3", customer_id)
  cli_alert_info(str_glue('You set customer_id: {out_msg_id}'))
}
