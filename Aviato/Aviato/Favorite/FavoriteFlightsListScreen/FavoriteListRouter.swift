//
//  FavoriteListRouter.swift
//  Aviato
//
//  Created by Admin on 11.11.2021.
//

import Foundation
import UIKit

class FavoriteListRouter {
    weak var view: FavoriteFlyghtListViewController?
    
    func showFavoriteFlyght(flyght: FlyghtViewModel, aircraftImage: UIImage?) {
        let favoriteFlyghtView = FavoriteAssembly().build(flyght: flyght, aircraftImage: aircraftImage)
        view?.present(favoriteFlyghtView, animated: true, completion: nil)
    }
}