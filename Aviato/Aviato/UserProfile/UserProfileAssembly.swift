//
//  UserProfileAssembly.swift
//  Aviato
//
//  Created by Vlad on 20.11.2021.
//

import Foundation

class UserProfileAssembly {
    func build(userID: String) -> UserProfileViewController {
        let router = UserProfileRouter()
        let presenter = UserProfilePresenter(router: router, userID: userID)
        let view = UserProfileViewController(presenter: presenter)
        router.view = view
        presenter.view = view
        presenter.getUser()
        return view
    }
}
