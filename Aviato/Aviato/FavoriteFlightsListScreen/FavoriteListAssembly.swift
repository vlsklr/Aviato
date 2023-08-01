//
//  FavoriteListAssembly.swift
//  Aviato
//
//  Created by Admin on 11.11.2021.
//

import Foundation

class FavoriteListAssembly {
    func build(userID: String) -> FavoriteFlightsListViewController {
        let router = FavoriteListRouter()
        let presenter = FavoriteFlyghtListPresenter(userID: userID, router: router)
        let view = FavoriteFlightsListViewController(presenter: presenter)
        router.view = view
        presenter.view = view
        return view
    }
}
