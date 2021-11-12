//
//  FavoriteFlyghtPresenter.swift
//  Aviato
//
//  Created by Admin on 11.11.2021.
//

import Foundation
//Потом убрать
import UIKit

class FavoriteFlyghtPresenter {
    let router: FavoriteRouter
//    let flyghtID: String
    let storageManager = StorageManager()
    let userID = KeyChainManager.readUserSession()
    weak var view: FavoriteViewController?
    
    init(router: FavoriteRouter) {
        self.router = router
//        self.flyghtID = flyghtID
    }
    
}
