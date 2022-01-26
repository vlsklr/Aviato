//
//  UserProfilePresenter.swift
//  Aviato
//
//  Created by Vlad on 11.07.2021.
//

import Foundation
import UIKit

protocol IUserProfilePresenter {
    func logout()
    func getUser()
    func editUser()
    func getImage(fileName: String) -> UIImage?
    
}

class UserProfilePresenter: IUserProfilePresenter {
    
    let userID: String
    let storageManager: IStorageManager = StorageManager()
    let router: IUserProfileRouter
    weak var view: IUserProfileViewController?
    
    init(router: UserProfileRouter, userID: String) {
        self.router = router
        self.userID = userID
    }
    
    func getUser() {
        if let user = storageManager.loadUser(email: nil, userID: userID) {
            view?.showUserInfo(userInfo: user)
        } else {
        }
        
    }
    
    func logout() {
        if let flyghts = storageManager.getFlyghts(userID: userID) {
            for flyght in flyghts {
                storageManager.removeFlyght(flyghtID: flyght.flyghtID)
            }
        }
        storageManager.deleteUser(userID: userID)
        FirebaseManager.logout()
        KeyChainManager.deleteUserSession()
        router.logout()
    }
    
    
    func editUser() {
        router.showEditUserProfileScreen(userID: userID)
    }
    
    func getImage(fileName: String) -> UIImage? {
        return storageManager.loadImage(fileName: fileName)
    }
    
}
