# полноценный тест
devtools::install_github('selesnow/rgoogleads')

# установка пакета
install.packages('rgoogleads')
# подключение
library(rgoogleads)

# авторизация
gads_auth_configure(
  path = 'D:/ga_auth/app.json',
  developer_token = 'ваш токен разработчика'
)


gads_auth(email = 'alsey.netpeak@gmail.com', cache = F)

gads_auth(email = 'a.seleznev@netpeak.group' )



gads_auth(email = 'selesnow.netpeak@gmail.com')
pt <- gads_auth_cache_path()
# опции#
# установка основного логина
gads_set_login_customer_id('1754107253')

# установка клиентского логина
gads_set_customer_id('4660700907')

# запрос статистики
group_report <- gads_get_report(
  resource    = "ad_group",
  fields = c("ad_group.campaign",
             "ad_group.id",
             "ad_group.name",
             "ad_group.status",
             "metrics.clicks",
             "metrics.cost_micros"),#during = 'LAST_30_DAYS',
  date_from   = "2021-06-02",
  date_to     = Sys.Date() - 1,
  where       = "ad_group.status = 'ENABLED'",
  order_by    = c("metrics.clicks DESC", "metrics.cost_micros"),
)


GAds_Data <- gads_get_report(
  resource =   "campaign",
  fields   = c("segments.week",
               "campaign.name",
               "metrics.conversions_by_conversion_date"),
  during = "THIS_MONTH")

GAds_Data3 <- gads_get_report(
  resource =   "ad_group_criterion",
  fields   = c("ad_group_criterion.criterion_id",
               "ad_group_criterion.custom_affinity.custom_affinity",
               "ad_group_criterion.custom_audience.custom_audience")
  )




GAds_DataLab <- gads_get_report(
  resource =   "label",
  fields   = c('label.name', 'label.id'),
  date_from   = "2021-02-22",
  date_to     = "2021-04-04")

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
gads_set_customer_id('3449310772')


# load account hierarchy --------------------------------------------------
# загрузка списка аккаунтов
accounts_main <- gads_get_account_hierarchy()
client_acs <-  accounts_main$customer_client_id[accounts_main$customer_client_manager == FALSE]
# load reports ------------------------------------------------------------
# загрузка статистики
# с дефорлтными параметрами по кампаниям
camp_stat <- gads_get_report()

# меняю параметры, например даты и аккаунт
camp_stat_2 <- gads_get_report(
  date_from = as.Date('2021-06-10'),
  date_to = as.Date('2021-06-17'),
  customer_id = '7907111282'
)

# меняем ресурс и поля
gads_set_customer_id('4732519773')
adstat <- gads_get_report(
  customer_id = 7907111282,
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
acs <- c(	1507592784, 8183215956, 6983359454, 7907111282, 5720644438, 7708567525, 7701918735, 9936483356 )

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

stopCluster(cl)

multi_rep <- gads_get_report(
  customer_id = acs[3:10],
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
  customer_id = sample(client_acs, 70),
  where = "campaign.status = 'ENABLED'")


# ad groups ---------------------------------------------------------------
myadgroups <- gads_get_ad_groups(customer_id = acs[1], where = 'ad_group.status = "ENABLED"')



# ads ---------------------------------------------------------------------
myads <- gads_get_ads(
  customer_id = acs[1],
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

camps <- gads_get_campaigns()
adgr <- gads_get_ad_groups(customer_id = 1507592784)
gads <- gads_get_ads(customer_id = 1507592784)
cri <- gads_get_ad_group_criterions(customer_id = 1507592784)


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


campaings <- gads_

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







gapp <- httr::oauth_app('gapp', '321452169616-30etfc54n8is879a5b8tom800llsbuq7.apps.googleusercontent.com', 'aAu6O0XN9tzOYPS27c8h_q-Z')
gads_auth_configure(gapp, developer_token = '3gTgJr6Xi3Uqdt-hiDNaIg')
retry::retry(gads_auth(email = 'alsey.netpeak@gmail.com'), when = "Can't get Google credentials", interval = 60, max_tries = 5)




# ???????? ?????????
top_accounts <- gads_get_accessible_customers() %>%
  filter(manager == TRUE)

hierarchy <- map_df(top_accounts$id, ~ gads_get_account_hierarchy(manager_customer_id = .x, login_customer_id = .x))
