//
//  MainPresenter.swift
//  Aviato
//
//  Created by Vlad on 07.07.2021.
//

import Foundation

class MainPresenter: IMainPresenter {
    
    let networkManager: INetworkManager = NetworkManager()
    var userID: String
    
    init(userID: String) {
        self.userID = userID
    }
    
    func findFlyghtInfo(view: IMainViewController, flyghtNumber: String) {
        DispatchQueue.main.async {
            view.toggleActivityIndicator()
        }
        self.networkManager.loadFlyghtInfo(flyghtNumber: flyghtNumber.replacingOccurrences(of: " ", with: ""), completion: {[weak self] result in
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
                var airCraftImageData: Data?
                let viewInfo: FlyghtViewModel = FlyghtViewModel(holder: self!.userID, flyghtID: "", flyghtNumber: info.number, departureAirport: "\(info.departure.airport.countryCode)  \(info.departure.airport.name)", arrivalAirport: "\(info.arrival.airport.countryCode)  \(info.arrival.airport.name)", departureDate: departureDateUTC, arrivalDate: arrivalDateUTC, aircraft: info.aircraft.model, airline: info.airline.name, status: info.status, departureDateLocal: departureDateLocal, arrivalDateLocal: arrivalDateLocal)
                let foundFlyghtPresenter = FoundFlyghtPresenter(userID: self!.userID)
                let foundFlyghtViewController = FoundFlyghtViewController(flyghtViewInfo: viewInfo, presenter: foundFlyghtPresenter)
                self?.networkManager.loadAircraftImage(url: info.aircraft.image.url) { (imageData) in
                    print(imageData)
                    airCraftImageData = imageData
                    if let imageData = airCraftImageData {
                        foundFlyghtViewController.showImage(imageData: imageData)
                    }
                }
                DispatchQueue.main.async {
                    view.toggleActivityIndicator()
                    view.showFoundFlyght(foundFlyghtViewController: foundFlyghtViewController)
                }
            }
        })
    }
    
}
