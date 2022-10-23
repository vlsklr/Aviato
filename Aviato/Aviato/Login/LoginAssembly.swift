//
//  LoginAssembly.swift
//  Aviato
//
//  Created by Admin on 09.11.2021.
//

import Foundation


final class LoginAssembly {
    func build() -> LoginViewController {
        let loginRouter = LoginRouter()
        let presenter = LoginPresenter(router: loginRouter)
        let viewController = LoginViewController(presenter: presenter)
        presenter.view = viewController
        loginRouter.view = viewController
        return viewController
    }
}
