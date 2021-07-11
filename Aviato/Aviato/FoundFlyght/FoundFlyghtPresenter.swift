//
//  FoundFlyghtPresenter.swift
//  Aviato
//
//  Created by user188734 on 7/8/21.
//

import Foundation

protocol IFoundFlyghtPresenter {
    func addToFavorite(view: IFoundFlyghtViewController, flyght: FlyghtViewModel)    
}

class FoundFlyghtPresenter: IFoundFlyghtPresenter {
    let userID: UUID
    let storageManager: IStorageManager = StorageManager()
    
    init(userID: UUID) {
        self.userID = userID
    }
    
    func addToFavorite(view: IFoundFlyghtViewController, flyght: FlyghtViewModel) {
        if storageManager.contains(userID: userID, flyghtNumber: flyght.flyghtNumber){
            DispatchQueue.main.async {
                view.showAlert(message: "Данный рейс уже сохранен в избранном")
            }
        }else{
            storageManager.addFlyght(flyght: flyght)
            DispatchQueue.main.async {
                view.dismissFoundView()
            }
        }
    }
}
