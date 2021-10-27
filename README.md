The `rytstat` package for authorization uses the [gargle](https://gargle.r-lib.org/) package, the credentials obtained during authorization are stored exclusively on your local PC, you can find out the folder into which the credentials are cached using the `ryt_auth_cache_path()` function.

For loading data from your YouTube channel `rytstat` needs next scopes:

* View monetary and non-monetary YouTube Analytics reports for your YouTube content
* View your YouTube account
* View and manage your assets and associated content on YouTube
* View YouTube Analytics reports for your YouTube content
* Manage your YouTube account

For more details see [Official YouTube API documentation](https://developers.google.com/youtube/reporting/guides/authorization#identify-access-scopes).

The package does not transfer your credentials or data obtained from your advertising accounts to third parties, however, the responsibility for information leakage remains on the side of the package user. The author does not bear any responsibility for their safety, be careful when transferring cached credentials to third parties.

For more details, I recommend that you read the following articles from the official documentation of the gargle package:

* [Stewarding the cache of user tokens](https://www.tidyverse.org/blog/2021/07/gargle-1-2-0/)
* [Auth when using R in the browser](https://cran.r-project.org/package=gargle/vignettes/auth-from-web.html)
* [How gargle gets tokens](https://cran.r-project.org/package=gargle/vignettes/how-gargle-gets-tokens.html)

### Authorization process

You run `gads_auth('me@gmail.com')` and start [OAuth Dance](https://medium.com/typeforms-engineering-blog/the-beginners-guide-to-oauth-dancing-4b8f3666de10) in the browser:

![Typical OAuth dance in the browser, when initiated from within R](https://raw.githubusercontent.com/selesnow/rytstat/master/man/figures/auth_process.png)

Upon success, you see this message in the browser:

`Authentication complete. Please close this page and return to R.`

And you credentials cached locally on your PC in the form of RDS files.

### Key points
* By default, gargle caches user tokens centrally, at the user level, and their keys or labels also convey which Google identity is associated with each token.
* Token storage relies on serialized R objects. That is, tokens are stored locally on your PC in the form of RDS files.

### Use own OAuth client
You can use own OAuth app:

```r
app <- httr::oauth_app(appname = "app name", key = "app id", secret = "app secret")
ryt_auth_configure(app = app)

# or from json file 
ryt_auth_configure(path = 'D:/ga_auth/app.json')

# run authorization
ryt_auth('me@gmail.com')
```
