//
//  RegistrationRouter.swift
//  Aviato
//
//  Created by Admin on 10.11.2021.
//

import Foundation

class RegistrationRouter {
    weak var view: RegistrationViewController?
    func returnToLoginScreen() {
        view?.dismiss(animated: true)
    }
}
