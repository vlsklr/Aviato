//
//  EditUserProfileAssembly.swift
//  Aviato
//
//  Created by Admin on 13.11.2021.
//

import Foundation

class EditUserProfileAssembly {
    func build(userID: String) -> EditUserProfileViewController {
        let router = EditUserProfileRouter()
        let presenter = EditUserProfilePresenter(userID: userID, router: router)
        let view = EditUserProfileViewController(editPresenter: presenter)
        router.view = view
        presenter.view = view
//        presenter.getUser()
        return view
    }
}
