//
//  FavoriteFlyghtsListPresenter.swift
//  Aviato
//
//  Created by user188734 on 7/8/21.
//

import Foundation
import UIKit

protocol IFavoriteFlyghtListPresenter {
    func getFlyghtsCount() -> Int
    func getFlyghts() -> [FlyghtViewModel]?
    func getFavorite(flyghtID: String)
    func updateFlyghtInfo()
    func removeFlyght(flyghtID: String)
}

class FavoriteFlyghtListPresenter: IFavoriteFlyghtListPresenter {
    let storageManager: IStorageManager = StorageManager()
    let networkManager = NetworkManager()
    let userID: String
    let router: FavoriteListRouter
    weak var view: FavoriteFlyghtListViewController?
    
    init(userID: String, router: FavoriteListRouter) {
        self.userID = userID
        self.router = router
    }
    
    func getFlyghtsCount() -> Int {
        return storageManager.flyghtsCount(userID: userID)
    }
    func getFlyghts() -> [FlyghtViewModel]? {
        let savedFlyghts = storageManager.getFlyghts(userID: userID)
        return savedFlyghts
    }
    
    func getFavorite(flyghtID: String) {
        guard let flyght = storageManager.getFlyght(flyghtID: flyghtID) else {
            return
        }
        if let airCraftImage = storageManager.loadImage(fileName: flyghtID) {
            router.showFavoriteFlyght(flyght: flyght, aircraftImage: airCraftImage)
            
        } else {
            FirebaseManager.loadImage(filestoragePath: "images/\(userID)/\(flyghtID).png"){ [weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                    self?.router.showFavoriteFlyght(flyght: flyght, aircraftImage: nil)
                case .success(let data):
                    guard let data = data, let image = UIImage(data: data) else {
                        return
                    }
                    self?.storageManager.saveImage(image: image, fileName: "\(flyghtID)")
                    self?.router.showFavoriteFlyght(flyght: flyght, aircraftImage: image)
                }
            }
        }
    }
    /*
     Метод обновляет информацию о рейсах сохраненных в избранное для конкретного пользователя
     1. Перебираем все ячейки
     2. В соответствии с flyghtID из ячейки ищет соответствующий рейс в CoreData
     3. Если таковой находится, то через networkManager делаем запрос к API
     4. Если данные успешно загружены, обновляем их в CoreData
     */
    func updateFlyghtInfo() {
        guard let totalSections = self.view?.tableView.numberOfSections else {return}
        var upatingCounter = 0
        self.view?.toggleActivityIndicator()
        for section in 0..<totalSections {
            guard let totalRowsInSection = self.view?.tableView.numberOfRows(inSection: section) else {return}
            for row in 0..<totalRowsInSection {
                let cell = self.view?.tableView.cellForRow(at: IndexPath(row: row, section: section)) as! FlyghtViewCell
                guard let flyghtID = cell.entityID else {return}
                let flyght = self.storageManager.getFlyght(flyghtID: flyghtID)
                // Приведение номера рейса в соответствие с требованиями API. Для запроса к API нужно писать номер рейса без пробела "KLM1116" или "KL1116", но сам API возвращает номер рейса в таком формате: "KL 1116"
                guard let flyghtNumber = flyght?.flyghtNumber.replacingOccurrences(of: " ", with: "") else {return}
                self.networkManager.loadFlyghtInfo(flyghtNumber: flyghtNumber, completion: {[weak self] result in
                    switch result {
                    case .failure(let error):
                        print(error)
                        DispatchQueue.main.async {
                            self?.view?.alertController.showAlert(message: "\(RootViewController.labels!.errorDuringUpdateFlyghtInfo) \(flyghtNumber)")
                            self?.view?.tableView.reloadData()
                            self?.view?.toggleActivityIndicator()
                        }
                    case .success(let info):
                        print(info)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mmZ"
                        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                        let departureDateUTC = dateFormatter.date(from:info.departure.scheduledTimeUtc)!
                        let arrivalDateUTC = dateFormatter.date(from: info.arrival.scheduledTimeUtc)!
                        
                        //В departureDateLocal и arrivalDateLocal ничего не подставляется, так как эти данные в CoreData не сохраняются, при обновлении tableView все равно сгенерируются при загрузке из CoreData
                        let viewInfo: FlyghtViewModel = FlyghtViewModel(holder: self!.userID, flyghtID: flyghtID, flyghtNumber: info.number, departureAirport: "\(info.departure.airport.countryCode)  \(info.departure.airport.name)", arrivalAirport: "\(info.arrival.airport.countryCode)  \(info.arrival.airport.name)", departureDate: departureDateUTC, arrivalDate: arrivalDateUTC, aircraft: info.aircraft.model, airline: info.airline.name, status: info.status, departureDateLocal: "", arrivalDateLocal: "")
                        self?.storageManager.updateFlyght(flyghtID: flyghtID, flyght: viewInfo)
                        FirebaseManager.updateFlyghtInfo(flyght: viewInfo)
                        upatingCounter += 1
                        DispatchQueue.main.async {
                            if upatingCounter == totalRowsInSection {
                                self?.view?.tableView.reloadData()
                                self?.view?.toggleActivityIndicator()
                            }
                        }
                    }
                })
            }
        }
    }
    
    func removeFlyght(flyghtID: String) {
        storageManager.removeFlyght(flyghtID: flyghtID)
        FirebaseManager.removeFlyght(flyghtID: flyghtID)
    }
}
