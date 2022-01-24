//
//  EditUserProfileRouter.swift
//  Aviato
//
//  Created by Admin on 13.11.2021.
//

import Foundation

protocol IEditUserProfileRouter: AnyObject {
    func logout()
    func closeView()
}

class EditUserProfileRouter: IEditUserProfileRouter {
    weak var view: IEditUserProfileViewController?
    
    func logout() {
        closeView()
        AppDelegate.shared.rootViewController.showLoginScreen()
    }
    
    func closeView() {
        view?.closeView()
    }
    
}
