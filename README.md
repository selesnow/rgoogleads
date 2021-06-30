
# rgoogleads <a href='https:/selesnow.github.io/rgoogleads'><img src='man/figures/rgoogleads.png' align="right" height="138.5" /></a>

<!-- badges: start -->
<!-- badges: end -->

The goal of rgoogleads is to loadin data from [Google Ads API](https://developers.google.com/google-ads/api/docs/start)

## Installation

Now you can install package only from [GitHub](https://github.com) with:
```r
devtools::install_github('selesnow/rgoogleads')
```


## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(rgoogleads)

# auth
# your google app
gads_
gads_auth(email = 'myname@gmail.com')

# set manager customer id, if your login over MCC
gads_set_login_customer_id('xxx-xxx-xxxx')

# set client customer id
gads_set_customer_id('xxx-xxx-xxxx')

# loading data
ad_group_report <- gads_get_report(
  resource    = "ad_group",
  fields = c("ad_group.campaign",
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
