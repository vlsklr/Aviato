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
            let user = storageManager.loadUser(username: username, userID: nil)
            if user?.username == username && user?.password == password && user?.userID != nil {
                self.userID = user!.userID
//                AppDelegate.shared.rootViewController.switchToMainScreen()
            }
            else {
                view.showAlert(message: "Данные неверны или такого пользователя не существует")
            }
        }
    }
    
    func registerUser(view: IAlert, username: String, password: String) -> Bool {
        if username.isEmpty || password.isEmpty {
            view.showAlert(message: "Введите данные")
            return false
        } else if let user = storageManager.loadUser(username: username, userID: nil) {
            view.showAlert(message: "Пользователь \(user.username) уже существует")
            return false
        }
        else {
            let user = UserViewModel(userID: userID, username: username, password: password)
            storageManager.addUser(user: user)
            return true
//            storageManager.addUser(user: user) {
//                AppDelegate.shared.rootViewController.switchToMainScreen()
//            }
        }
    }
    
    func getUser() -> UserViewModel? {
        return storageManager.loadUser(username: nil, userID: userID)
    }
    
    func logout() {
        AppDelegate.shared.rootViewController.showLoginScreen()
    }
    
    func findFlyghtInfo(view: IFoundFlyghtViewController, flyghtNumber: String) {
//        view.toggleActivityIndicator()
        self.networkManager.loadFlyghtInfo(flyghtNumber: flyghtNumber, completion: {[weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
//                    view.toggleActivityIndicator()
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
                DispatchQueue.main.async {
//                    view.toggleActivityIndicator()
//                    view.showFoundFlyght(flyghtViewInfo: viewInfo)
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

