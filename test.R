# полноценный тест
devtools::install_github('selesnow/rgoogleads')

# установка пакета
install.packages('rgoogleads')
# подключение
library(rgoogleads)

# авторизация
gads_auth_configure(path = 'D:/ga_auth/app.json')
gads_auth(email = 'alsey.netpeak@gmail.com')


gads_auth(email = 'selesnow.netpeak@gmail.com')

# опции#
# установка основного логина
gads_set_login_customer_id('1754107253')

# установка клиентского логина
gads_set_customer_id('6766427440')

# запрос статистики
group_report <- gads_get_report(
  resource    = "ad_group",
  fields = c("ad_group.campaign",
             "ad_group.id",
             "ad_group.name",
             "ad_group.status",
             "metrics.clicks",
             "metrics.cost_micros"),
  date_from   = "2021-06-02",
  date_to     = Sys.Date() - 1,
  where       = "ad_group.status = 'ENABLED'",
  order_by    = c("metrics.clicks DESC", "metrics.cost_micros"),
)

gads_user()

gads_developer_token()
gads_oauth_app()

gads_auth_configure(app = gads_default_ouath_app())
gads_auth_cache_path()
accounts <- gads_get_accessible_customers()
# set accounts ------------------------------------------------------------
# установка основного логина
gads_set_login_customer_id('1754107253')

# установка клиентского логина
gads_set_customer_id('6766427440')


# load account hierarchy --------------------------------------------------
# загрузка списка аккаунтов
accounts_main <- gads_get_account_hierarchy(manager_customer_id = '175-410-7253')
client_acs <-  accounts_main$customer_client_id[accounts_main$customer_client_manager == FALSE]
# load reports ------------------------------------------------------------
# загрузка статистики
# с дефорлтными параметрами по кампаниям
camp_stat <- gads_get_report()

# меняю параметры, например даты и аккаунт
camp_stat_2 <- gads_get_report(
  date_from = as.Date('2021-06-10'),
  date_to = as.Date('2021-06-17'),
  customer_id = '473-251-9773'
)

# меняем ресурс и поля
gads_set_customer_id('4732519773')
adstat <- gads_get_report(
  customer_id = 4732519773,
  resource = 'ad_group_ad',
  fields = c("ad_group_ad.ad.id", "ad_group_ad.ad.name", "ad_group_ad.status", "metrics.clicks"),
  date_from = '2021-06-10',
  date_to = '2021-06-17'
  )

# теперь запрашиваем по группе объявлений
group_report <- gads_get_report(
  customer_id = 4732519773,
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
  order_by    = c("metrics.clicks DESC", "metrics.cost_micros"),
  limit       = 30000
)

# загрузка данных сразу из 4ёх аккаунтов
acs <- c(	1507592784, 8183215956, 6983359454, 9382181697, 5720644438, 7708567525, 7701918735, 9936483356 )

multi_rep <- gads_get_report(
  customer_id = acs,
  resource = 'ad_group_ad',
  fields = c("ad_group_ad.ad.id", "ad_group_ad.ad.name", "ad_group_ad.status", "metrics.clicks"),
  date_from = '2021-06-10',
  date_to = '2021-06-17'
)

# camp report multi acc
multi_rep <- gads_get_report(
  date_from = as.Date('2021-06-10'),
  date_to = as.Date('2021-06-17'),
  customer_id = acs
)

# with verbose
options(gads.multi.account.verbos = TRUE)
multi_rep <- gads_get_report(
  date_from = as.Date('2021-06-10'),
  date_to = as.Date('2021-06-17'),
  customer_id = acs
)

# parallel load
library(pbapply)
library(parallel)

options(gads.multi.account.verbos = FALSE)
cl <- makeCluster(4)

gads_set_customer_id(acs)

multi_rep <- gads_get_report(
  date_from         = as.Date('2021-06-10'),
  date_to           = as.Date('2021-06-17'),
  customer_id       = acs,
  #login_customer_id = "1754107253",
  cl                = cl
)

multi_rep <- gads_get_report(
  customer_id = acs,
  resource    = 'ad_group_ad',
  fields      = c("ad_group_ad.ad.id", "ad_group_ad.ad.name", "ad_group_ad.status", "metrics.clicks"),
  date_from   = '2021-06-10',
  date_to     = '2021-06-17',
  login_customer_id = "1754107253",
  cl         = cl
)


