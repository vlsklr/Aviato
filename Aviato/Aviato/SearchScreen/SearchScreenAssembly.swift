//
//  SearchScreenAssembly.swift
//  Aviato
//
//  Created by Admin on 11.11.2021.	
//

import Foundation


class SearchScreenAssembly {
    func build(userID: String) -> SearchScreenViewController {
        let router = SearchScreenRouter()
        let presenter = SearchScreenPresenter(userID: userID, router: router)
        let view = SearchScreenViewController(presenter: presenter)
        presenter.view = view
        router.view = view
        return view
    }
}
