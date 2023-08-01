//
//  SearchScreenRouter.swift
//  Aviato
//
//  Created by Admin on 11.11.2021.
//

import Foundation
import UIKit

protocol ISearchScreenRouter {
    func showFoundFlyght(userID: String, flyght: FlyghtInfoDataModel, aircraftImageData: Data?)
}

class SearchScreenRouter: ISearchScreenRouter {
    weak var view: ISearchScreenViewController?
    
    func showFoundFlyght(userID: String, flyght: FlyghtInfoDataModel, aircraftImageData: Data?) {
        let foundFlyghtView = FlightCardAssembly().build(flight: flyght,
                                                         aircraftImage: UIImage(data: aircraftImageData ?? Data()))
        view?.showFoundFlyght(foundFlyghtView: foundFlyghtView)
    }
}
