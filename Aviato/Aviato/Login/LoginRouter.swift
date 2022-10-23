//
//  LoginRouter.swift
//  Aviato
//
//  Created by Admin on 09.11.2021.
//

import Foundation


protocol ILoginRouter {
    func switchToMainScreen(userID: String)
    func showRegisterScreen()
}

class LoginRouter: ILoginRouter {
    
    // MARK: - Properties
    
    weak var view: ILoginViewController?
    
    func switchToMainScreen(userID: String) {
        AppDelegate.shared.rootViewController.switchToMainScreen(userID: userID)
    }
    
    func showRegisterScreen() {
        let registrationViewController = RegistrationAssembly().build()
        view?.showScreen(viewController: registrationViewController)
    }
}
