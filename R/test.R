# # полноценный тест
# # авторизация
# gads_auth('alsey.netpeak@gmail.com')
#
# # загрузка списка аккаунтов
# accounts_main <- gads_get_account_hierarchy(manager_customer_id = '175-410-7253')
#
# # установка основного логина
# gads_set_login_customer_id('175-410-7253')
#
# # установка клиентского логина
# gads_set_customer_id('6766427440')
#
# # загрузка статистики
# # с дефорлтными параметрами по кампаниям
# camp_stat <- gads_get_report()
#
# # меняю параметры, например даты и аккаунт
# camp_stat_2 <- gads_get_report(
#   date_from = as.Date('2021-06-10'),
#   date_to = as.Date('2021-06-17'),
#   customer_id = '473-251-9773'
# )
#
# # меняем ресурс и поля
# gads_set_customer_id('4732519773')
# adstat <- gads_get_report(
#   customer_id = 4732519773,
#   resource = 'ad_group_ad',
#   fields = c("ad_group_ad.ad.id", "ad_group_ad.ad.name", "ad_group_ad.status", "metrics.clicks"),
#   date_from = '2021-06-10',
#   date_to = '2021-06-17'
#   )
#
# # теперь запрашиваем по группе объявлений
# group_report <- gads_get_report(
#   customer_id = 4732519773,
#   resource = 'ad_group',
#   fields = c("ad_group.campaign", "ad_group.id", "ad_group.name", "ad_group.status", "metrics.clicks", "metrics.cost_micros"),
#   date_from = '2021-06-10',
#   date_to = '2021-06-17',
#   where = 'ad_group.status = "ENABLED"',
#   limit = 30000
# )
#
# # загрузка данных сразу из 4ёх аккаунтов
# acs <- c(	1507592784, 8183215956, 6983359454, 9382181697 )
#
# multi_rep <- gads_get_report(
#   customer_id = acs,
#   resource = 'ad_group_ad',
#   fields = c("ad_group_ad.ad.id", "ad_group_ad.ad.name", "ad_group_ad.status", "metrics.clicks"),
#   date_from = '2021-06-10',
#   date_to = '2021-06-17'
# )
#
# multi_rep <- gads_get_report(
#   date_from = as.Date('2021-06-10'),
#   date_to = as.Date('2021-06-17'),
#   customer_id = acs
# )
#
#
#
# multi_rep <- gads_get_report(
#   date_from = as.Date('2021-06-10'),
#   date_to = as.Date('2021-06-17'),
#   customer_id = acs
# )
