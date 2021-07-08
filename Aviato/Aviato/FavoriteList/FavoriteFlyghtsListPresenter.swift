//
//  FavoriteFlyghtsListPresenter.swift
//  Aviato
//
//  Created by user188734 on 7/8/21.
//

import Foundation

protocol IFavoriteFlyghtListPresenter {
    func getFlyghtsCount() -> Int
    func getFlyghts() -> [FlyghtViewModel]?
    func getFavorite(view: IFavoriteFlyghtViewController, flyghtID: UUID)
    func updateFlyghtInfo(view: FavoriteFlyghtListViewController)
    func removeFlyght(flyghtID: UUID)
}

class FavoriteFlyghtListPresenter: IFavoriteFlyghtListPresenter {
    let storageManager: IStorageManager = StorageManager()
    let networkManager = NetworkManager()
    let userID: UUID
    
    
    init(userID: UUID) {
        self.userID = userID
    }
    
    
    func getFlyghtsCount() -> Int {
        return storageManager.flyghtsCount(userID: userID)
        
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
    /*
     Метод обновляет информацию о рейсах сохраненных в избранное для конкретного пользователя
     1. Перебираем все ячейки
     2. В соответствии с flyghtID из ячейки ищет соответствующий рейс в CoreData
     3. Если таковой находится, то через networkManager делаем запрос к API
     4. Если данные успешно загружены, обновляем их в CoreData
     */
    func updateFlyghtInfo(view: FavoriteFlyghtListViewController) {
        let totalSections = view.tableView.numberOfSections
        var upatingCounter = 0
        view.toggleActivityIndicator()
        for section in 0..<totalSections {
            let totalRowsInSection = view.tableView.numberOfRows(inSection: section)
            for row in 0..<totalRowsInSection {
                let cell = view.tableView.cellForRow(at: IndexPath(row: row, section: section)) as! FlyghtViewCell
                guard let flyghtID = cell.entityID else {return}
                let flyght = storageManager.getFlyght(flyghtID: flyghtID)
                // Приведение номера рейса в соответствие с требованиями API. Для запроса к API нужно писать номер рейса без пробела "KLM1116" или "KL1116", но сам API возвращает номер рейса в таком формате: "KL 1116"
                guard let flyghtNumber = flyght?.flyghtNumber.replacingOccurrences(of: " ", with: "") else {return}
                self.networkManager.loadFlyghtInfo(flyghtNumber: flyghtNumber, completion: {[weak self] result in
                    switch result {
                    case .failure(let error):
                        print(error)
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
                            view.tableView.reloadData()
                            if upatingCounter == totalRowsInSection - 1 {
                                view.toggleActivityIndicator()
                            }
                        }
                    }
                })
            }
        }
    }
    
    func removeFlyght(flyghtID: UUID) {
        storageManager.removeFlyght(flyghtID: flyghtID)
    }
    
}
