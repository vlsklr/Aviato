//
//  RegistrationAssembly.swift
//  Aviato
//
//  Created by Admin on 10.11.2021.
//

import Foundation

class RegistrationAssembly {
    func build() -> RegistrationViewController {
        let router = RegistrationRouter()
        let registrationPresenter: RegistrationPresenter = RegistrationPresenter(router: router)
        let registrationViewController = RegistrationViewController(presenter: registrationPresenter)
        registrationPresenter.view = registrationViewController
        router.view = registrationViewController
        return registrationViewController
    }
}
