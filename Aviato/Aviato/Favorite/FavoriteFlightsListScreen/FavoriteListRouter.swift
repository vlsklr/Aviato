//
//  FavoriteListRouter.swift
//  Aviato
//
//  Created by Admin on 11.11.2021.
//

import Foundation
import UIKit

protocol IFavoriteListRouter {
    func showFavoriteFlyght(flyght: FlyghtViewModel, aircraftImage: UIImage?)
}

class FavoriteListRouter: IFavoriteListRouter {
    weak var view: IFavoriteFlyghtListViewController?
    
    func showFavoriteFlyght(flyght: FlyghtViewModel, aircraftImage: UIImage?) {
        let favoriteFlyghtView = FavoriteAssembly().build(flyght: flyght, aircraftImage: aircraftImage)
        view?.showFlyght(flyghtVC: favoriteFlyghtView)
    }
}
