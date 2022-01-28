//
//  RegistrationRouter.swift
//  Aviato
//
//  Created by Admin on 10.11.2021.
//

import Foundation

protocol IRegistrationRouter {
    func returnToLoginScreen()
}

class RegistrationRouter: IRegistrationRouter {
    weak var view: IRegistrationViewController?
    func returnToLoginScreen() {
        view?.hideScreen()
    }
}
