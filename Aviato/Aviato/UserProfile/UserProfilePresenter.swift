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
    
    
}

class UserProfilePresenter: IUserProfilePresenter {

    let userID: UUID
    let storageManager = StorageManager()
    
    init(userID: UUID) {
        self.userID = userID
    }
    
    func getUser(userViewController: IUserProfileViewController) {
        let user = storageManager.loadUser(username: nil, userID: userID)
        userViewController.showUserInfo(userInfo: user ?? UserViewModel(userID: UUID(), username: "", password: ""))
        
    }
    
    func logout() {
        AppDelegate.shared.rootViewController.showLoginScreen()
    }
    
    func removeUser() {
        storageManager.deleteUser(userID: self.userID)
        logout()
    }
    
}
