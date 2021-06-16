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
    
    func authentificateUser(username: String, password: String) {
        let user = storageManager.loadUser(username: username)
        if user?.username == username && user?.password == password && user?.userID != nil {
            print("logged in")
            self.userID = user!.userID
            AppDelegate.shared.rootViewController.switchToMainScreen()
        }
    }
    
    func registerUser(username: String, password: String) {
        let user = UserViewModel(userID: userID, username: username, password: password)
        storageManager.addUser(user: user) {
            AppDelegate.shared.rootViewController.switchToMainScreen()
        }
    }
    
    func findFlyghtInfo(view: IFoundFlyghtViewController, flyghtNumber: String) {
       // заглушка
        var info: FlyghtInfo = FlyghtInfo(codeshareStatus: "status", number: "KL0422", status: "Arrived", arrival: Arrival(scheduledTimeUtc: "TIME", airport: Airport(name: "Tolmachevo", countryCode: "RU")), departure: Departure(scheduledTimeUtc: "TIME1", airport: Airport(name: "Pulkovo", countryCode: "RU")), aircraft: Aircraft(model: "Boeing 737-NG"), airline: Airline(name: "Ы7"))
        
        
        var viewInfo: FlyghtViewModel = FlyghtViewModel(holder: self.userID, flyghtID: UUID(), flyghtNumber: info.number, departureAirport: "\(info.departure.airport.countryCode)  \(info.departure.airport.name)", arrivalAirport: "\(info.arrival.airport.countryCode)  \(info.arrival.airport.name)", departureDate: info.departure.scheduledTimeUtc, arrivalDate: info.arrival.scheduledTimeUtc, aircraft: info.aircraft.model, airline: info.airline.name)
        
        view.showFoundFlyght(flyghtViewInfo: viewInfo)
        
        
//        let foundFlyghtView: IFoundFlyghtViewController = FoundFlyghtViewController(flyghtViewInfo: viewInfo)
//        foundFlyghtView.showFoundFlyght(flyghtViewInfo: viewInfo)
        print(viewInfo)
//            info = self.networkManager.loadFlyghtInfo(flyghtNumber: flyghtNumber)


    
    }
    
    func addToFavorite(flyght: FlyghtViewModel) {
        storageManager.AddFlyght(flyght: flyght)
        
    }
    
    func getFlyghts() -> [FlyghtViewModel]? {
        let savedFlyghts = storageManager.getFlyghts(userID: userID)
        return savedFlyghts
    }
    
    func getFavorite(view: IFavoriteFlyghtViewController, indexPath: IndexPath) {
        let fl = storageManager.getFlyghts(userID: userID)
        view.showFavoriteFlyght(flyghtViewInfo: fl![indexPath.row])
    }
    
    func removeFlyght(flyghtID: UUID, completion: @escaping () -> Void) {
        storageManager.removeFlyght(flyghtID: flyghtID)
        DispatchQueue.main.async {
            completion()
        }
    }
    
}
