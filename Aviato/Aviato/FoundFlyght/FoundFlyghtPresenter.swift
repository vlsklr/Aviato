//
//  FoundFlyghtPresenter.swift
//  Aviato
//
//  Created by user188734 on 7/8/21.
//

import Foundation
import UIKit

protocol IFoundFlyghtPresenter {
    func addToFavorite(image: UIImage?)
}

class FoundFlyghtPresenter: IFoundFlyghtPresenter {
    let userID: String
    let storageManager: IStorageManager = StorageManager()
    let flyghtInfo: FlyghtViewModel
    weak var view: FoundFlyghtViewController?
    let router: FoundFlyghtRouter
    
    init(userID: String, flyght: FlyghtViewModel, router: FoundFlyghtRouter) {
        self.userID = userID
        flyghtInfo = flyght
        self.router = router
    }
    
    func addToFavorite(image: UIImage?) {
        if storageManager.contains(userID: userID, flyghtNumber: flyghtInfo.flyghtNumber){
            view?.alertController.showAlert(message: RootViewController.labels!.flyghtAlreadyExists)
        } else {
            var imagePath: String? = nil
            guard let flyghtID = FirebaseManager.saveFlyght(flyghtInfo: flyghtInfo) else {return}
            if let img = image {
                imagePath = storageManager.saveImage(image: img, fileName: "\(flyghtID)")
                if imagePath != nil {
                    FirebaseManager.saveImage(fireStoragePath: "images/\(userID)/\(flyghtID).png", imagePathLocal: imagePath!)
                }
            }
            let savedFlyght = FlyghtViewModel(holder: userID, flyghtID: flyghtID, flyghtNumber: flyghtInfo.flyghtNumber, departureAirport: flyghtInfo.departureAirport, arrivalAirport: flyghtInfo.arrivalAirport, departureDate: flyghtInfo.departureDate, arrivalDate: flyghtInfo.arrivalDate, aircraft: flyghtInfo.aircraft, airline: flyghtInfo.airline, status: flyghtInfo.status, departureDateLocal: flyghtInfo.departureDateLocal, arrivalDateLocal: flyghtInfo.arrivalDateLocal)
            storageManager.addFlyght(flyght: savedFlyght)
            router.closeViewController()
        }
    }
}
