//
//  LoginRouter.swift
//  Aviato
//
//  Created by Admin on 09.11.2021.
//

import Foundation


protocol ILoginRouter {
    func switchToMainScreen(userID: String)
}

class LoginRouter: ILoginRouter {
    func switchToMainScreen(userID: String) {
        AppDelegate.shared.rootViewController.switchToMainScreen(userID: userID)

    }
}
