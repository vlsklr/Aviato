//
//  EditUserProfileRouter.swift
//  Aviato
//
//  Created by Admin on 13.11.2021.
//

import Foundation


class EditUserProfileRouter {
    weak var view: EditUserProfileViewController?
    
    func logout() {
        closeView()
        AppDelegate.shared.rootViewController.showLoginScreen()
    }
    
    func closeView() {
        view?.dismiss(animated: true, completion: nil)
    }
    
}
