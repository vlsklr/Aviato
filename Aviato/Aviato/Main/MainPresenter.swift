//
//  MainPresenter.swift
//  Aviato
//
//  Created by Vlad on 07.07.2021.
//

import Foundation

class MainPresenter: IMainPresenter {
    
    let networkManager: INetworkManager = NetworkManager()
    var userID: UUID
    
    init(userID: UUID) {
        self.userID = userID
    }
    
    func findFlyghtInfo(view: IMainViewController, flyghtNumber: String) {
        DispatchQueue.main.async {
            view.toggleActivityIndicator()
        }
        self.networkManager.loadFlyghtInfo(flyghtNumber: flyghtNumber, completion: {[weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    view.toggleActivityIndicator()
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
                
                let viewInfo: FlyghtViewModel = FlyghtViewModel(holder: self!.userID, flyghtID: UUID(), flyghtNumber: info.number, departureAirport: "\(info.departure.airport.countryCode)  \(info.departure.airport.name)", arrivalAirport: "\(info.arrival.airport.countryCode)  \(info.arrival.airport.name)", departureDate: departureDateUTC, arrivalDate: arrivalDateUTC, aircraft: info.aircraft.model, airline: info.airline.name, status: info.status, departureDateLocal: departureDateLocal, arrivalDateLocal: arrivalDateLocal)
                let foundFlyghtPresenter = FoundFlyghtPresenter(userID: self!.userID)
                let foundFlyghtViewController = FoundFlyghtViewController(flyghtViewInfo: viewInfo, presenter: foundFlyghtPresenter)
                
                DispatchQueue.main.async {
                    view.toggleActivityIndicator()
                    view.showFoundFlyght(foundFlyghtViewController: foundFlyghtViewController)
                }
            }
        })
    }
    
}