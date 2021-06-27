//
//  Presenter.swift
//  Aviato
//
//  Created by Vlad on 16.06.2021.
//
import Foundation


class Presenter: IPresenter {
    private let storageManager: IStorageManager = StorageManager()
    private let networkManager: INetworkManager = NetworkManager()
    private var userID: UUID = UUID()
    
    func authentificateUser(view: IAlert,username: String, password: String) {
        if username.isEmpty || password.isEmpty {
            view.showAlert(message: "Введите данные")
        }else {
            let user = storageManager.loadUser(username: username)
            if user?.username == username && user?.password == password && user?.userID != nil {
                self.userID = user!.userID
                AppDelegate.shared.rootViewController.switchToMainScreen()
            }
            else {
                view.showAlert(message: "Данные неверны или такого пользователя не существует")
            }
        }
    }
    
    func registerUser(view: IAlert, username: String, password: String) {
        if username.isEmpty || password.isEmpty {
            view.showAlert(message: "Введите данные")
        } else if let user = storageManager.loadUser(username: username) {
            view.showAlert(message: "Пользователь \(user.username) уже существует")
        }
        else {
            let user = UserViewModel(userID: userID, username: username, password: password)
            storageManager.addUser(user: user) {
                AppDelegate.shared.rootViewController.switchToMainScreen()
            }
        }
    }
    
    func logout() {
        AppDelegate.shared.rootViewController.showLoginScreen()
    }
    
    func findFlyghtInfo(view: IFoundFlyghtViewController, flyghtNumber: String) {
        self.networkManager.loadFlyghtInfo(flyghtNumber: flyghtNumber, completion: {[weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    view.showAlert(message: "Информация о данном рейсе отсутствует" )
                }
            case .success(let info):
                print(info)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mmZ"
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                let departureDateUTC = dateFormatter.date(from:info.departure.scheduledTimeUtc)!
                let arrivalDateUTC = dateFormatter.date(from: info.arrival.scheduledTimeUtc)!
                
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                dateFormatter.timeZone = TimeZone.current
                let departureDateLocal = dateFormatter.string(from: departureDateUTC)
                let arrivalDateLocal  = dateFormatter.string(from: arrivalDateUTC)
                
                let viewInfo: FlyghtViewModel = FlyghtViewModel(holder: self!.userID, flyghtID: UUID(), flyghtNumber: flyghtNumber, departureAirport: "\(info.departure.airport.countryCode)  \(info.departure.airport.name)", arrivalAirport: "\(info.arrival.airport.countryCode)  \(info.arrival.airport.name)", departureDate: departureDateUTC, arrivalDate: arrivalDateUTC, aircraft: info.aircraft.model, airline: info.airline.name, departureDateLocal: departureDateLocal, arrivalDateLocal: arrivalDateLocal)
                DispatchQueue.main.async {
                    view.showFoundFlyght(flyghtViewInfo: viewInfo)
                }
            }
        })
    }
    
    func addToFavorite(view: IAlert, flyght: FlyghtViewModel) -> Bool {
        if storageManager.contains(userID: userID, flyghtNumber: flyght.flyghtNumber){
            view.showAlert(message: "Данный рейс уже сохранен в избранном")
            return false
        }else{
            storageManager.addFlyght(flyght: flyght)
            return true
        }
    }
    
    func getFlyghts() -> [FlyghtViewModel]? {
        let savedFlyghts = storageManager.getFlyghts(userID: userID)
        return savedFlyghts
    }
    
    func getFavorite(view: IFavoriteFlyghtViewController, flyghtID: UUID) {
        guard let flyght = storageManager.getFlyght(flyghtID: flyghtID) else {
            return
        }
        view.showFavoriteFlyght(flyghtViewInfo: flyght)
    }
    
    func removeFlyght(flyghtID: UUID) {
        storageManager.removeFlyght(flyghtID: flyghtID)
    }
}
