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
    func getFavorite(view: IFavoriteListFlyghtViewController, flyghtID: String)
    func updateFlyghtInfo(view: FavoriteFlyghtListViewController)
    func removeFlyght(flyghtID: String)
}

class FavoriteFlyghtListPresenter: IFavoriteFlyghtListPresenter {
    let storageManager: IStorageManager = StorageManager()
    let networkManager = NetworkManager()
    let userID: String
    
    
    init(userID: String) {
        self.userID = userID
    }
    
    
    func getFlyghtsCount() -> Int {
        return storageManager.flyghtsCount(userID: userID)
        
    }
    func getFlyghts() -> [FlyghtViewModel]? {
        let savedFlyghts = storageManager.getFlyghts(userID: userID)
        return savedFlyghts
    }
    
    func getFavorite(view: IFavoriteListFlyghtViewController, flyghtID: String) {
        guard let flyght = storageManager.getFlyght(flyghtID: flyghtID) else {
            return
        }
        if let path = flyght.aircraftImage, let airCraftImage = storageManager.loadImage(path: path) {
            let favoiteViewController = FavoriteViewController(flyghtViewInfo: flyght, aircraftImage: airCraftImage)
            view.showFavoriteFlyght(flyghtViewController: favoiteViewController)
        } else {
            let favoiteViewController = FavoriteViewController(flyghtViewInfo: flyght)
            view.showFavoriteFlyght(flyghtViewController: favoiteViewController)
        }
    }
    /*
     Метод обновляет информацию о рейсах сохраненных в избранное для конкретного пользователя
     1. Перебираем все ячейки
     2. В соответствии с flyghtID из ячейки ищет соответствующий рейс в CoreData
     3. Если таковой находится, то через networkManager делаем запрос к API
     4. Если данные успешно загружены, обновляем их в CoreData
     */
    func updateFlyghtInfo(view: FavoriteFlyghtListViewController) {
        DispatchQueue.main.async {
            let totalSections = view.tableView.numberOfSections
            var upatingCounter = 0
            view.toggleActivityIndicator()
            for section in 0..<totalSections {
                let totalRowsInSection = view.tableView.numberOfRows(inSection: section)
                for row in 0..<totalRowsInSection {
                    let cell = view.tableView.cellForRow(at: IndexPath(row: row, section: section)) as! FlyghtViewCell
                    guard let flyghtID = cell.entityID else {return}
                    let flyght = self.storageManager.getFlyght(flyghtID: flyghtID)
                    // Приведение номера рейса в соответствие с требованиями API. Для запроса к API нужно писать номер рейса без пробела "KLM1116" или "KL1116", но сам API возвращает номер рейса в таком формате: "KL 1116"
                    guard let flyghtNumber = flyght?.flyghtNumber.replacingOccurrences(of: " ", with: "") else {return}
                    self.networkManager.loadFlyghtInfo(flyghtNumber: flyghtNumber, completion: {[weak self] result in
                        switch result {
                        case .failure(let error):
                            print(error)
                            DispatchQueue.main.async {
                                view.showAlert(message: "Во время обновления информации о рейсе \(flyghtNumber) что-то пошло не так")
                                view.toggleActivityIndicator()
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
                            upatingCounter += 1
                            DispatchQueue.main.async {
                                if upatingCounter == totalRowsInSection {
                                    view.tableView.reloadData()
                                    view.toggleActivityIndicator()
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
    func removeFlyght(flyghtID: String) {
        storageManager.removeFlyght(flyghtID: flyghtID)
    }
    
}
