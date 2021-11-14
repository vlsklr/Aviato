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
    weak var view: LoginViewController?
    
    func switchToMainScreen(userID: String) {
        AppDelegate.shared.rootViewController.switchToMainScreen(userID: userID)
    }
    
    func showRegisterScreen() {
        let registrationViewController = RegistrationAssembly().build()
        view?.present(registrationViewController, animated: true, completion: nil)
    }
}
