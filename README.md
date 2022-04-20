# rgoogleads: R package for work with Google Ads API

<!-- badges: start -->
[![](https://cranlogs.r-pkg.org/badges/grand-total/rgoogleads)](https://cran.r-project.org/package=rgoogleads)
[![](https://cranlogs.r-pkg.org/badges/rgoogleads?color=lightgrey)](https://cran.r-project.org/package=rgoogleads)
[![](https://cranlogs.r-pkg.org/badges/last-week/rgoogleads?color=lightgrey)](https://cran.r-project.org/package=rgoogleads)
[![CRAN
status](https://www.r-pkg.org/badges/version-ago/rgoogleads)](https://CRAN.R-project.org/package=rgoogleads)
[![R-CMD-check](https://github.com/selesnow/rgoogleads/workflows/R-CMD-check/badge.svg)](https://github.com/selesnow/rgoogleads/actions)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->


## Table of Contents

+ [Links](#links)
+ [Install](#install)
+ [Attach rgoogleads](#attach-rgoogleads)
+ [Main goal and capabilities of rgoogleads](#main-goal-and-capabilities-of-rgoogleads)
+ [Privacy Policy](#privacy-policy)
    + [Authorization process](#authorization-process)
    + [Key points](#key-points)
    + [Use own OAuth client](#use-own-oauth-client)
+ [Obtain Own Developer Token and create own OAuth client](#obtain-own-developer-token-and-create-own-oauth-client)
+ [Example of use rgoogleads](#example-of-use-rgoogleads)
+ [Package help](#package-help)
+ [Package chage log, news and updates](#package-chage-log-news-and-updates)
+ [Bug report and support](#bug-report-and-support)
+ [Tutorials](#tutorials)
+ [Author](#author)

## Links

This section contains links to the package documentation, as well as other useful links that may be useful to the package users.

* [rgoogleads package documentation site](https://selesnow.github.io/rgoogleads/docs/)
* [CRAN page](https://cran.r-project.org/package=rgoogleads)
* [Google Ads API documentation](https://developers.google.com/google-ads/api/docs/start)

## Install

You can install `rgoogleads` from [CRAN](https://cran.r-project.org/package=rgoogleads) or [GitHub](https://github.com):

```r
# install from CRAN
install.packages('rgoogleads')
```

```r
# install from github
devtools::install_github('selesnow/rgoogleads')
```

## Attach rgoogleads

```r
library(rgoogleads)
```

## Main goal and capabilities of rgoogleads

`rgoogleads` is R client for work with Google Ads API v8. Main goal of `rgoogleads` - load report data from Google Ads client account into R for analysis and visualizations.

Capabilities of `rgoogleads`:

* Authorization in the Google Ads API
* Loading a list of top-level accounts
* Loading the entire hierarchy of accounts from manager accounts
* Loading list of Google Ads client account objects: campaigns, ad groups, ads, etc.
* Loading statistics from Google Ads client account
* Loading resource metadata, resource fields, segments and metrics
* Loading forecast and historical metrics from Keyword Planning.

## Privacy Policy

The `rgoogleads` package for authorization uses the [gargle](https://gargle.r-lib.org/) package, the credentials obtained during authorization are stored exclusively on your local PC, you can find out the folder into which the credentials are cached using the `gads_auth_cache_path()` function.

For loading data from Google Ads Account `rgoogleads` needs `https://www.googleapis.com/auth/adwords` scope (Manage Your Google AdWords Campaigns), see [official Google Ads API documentation](https://developers.google.com/google-ads/api/docs/oauth/internals#scope). 

The package does not transfer your credentials or data obtained from your advertising accounts to third parties, however, the responsibility for information leakage remains on the side of the package user. The author does not bear any responsibility for their safety, be careful when transferring cached credentials to third parties.

For more details, I recommend that you read the following articles from the official documentation of the gargle package:

* [Stewarding the cache of user tokens](https://www.tidyverse.org/blog/2021/07/gargle-1-2-0/)
* [Auth when using R in the browser](https://cran.r-project.org/package=gargle/vignettes/auth-from-web.html)
* [How gargle gets tokens](https://cran.r-project.org/package=gargle/vignettes/how-gargle-gets-tokens.html)

### Authorization process

You run `gads_auth('me@gmail.com')` and start [OAuth Dance](https://medium.com/typeforms-engineering-blog/the-beginners-guide-to-oauth-dancing-4b8f3666de10) in the browser:

![Typical OAuth dance in the browser, when initiated from within R](http://img.netpeak.ua/alsey/1OE9JZ2.png)

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
gads_auth_configure(app = app)

# or from json file 
gads_auth_configure(path = 'D:/ga_auth/app.json')

# run authorization
gads_auth('me@gmail.com')
```

## Obtain Own Developer Token and create own OAuth client

For obtain own developer token and OAuth client read the following documentation:

* [Obtain Your Developer Token](https://developers.google.com/google-ads/api/docs/first-call/dev-token)
* [Configure a Google API Console Project for the Google Ads API](https://developers.google.com/google-ads/api/docs/first-call/oauth-cloud-project)

## Example of use rgoogleads

```r
library(rgoogleads)

# set own oauth app
gads_auth_configure(path = 'C:/auth/app.json')
# set your developer token if needed, or use default developer token
gads_auth(email = 'me@gmail.com', developer_token = "own developer token")

# get list of accessible accounts
my_accounts <- gads_get_accessible_customers()

# set manager account id (options)
gads_set_login_customer_id('xxx-xxx-xxxx')

# set client account id
gads_set_customer_id('xxx-xxx-xxxx')

# load report data
ad_group_report <- gads_get_report(
  resource    = "ad_group",
  fields      = c("ad_group.campaign",
                  "ad_group.id",
                  "ad_group.name",
                  "ad_group.status",
                  "metrics.clicks",
                  "metrics.cost_micros"),
  date_from   = "2021-06-10",
  date_to     = "2021-06-17",
  where       = "ad_group.status = 'ENABLED'",
  order_by    = c("metrics.clicks DESC", "metrics.cost_micros")
)
```

## Package help
For get help of `rgoogleads` use `?rgoogleads` or `?gads_get_report`.

## Package chage log, news and updates
You can follow the package updates at the [link](https://github.com/selesnow/rgoogleads/blob/master/NEWS.md).

## Bug report and support
If you encounter an error in the package, or you have suggestions for improving its functionality, you can create a issue using the [link](https://github.com/selesnow/rgoogleads/issues).

## Tutorials

This section contains links to articles dedicated to `rgoogleads`.

* Русскоязычные материалы
    * [Официальный плейлист с видео уроками](https://www.youtube.com/playlist?list=PLD2LDq8edf4qprTxRcflDwV9IvStiChHi)
        * [Авторизация в Google Ads API и запрос иерархии аккаунтов](https://www.youtube.com/watch?v=nYak5sVj07k&list=PLD2LDq8edf4qprTxRcflDwV9IvStiChHi&index=1), *Alexey Seleznev*
    * [Миграция с Google AdWords API на Google Ads API: подробный мануал](https://netpeak.net/ru/blog/migratsiya-s-google-adwords-api-na-google-ads-api-podrobnyy-manual/), *Alexey Seleznev*
    * [Как визуализировать показатель качества ключевых слов — рецепт скрипта на языке R](https://netpeak.net/ru/blog/kak-vizualizirovat-pokazatel-kachestva-klyuchevyh-slov-retsept-skripta-na-yazyke-r/), *Alexey Seleznev*
    * [Как оценить потерянный доход в Google Ads с помощью языка R](https://netpeak.net/ru/blog/kak-otsenit-poteryannyi-dokhod-v-google-adwords-s-pomoshch-yu-yazyka-r/), *Alexey Seleznev*
    * [Доклад: Зачем интернет маркетологу понимать что такое API. Разбираем устройство API Google Ads (Конференция 8P 2021)](https://youtu.be/wtXVwOBo518), *Alexey Seleznev*
* English
    * [Migrating from AdWords API to Google Ads API. A Comprehensive Guideline](https://netpeak.net/blog/migrating-from-adwords-api-to-google-ads-api-a-comprehensive-guideline/), *Alexey Seleznev*

If you have published an article about `rgoogleads` let me know about it in [telegram](https://t.me/AlexeySeleznev) or [email](mailto:selesnow@gmail.com) and I will add it to the list of links.

## Author
Alexey Seleznev, Head of analytics dept. at [Netpeak](https://netpeak.net/en/us/)
<Br>Telegram Channel: [R4marketing](https://t.me/R4marketing)
<Br>email: selesnow@gmail.com
<Br>facebook: [facebook.com/selesnow](https://www.facebook.com/selesnow)
<Br>blog: [alexeyseleznev.wordpress.com](https://alexeyseleznev.wordpress.com/)
