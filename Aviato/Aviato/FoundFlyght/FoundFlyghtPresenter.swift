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
    let userID: UUID
    let storageManager: IStorageManager = StorageManager()
    
    init(userID: UUID) {
        self.userID = userID
    }
    
    func addToFavorite(view: IFoundFlyghtViewController, flyght: FlyghtViewModel, image: UIImage?) {
        if storageManager.contains(userID: userID, flyghtNumber: flyght.flyghtNumber){
            DispatchQueue.main.async {
                view.showAlert(message: "Данный рейс уже сохранен в избранном")
            }
        } else {
            var flyghtInfo = flyght
            if let img = image {
            flyghtInfo.aircraftImage = storageManager.saveImage(image: img, fileName: "\(flyght.flyghtID)")
            }
            storageManager.addFlyght(flyght: flyghtInfo)
            DispatchQueue.main.async {
                view.dismissFoundView()
            }
        }
    }
}
