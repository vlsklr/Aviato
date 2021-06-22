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
                let viewInfo: FlyghtViewModel = FlyghtViewModel(holder: self!.userID, flyghtID: UUID(), flyghtNumber: info.number, departureAirport: "\(info.departure.airport.countryCode)  \(info.departure.airport.name)", arrivalAirport: "\(info.arrival.airport.countryCode)  \(info.arrival.airport.name)", departureDate: info.departure.scheduledTimeUtc, arrivalDate: info.arrival.scheduledTimeUtc, aircraft: info.aircraft.model, airline: info.airline.name)
                DispatchQueue.main.async {
                    view.showFoundFlyght(flyghtViewInfo: viewInfo)
                }
            }
        })
    }
    
    func addToFavorite(flyght: FlyghtViewModel) {
        storageManager.AddFlyght(flyght: flyght)
    }
    
    func getFlyghts() -> [FlyghtViewModel]? {
        let savedFlyghts = storageManager.getFlyghts(userID: userID)
        return savedFlyghts
    }
    
    func getFavorite(view: IFavoriteFlyghtViewController, indexPath: IndexPath) {
        guard let flyght = storageManager.getFlyghts(userID: userID) else {return}
        if indexPath.row < flyght.count {
            view.showFavoriteFlyght(flyghtViewInfo: flyght[indexPath.row])
        }
    }
    
    func removeFlyght(flyghtID: UUID) {
        storageManager.removeFlyght(flyghtID: flyghtID)
    }
}
