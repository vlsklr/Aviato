# Aviato

Aviato - приложение для iOS для поиска полезной информации об авиарейсах. Позволяет при помощи номера рейса узнать всякое полезное. Реализованы следующие возможности:

* Регистрация/авторизация по связке email/password
* Поиск полезной информации о рейсе по его номеру
* Возможность сохранить найденные рейсы в Избранное
* Возможность обновить информацию обо всех рейсах в Избранном
* Просмотр/редактирование/удаление аккаунта пользователя
* Адаптирована для использования темной системной темы
* Поддержка русского и английского языка

___

## Применяемый стек технологий:
### Архитектура: MVP дополненная роутерами и сборщиками
### API для получения информации о рейсах: Aerodatabox
### Управление зависимостями: CocoaPods  
### Работа с сетью при загрузке информации о рейсах:  
* Загрузка информации о рейсе - самописная на URLSession
* Загрузка изображения самолета - Alamofire
### Хранение:
* Локально данные хранятся в CoreData, изображения в файловой системе
* Хранение пользовательской сессии - UID активного пользователя хранится в KeyChain
### Для хэширования паролей используется библиотека CryptoSwift
### Верстка: UIKit + SnapKit
### Синхронизация с облаком:
* Для авторизации пользователей используется Firebase Authentication
* Для хранения профилей пользователей и их избранных полетов используется Firebase Firestore Database
* Для хранения изображений профиля пользователя и фотографий самолетов для избранных рейсов используется Firebase Storage.
* Для локализации приложения используется Firestore Database. Там хранятся тексты для всех Labels для английской и русской версии.

## Демонстрация
### Регистрация  
![IMG_7370](https://user-images.githubusercontent.com/42057101/141930702-b762e26c-fe73-4854-b2ac-0984c711ccb1.gif)
### Авторизация  
![IMG_7371](https://user-images.githubusercontent.com/42057101/141930785-007b4985-839c-4958-bad2-39aab4734a98.gif)
### Поиск рейса и сохранение рейса  
![IMG_7372](https://user-images.githubusercontent.com/42057101/141930874-9f0ec9d5-fdd9-442e-8d3b-daefb1048d1a.gif)
### Просмотр и обновление рейсов, сохраненных в избранное  
![IMG_7373](https://user-images.githubusercontent.com/42057101/141931724-64644acd-449d-4778-8d3f-3dedc7444990.gif)
### Редактирование профиля пользователя
![IMG_7374](https://user-images.githubusercontent.com/42057101/141932281-0ec5310d-0f3a-4105-8d20-af0ad88e92b8.gif)
### Логаут/Логин/Удаление профиля пользователя
![IMG_7378](https://user-images.githubusercontent.com/42057101/141932469-2da4a6a7-2a6c-4e3a-877a-b113fea3bc72.gif)



