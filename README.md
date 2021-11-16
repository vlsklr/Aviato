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



https://user-images.githubusercontent.com/42057101/141928342-67a50ba8-fe9d-4383-8cc1-2bd6c4b44d66.MP4


