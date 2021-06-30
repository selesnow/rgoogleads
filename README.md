
# rgoogleads: R пакет для работы с Google Ads API <a href='https://selesnow.github.io/rgoogleads'><img src='man/figures/rgoogleads.png' align="right" height="138.5" /></a>

<!-- badges: start -->
<!-- badges: end -->

Пакет `rgoogleads` предназначен для работы с [Google Ads API v8](https://developers.google.com/google-ads/api/docs/start) на языке R.

## Установка

На данный момент пакет доступен для установки только из [GitHub](https://github.com), используйте команду:
```r
devtools::install_github('selesnow/rgoogleads')
```

В ближайшее время пакет будет доступен для скачивания с CRAN.

## Что вам необходимо для начала работы

* Токен разработчика (Developer token), в пакете есть вшитый токен разработчика который вы можете использовать, но при большом колличестве пользователей пакета, вы можете столкнуться с лимитами, подать заявку на получение токена разработчика можно в интерфейсе центра клиентов Google Ads (Инструменты -> Центр API)

<img src='man/figures/developtoken1.png' align="centr" />
<img src='man/figures/developtoken2.png' align="centr" />

* Проект в Google Cloud с созданными учётными данными и включённым Google Ads API. 
    <Br>
    
    * Для создания проекта перейдите в [Google Cloud Console](https://console.cloud.google.com/home/) и нажмите на меню выбора проекта, далее жмите create project.
    
    <Br>
    
    <img src='man/figures/createproj.png' align="centre" />
    
    <Br>
    
    * Далее в основном меню перейдите в раздел APIs & Services > Oauth consent screen.
    
    <Br>
    
    <img src='man/figures/createscreen.png' align="centre" />
    
    <Br>
    
    * Заполните все необхоимые поля, и перейдите в меню Credentials > Create credentials > OAuth client ID
    
    <Br>
    
    <img src='man/figures/createapp.png' align="centre" />
    
    <Br>
    
    * Из выпадающего меню выбираем Desktop app, вводим название приложение и жмём create
    
    <Br>
        
    <img src='man/figures/createapp2.png' align="centre" />
    
    * На этом настройка приложения закончена жмём ОК
    
    <img src='man/figures/createapp3.png' align="centre" />
    
    * Теперь, для удобства созданное приложение можно сохранить на ПК, название файла при сохранении может быть произвольным, допустим что мы сохранили его с именем app.json по ардесу C:/auth.
    
    <img src='man/figures/createapp4.png' align="centre" />
    
    
## Пример использования пакета

This is a basic example which shows you how to solve a common problem:

``` r
library(rgoogleads)

# auth
# установка созданнового вами приложения
gads_auth_configure(path = 'C:/auth/app.json')
# логин и токен разработчика
# если у вас нет токена разработчика можете его не указывать
gads_auth(email = 'ваша.почта@gmail.com', developer_token = "токен разработчика")

# Получить список доступных аккаунтов верхнего уровня
# под авторизованным логином
my_accounts <- gads_get_accessible_customers()

# Установка MCC для работы с агентским аккаунтом
# При работе с обычным аккаунтом этот пункт можно упустить
gads_set_login_customer_id('xxx-xxx-xxxx')

# Установка клиенткого аккаунта
gads_set_customer_id('xxx-xxx-xxxx')

# Загрузка отчёта
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

## Детальная информация
Для получения подробной справки на данный момент смотрите справку к функции `?gads_get_report`.

### Автор пакета
Алексей Селезнёв, Head of analytics dept. at [Netpeak](https://netpeak.net)
<Br>Telegram Channel: R4marketing
<Br>email: selesnow@gmail.com
<Br>facebook: [facebook.com/selesnow](https://www.facebook.com/selesnow)
<Br>blog: [alexeyseleznev.wordpress.com](https://alexeyseleznev.wordpress.com/)
