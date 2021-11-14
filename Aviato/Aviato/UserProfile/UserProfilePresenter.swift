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
    let storageManager = StorageManager()
    let router: UserProfileRouter
    weak var view: UserProfileViewController?
    
    init(router: UserProfileRouter, userID: String) {
        self.router = router
        self.userID = userID
    }
    
    func getUser() {
        if let user = storageManager.loadUser(email: nil, userID: userID) {
            view?.showUserInfo(userInfo: user)
//            userViewController.showUserInfo(userInfo: user)
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
//        let presenter: IEditUserProfilePresenter = EditUserProfilePresenter(userID: self.userID)
//        let viewController: EditUserProfileViewController = EditUserProfileViewController(editPresenter: presenter)
//        view.showEditUserProfileScreen(view: viewController)
    }
    
    func getImage(fileName: String) -> UIImage? {
        return storageManager.loadImage(fileName: fileName)
    }
    
}
