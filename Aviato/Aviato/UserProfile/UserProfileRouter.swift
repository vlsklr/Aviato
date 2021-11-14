//
//  UserProfileRouter.swift
//  Aviato
//
//  Created by Admin on 13.11.2021.
//

import Foundation

class UserProfileRouter {
    weak var view: UserProfileViewController?
    
    func showEditUserProfileScreen(userID: String) {
        let editView = EditUserProfileAssembly().build(userID: userID)
        view?.present(editView, animated: true, completion: nil)
    }
    
    func logout() {
        AppDelegate.shared.rootViewController.switchToLogout()
    }
}
