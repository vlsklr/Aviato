//
//  UserProfileRouter.swift
//  Aviato
//
//  Created by Admin on 13.11.2021.
//

import Foundation

protocol IUserProfileRouter {
    func showEditUserProfileScreen(userID: String)
    func logout()
}

class UserProfileRouter: IUserProfileRouter {
    weak var view: IUserProfileViewController?
    
    func showEditUserProfileScreen(userID: String) {
        let editView = EditUserProfileAssembly().build(userID: userID)
        view?.showEditUserProfile(editView: editView)
    }
    
    func logout() {
        AppDelegate.shared.rootViewController.switchToLogout()
    }
}
