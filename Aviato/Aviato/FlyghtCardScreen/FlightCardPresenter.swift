//
//  FavoriteFlyghtPresenter.swift
//  Aviato
//
//  Created by Admin on 11.11.2021.
//

import Foundation
import UIKit

class FlightCardPresenter {
    
    // MARK: - Properties
    
    private var dataModel: FlyghtInfoDataModel
    private let storageManager: IStorageManager
    private let userID: String
    
    weak var view: FlightCardViewController?
    
    var isFavorite: Bool {
        storageManager.contains(userID: userID, flyghtNumber: dataModel.flyghtNumber)
    }
    
    var flyghtNumber: String {
        "\(RootViewController.labels.flyghtNumber) \(dataModel.flyghtNumber)"
    }
    
    var arrivalTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: dataModel.arrivalDate)
    }
    
    var arrivalAirport: String {
        dataModel.arrivalAirport
    }
    
    var departureTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: dataModel.departureDate)
    }
    
    var flyghtStatus: String {
        "\(RootViewController.labels.flyghtStatus) \(dataModel.status)"
    }
    
    var departureAirport: String {
        dataModel.departureAirport
    }
    
    var departureDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, EE"
        return dateFormatter.string(from: dataModel.departureDate)
    }
    
    var departureCity: String {
        dataModel.departureCity
    }
    
    var arrivalDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, EE"
        return dateFormatter.string(from: dataModel.arrivalDate)
    }
    
    var aircraft: String {
        "\(RootViewController.labels.aircraft) \(dataModel.aircraft)"
    }
    
    var airline: String {
        dataModel.airline
    }
    
    var enrouteTime: String {
        "\(RootViewController.labels.enroute) \(Calendar.current.dateComponents([.hour], from: dataModel.departureDate, to: dataModel.arrivalDate).hour?.description ?? "") ч."
    }
    
    var arrivalCity: String {
        dataModel.arrivalCity
    }
    
    var aircraftImage: UIImage? {
        dataModel.aircraftImage
    }
    
    func addToFavorite() {
        if isFavorite,
           let flyghtId = storageManager.getFlyghts(userID: userID)?.first(where: {$0.flyghtNumber == dataModel.flyghtNumber })?.flyghtID {
            storageManager.removeFlyght(flyghtID: flyghtId)
            FirebaseManager.removeFlyght(flyghtID: flyghtId)
        } else {
            var imagePath: String? = nil
            guard let flyghtID = FirebaseManager.saveFlyght(flyghtInfo: dataModel) else { return }
            if let img = aircraftImage {
                imagePath = storageManager.saveImage(image: img, fileName: "\(flyghtID)")
                if imagePath != nil {
                    FirebaseManager.saveImage(fireStoragePath: "images/\(userID)/\(flyghtID).png", imagePathLocal: imagePath!)
                }
            }
            dataModel.flyghtID = flyghtID
            storageManager.addFlyght(flyght: dataModel)
        }
    }
    
    // MARK: - Initializer
    
    init(dataModel: FlyghtInfoDataModel, storageManager: IStorageManager) {
        userID = dataModel.holder
        self.storageManager = storageManager
        self.dataModel = dataModel
    }
}
