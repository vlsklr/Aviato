//
//  UserProfilePresenter.swift
//  Aviato
//
//  Created by Vlad on 11.07.2021.
//

import Foundation

protocol IUserProfilePresenter {
    func logout()
    func getUser(userViewController: IUserProfileViewController)
    func removeUser()
    func editUser(view: IUserProfileViewController)
    
    
}

class UserProfilePresenter: IUserProfilePresenter {

    let userID: UUID
    let storageManager = StorageManager()
    
    init(userID: UUID) {
        self.userID = userID
    }
    
    func getUser(userViewController: IUserProfileViewController) {
        let user = storageManager.loadUser(username: nil, userID: userID)
        userViewController.showUserInfo(userInfo: user ?? UserViewModel(userID: UUID(), username: "", password: "", birthDate: Date(), email: "", name: ""))
        
    }
    
    func logout() {
        KeyChainManager.deleteUserSession()
        AppDelegate.shared.rootViewController.switchToLogout()
    }
    
    func removeUser() {
        storageManager.deleteUser(userID: self.userID)
        logout()
    }
    
    func editUser(view: IUserProfileViewController) {
        let presenter: IEditUserProfilePresenter = EditUserProfilePresenter(userID: self.userID)
        let viewController: EditUserProfileViewController = EditUserProfileViewController(editPresenter: presenter)
        view.showEditUserProfileScreen(view: viewController)
    }
    
}
