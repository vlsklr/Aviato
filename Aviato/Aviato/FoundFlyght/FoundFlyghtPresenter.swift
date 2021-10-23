//
//  FoundFlyghtPresenter.swift
//  Aviato
//
//  Created by user188734 on 7/8/21.
//

import Foundation
import UIKit

protocol IFoundFlyghtPresenter {
    func addToFavorite(view: IFoundFlyghtViewController, flyght: FlyghtViewModel, image: UIImage?)
}

class FoundFlyghtPresenter: IFoundFlyghtPresenter {
    let userID: String
    let storageManager: IStorageManager = StorageManager()
    
    init(userID: String) {
        self.userID = userID
    }
    
    func addToFavorite(view: IFoundFlyghtViewController, flyght: FlyghtViewModel, image: UIImage?) {
        if storageManager.contains(userID: userID, flyghtNumber: flyght.flyghtNumber){
            DispatchQueue.main.async {
                view.showAlert(message: "Данный рейс уже сохранен в избранном")
            }
        } else {
            //var flyghtInfo = flyght
            var imagePath: String? = nil
            
            guard let flyghtID = FirebaseManager.saveFlyght(flyghtInfo: flyght) else {return}
            if let img = image {
                imagePath = storageManager.saveImage(image: img, fileName: "\(flyghtID)")
                if imagePath != nil {
                    FirebaseManager.saveImage(fireStoragePath: "images/\(userID)/\(flyghtID).jpg", imagePathLocal: imagePath!)
                }
            }
            let savedFlyght = FlyghtViewModel(holder: userID, flyghtID: flyghtID, flyghtNumber: flyght.flyghtNumber, departureAirport: flyght.departureAirport, arrivalAirport: flyght.arrivalAirport, departureDate: flyght.departureDate, arrivalDate: flyght.arrivalDate, aircraft: flyght.aircraft, airline: flyght.airline, status: flyght.status, departureDateLocal: flyght.departureDateLocal, arrivalDateLocal: flyght.arrivalDateLocal, aircraftImage: imagePath)
            storageManager.addFlyght(flyght: savedFlyght)
            
            DispatchQueue.main.async {
                view.dismissFoundView()
            }
        }
    }
}