group_report_multi <- gads_get_report(
  customer_id = acs,
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
  order_by    = c("metrics.clicks DESC", "metrics.cost_micros"),
  limit       = 3000,
  login_customer_id = "1754107253",
  cl         = cl
)


multi_rep <- gads_get_report(
  date_from = as.Date('2021-06-10'),
  date_to = as.Date('2021-06-17'),
  customer_id = acs
)


myacs <- gads_get_accessible_customers()


# campaigns ---------------------------------------------------------------
mycamp <- gads_get_campaigns(customer_id = acs)
cam <- gads_get_campaigns(
  customer_id = acs[3],
  where = "campaign.status = 'ENABLED'")


# ad groups ---------------------------------------------------------------
myadgroups <- gads_get_ad_groups(customer_id = acs[1], where = 'ad_group.status = "ENABLED"')



# ads ---------------------------------------------------------------------
myads <- gads_get_ads(
  customer_id = acs[6],
  fields = c("ad_group_ad.ad.id",
             "customer.descriptive_name",
             "ad_group_ad.ad.call_ad.description1",
             "ad_group_ad.ad.call_ad.description2"),
  where = 'ad_group_ad.status = "ENABLED"')


# keywords ----------------------------------------------------------------
kw <- gads_get_ad_group_criterions(customer_id = acs[c(4,5)])



# simple client account ---------------------------------------------------
library(rgoogleads)

# set your app from google console
gads_auth_configure(path = 'D:/ga_auth/testapp.json')

# set email and developer token
gads_auth(email = 'selesnow@gmail.com')

# get your top level accounts
accounts <- gads_get_accessible_customers()

# get statistic
multi_rep <- gads_get_report(
  date_from = as.Date('2020-01-01'),
  date_to = as.Date('2021-06-30'),
  customer_id = '471-277-1282',
  login_customer_id = '471-277-1282'
)


gads_auth(email = 'r.for.marketing@gmail.com')


# инфа по ресурсам --------------------------------------------------------
res_info <- gads_get_fields(object_name = 'campaign')
mtr_info <- gads_get_fields('metrics.clicks')
seg_info <- gads_get_fields('segments.day_of_week')

resources <- gads_get_metadata('RESOURCE', fields = c("name", "category", "data_type"))
metadata  <- gads_get_metadata('ALL')

gads_unlist <- function(col) {
  if_else(is.null(col), list(col), list(unlist(col)))
}

resources %>%


resources[5,]$metrics %>% unlist


gads_set_customer_id()
gads_set_login_customer_id()

gads_get_campaigns()
gads_get_ad_groups()
gads_get_ads()
gads_get_ad_group_criterions()


library(rgoogleads)

# авторизация
gads_auth_configure(path = 'D:/ga_auth/app.json')
gads_auth(path = 'C:/ga_auth/gads_sk.json')
accounts <- gads_get_accessible_customers()
gads_developer_token()

geo_dict <- gads_get_geo_targets()



# план клюевых слов -------------------------------------------------------
gads_set_customer_id('676-642-7440')
gads_set_login_customer_id('175-410-7253')
gads_set_customer_id('100-245-7292')

plan_data <- gads_get_report(
  resource = 'keyword_plan_campaign_keyword',
  fields = c('keyword_plan_campaign_keyword.id',
             'keyword_plan_campaign_keyword.keyword_plan_campaign',
             'keyword_plan_campaign_keyword.match_type',
             'keyword_plan_campaign_keyword.negative',
             'keyword_plan_campaign_keyword.resource_name',
             'keyword_plan_campaign_keyword.text',
             'customer.id',
             'customer.descriptive_name',
             'keyword_plan.forecast_period',
             'keyword_plan.id',
             'keyword_plan.name',
             'keyword_plan.resource_name',
             'keyword_plan_campaign.cpc_bid_micros',
             'keyword_plan_campaign.geo_targets',
             #'keyword_plan_campaign.geo_targets.geo_target_constant',
             'keyword_plan_campaign.id',
             'keyword_plan_campaign.keyword_plan',
             'keyword_plan_campaign.keyword_plan_network',
             'keyword_plan_campaign.language_constants',
             'keyword_plan_campaign.name',
             'keyword_plan_campaign.resource_name'),
  date_from = NULL,
  date_to = NULL
)



