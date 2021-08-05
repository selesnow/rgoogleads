## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  eval = FALSE,
  comment = "#>"
)

## ---- eval = TRUE, results = "asis", echo=FALSE-------------------------------

migrate_table <- data.frame(
  operation = c("Авторизация", "Запрос метаданных", "Запрос отчётов"),
  radwords = c("doAuth()", "reports(), metrics()", "statement() + getData()"),
  rgoogleads = c("gads_auth_configure() + gads_auth()", "gads_get_metadata(), gads_get_fields()", "gads_get_report()")
  )

DT::datatable(
  migrate_table, 
  colnames = c("Операция", "RAdwords", "rgoogleads"),
  options = list(pageLength = 5, dom = 'tip'))



## ---- eval = TRUE, results = "asis", echo=FALSE-------------------------------
library(magrittr)
library(rvest)
# reports_table <- data.frame(
#   adwords = c("ACCOUNT_PERFORMANCE_REPORT", "AD_PERFORMANCE_REPORT", "ADGROUP_PERFORMANCE_REPORT", "AGE_RANGE_PERFORMANCE_REPORT",
#               "AUDIENCE_PERFORMANCE_REPORT", "AUTOMATIC_PLACEMENTS_PERFORMANCE_REPORT", "BID_GOAL_PERFORMANCE_REPORT", "BUDGET_PERFORMANCE_REPORT",
#               "CALL_METRICS_CALL_DETAILS_REPORT", "CAMPAIGN_AD_SCHEDULE_TARGET_REPORT", "CAMPAIGN_CRITERIA_REPORT", "CAMPAIGN_PERFORMANCE_REPORT",
#               "CAMPAIGN_SHARED_SET_REPORT", "CAMPAIGN_LOCATION_TARGET_REPORT", "CLICK_PERFORMANCE_REPORT", "DISPLAY_KEYWORD_PERFORMANCE_REPORT"), 
#   ads     = c("customer", "ad_group_ad", "ad_group", "age_range_view",
#               "campaign_audience_view, ad_group_audience_view", "group_placement_view", "bidding_strategy", "campaign_budget",
#               "call_view", "ad_schedule_view", "campaign_criterion", "campaign",
#               "campaign_shared_set", "location_view", "click_view", "display_keyword_view"))
  
reports <- read_html("https://developers.google.com/google-ads/api/docs/migration/mapping") %>% 
           html_element(css = ".responsive") %>% 
           html_table(header = TRUE)

DT::datatable(
  reports, 
  colnames = c("Тип отчёта в Google AdWords API", "Ресурс в Google Ads API"),
  options = list(pageLength = 20)
  )


## -----------------------------------------------------------------------------
#  library(RAdwords)
#  
#  # авторизация
#  adwords_auth <- doAuth()
#  
#  # составляем запрос
#  query <- statement(
#    select = c('CampaignName',
#              'Date',
#              'Clicks'),
#    report = 'CAMPAIGN_PERFORMANCE_REPORT',
#    start  = '2021-06-01',
#    end    = '2021-06-30'
#  )
#  
#  # загрузка данных
#  data1 <- getData(
#    clientCustomerId = 'xxx-xxx-xxxx',
#    statement        = query,
#    google_auth      = adwords_auth
#  )
#  

## -----------------------------------------------------------------------------
#  library(rgoogleads)
#  
#  # авторизация
#  gads_auth_configure(path = 'D:/ga_auth/app.json')
#  gads_auth(email = 'me@gmail.com')
#  
#  # загрузка данных
#  data2 <- gads_get_report(
#    resource = 'campaign',
#    fields   = c('campaign.name',
#                'segments.date',
#                'metrics.clicks'),
#    date_from         = '2021-06-01',
#    date_to           = '2021-06-30',
#    customer_id       = '676-642-7440',
#    login_customer_id = 'xxx-xxx-xxxx'
#  )

