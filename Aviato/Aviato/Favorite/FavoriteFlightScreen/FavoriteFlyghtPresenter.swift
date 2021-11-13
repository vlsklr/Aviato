//
//  FavoriteFlyghtPresenter.swift
//  Aviato
//
//  Created by Admin on 11.11.2021.
//

import Foundation


class FavoriteFlyghtPresenter {
    let router: FavoriteRouter
    weak var view: FavoriteViewController?
    
    init(router: FavoriteRouter) {
        self.router = router
    }
}