plan_data <- gads_get_report(
  resource = 'keyword_plan',
  fields = c('keyword_plan.id')
)


plan_data$keyword_plan_campaign_geo_targets_1


plan_data <- gads_get_report(
  resource = 'keyword_plan_campaign_keyword',
  fields = c('keyword_plan_campaign_keyword.id',
             'keyword_plan_campaign_keyword.keyword_plan_campaign',
             'keyword_plan_campaign_keyword.match_type',
             'keyword_plan_campaign_keyword.negative',
             'keyword_plan_campaign_keyword.resource_name',
             'keyword_plan_campaign_keyword.text',
             'customer.id',
             'customer.descriptive_name',
             'keyword_plan.forecast_period',
             'keyword_plan.id',
             'keyword_plan.name',
             'keyword_plan.resource_name',
             'keyword_plan_campaign.cpc_bid_micros',
             'keyword_plan_campaign.geo_targets',
             'keyword_plan_campaign.id',
             'keyword_plan_campaign.keyword_plan',
             'keyword_plan_campaign.keyword_plan_network',
             'keyword_plan_campaign.language_constants',
             'keyword_plan_campaign.name',
             'keyword_plan_campaign.resource_name'),
  date_from = NULL,
  date_to = NULL
)


ans <- POST(url = 'https://googleads.googleapis.com/v8/customers/1002457292/keywordPlans/313874210:generateForecastMetrics',
            add_headers(
              Authorization       = str_glue("Bearer {gads_token()$auth_token$credentials$access_token}"),
              `developer-token`   = gads_developer_token(),
              `login-customer-id` = login_customer_id
            ))

res <- httr::content(ans)

res %>%
  tibble()


res$campaignForecasts[[1]]$campaignForecast$impressions




ans <- POST(url = 'https://googleads.googleapis.com/v8/customers/1002457292/keywordPlans/313874210:generateHistoricalMetrics',
            add_headers(
              Authorization       = str_glue("Bearer {gads_token()$auth_token$credentials$access_token}"),
              `developer-token`   = gads_developer_token(),
              `login-customer-id` = login_customer_id
            ))

res <- httr::content(ans)

map_df(res$metrics, function(x) tibble(
  search_query         = x$searchQuery,
  competition          = if_else( is.null(x$keywordMetrics$competition), NA_character_, x$keywordMetrics$competition),
  avg_monthly_searches = if_else( is.null(x$keywordMetrics$avgMonthlySearches), NA_character_, x$keywordMetrics$avgMonthlySearches),
  competition_index    = if_else( is.null(x$keywordMetrics$competitionIndex), NA_character_, x$keywordMetrics$competitionIndex),
  low_top_of_page_bid  = if_else( is.null(x$keywordMetrics$lowTopOfPageBidMicros), NA_character_, x$keywordMetrics$lowTopOfPageBidMicros),
  high_top_of_page_bid = if_else( is.null(x$keywordMetrics$highTopOfPageBidMicros), NA_character_, x$keywordMetrics$highTopOfPageBidMicros)
)
) %>%
  mutate(
    low_top_of_page_bid = round(as.integer(low_top_of_page_bid) / 1000000, 2),
    high_top_of_page_bid = round(as.integer(high_top_of_page_bid) / 1000000, 2)
  )




lapply(res$metrics, function(x) tibble(
  search_query = x$searchQuery,
  competition  = x$keywordMetrics$competition,
  avg_monthly_searches = x$keywordMetrics$avgMonthlySearches
))

res$metrics[[3]]$

library(rgoogleads)

gads_auth('ваш_имейл@gmail.com')

# идентификатор управляющего аккаунта (если под управляющим работаете)
gads_set_login_customer_id('175-410-7253')
# идентификатор рекламного аккаунта
gads_set_customer_id('100-245-7292')

# запрашиваем список созданных планов ключевиков
plan_data <- gads_get_report(
  resource = 'keyword_plan',
  fields = c('keyword_plan.id')
)

# запрашиваем детальные данные плана
historical_plan_data <- gads_keyword_plan_historical_metrics(
  keyword_plan_id = plan_data$keywordPLANid[1]
)

# разделям данные на две таблицы
data <- historical_plan_data$main_data
historical_data <- historical_plan_data$historical_data


pl2 <- gads_keyword_plan_forecast_timeseries(pid)
pl3 <- gads_keyword_plan_forecast_metrics(pid)
