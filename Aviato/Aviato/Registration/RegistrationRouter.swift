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
    
    // MARK: - Properties
    
    weak var view: IRegistrationViewController?
    
    // MARK: - Public methods
    
    func returnToLoginScreen() {
        view?.hideScreen()
    }
}
