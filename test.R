# полноценный тест
# авторизация
library(rgoogleads)
# auth --------------------------------------------------------------------
gads_auth('alsey.netpeak@gmail.com')

# set accounts ------------------------------------------------------------
# установка основного логина
gads_set_login_customer_id('1754107253')

# установка клиентского логина
gads_set_customer_id('6766427440')



# load account hierarchy --------------------------------------------------
# загрузка списка аккаунтов
accounts_main <- gads_get_account_hierarchy(manager_customer_id = '175-410-7253')



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
  login_customer_id = "1754107253",
  cl                = cl
)

multi_rep <- gads_get_report(
  date_from = as.Date('2021-06-10'),
  date_to = as.Date('2021-06-17'),
  customer_id = acs
)


myacs <- gads_get_accessible_customers()


# campaigns ---------------------------------------------------------------
mycamp <- gads_get_campaigns(customer_id = acs)
cam <- gads_get_campaigns_helper(customer_id = acs[1])


# ad groups ---------------------------------------------------------------
myadgroups <- gads_get_ad_groups(customer_id = acs)



# ads ---------------------------------------------------------------------
myads <- gads_get_ads(customer_id = acs)


# keywords ----------------------------------------------------------------
kw <- gads_get_ad_group_criterions(customer_id = acs[c(4,5)])