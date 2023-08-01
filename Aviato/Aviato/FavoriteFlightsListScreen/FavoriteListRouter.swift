//
//  FavoriteListRouter.swift
//  Aviato
//
//  Created by Admin on 11.11.2021.
//

import Foundation
import UIKit

protocol IFavoriteListRouter {
    func showFlyghtCard(flyght: FlyghtInfoDataModel, aircraftImage: UIImage?)
}

class FavoriteListRouter: IFavoriteListRouter {
    weak var view: IFavoriteFlightsListViewController?
    
    func showFlyghtCard(flyght: FlyghtInfoDataModel, aircraftImage: UIImage?) {
        let favoriteFlyghtView = FlightCardAssembly().build(flight: flyght, aircraftImage: aircraftImage)
        view?.showFlyght(flyghtVC: favoriteFlyghtView)
    }
}
