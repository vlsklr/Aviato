//
//  MainPresenter.swift
//  Aviato
//
//  Created by Vlad on 07.07.2021.
//

import Foundation

protocol ISearchScreenPresenter {
    func findFlyghtInfo(flyghtNumber: String)
}

class SearchScreenPresenter: ISearchScreenPresenter {
    
    let networkManager: INetworkManager = NetworkManager()
    var userID: String
    let router: ISearchScreenRouter
    weak var view: ISearchScreenViewController?
    
    init(userID: String, router: SearchScreenRouter) {
        self.userID = userID
        self.router = router
    }
    
    func findFlyghtInfo(flyghtNumber: String) {
        view?.toggleActivityIndicator()
        networkManager.loadFlyghtInfo(flyghtNumber: flyghtNumber.replacingOccurrences(of: " ", with: ""),
                                      completion: { [unowned self] result in
            switch result {
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.view?.toggleActivityIndicator()
                    self.view?.showAlert(message: RootViewController.labels!.flyghtNotFound)
                }
            case .success(let info):
                print(info)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mmZ"
                dateFormatter.timeZone = .current
                let departureDateUTC = dateFormatter.date(from:info.departure.scheduledTimeUtc)!
                let arrivalDateUTC = dateFormatter.date(from: info.arrival.scheduledTimeUtc)!
                var airCraftImageData: Data?
                let viewInfo: FlyghtInfoDataModel = FlyghtInfoDataModel(holder: self.userID,
                                                                        flyghtID: "",
                                                                        flyghtNumber: info.number,
                                                                        departureAirport: info.departure.airport.shortName,
                                                                        arrivalAirport: info.arrival.airport.shortName,
                                                                        departureDate: departureDateUTC,
                                                                        arrivalDate: arrivalDateUTC,
                                                                        aircraft: info.aircraft.model,
                                                                        airline: info.airline.name,
                                                                        status: info.status,
                                                                        departureCity: info.departure.airport.municipalityName,
                                                                        arrivalCity: info.arrival.airport.municipalityName)
                
                self.networkManager.loadAircraftImage(url: info.aircraft.image.url, completion: { result in
                    switch result {
                    case .failure(let error):
                        print(error)
                        self.view?.toggleActivityIndicator()
                        self.router.showFoundFlyght(userID: viewInfo.holder, flyght: viewInfo, aircraftImageData: nil)
                    case .success(let data):
                        airCraftImageData = data
                        self.view?.toggleActivityIndicator()
                        self.router.showFoundFlyght(userID:viewInfo.holder, flyght: viewInfo, aircraftImageData: airCraftImageData)
                    }
                })
            }
        })
    }
    
}
