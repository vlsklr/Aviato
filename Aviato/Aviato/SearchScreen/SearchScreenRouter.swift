//
//  SearchScreenRouter.swift
//  Aviato
//
//  Created by Admin on 11.11.2021.
//

import Foundation
import UIKit

protocol ISearchScreenRouter {
    func showFoundFlyght(userID: String, flyght: FlyghtViewModel, aircraftImageData: Data?)
}

class SearchScreenRouter: ISearchScreenRouter {
    weak var view: ISearchScreenViewController?
    
    func showFoundFlyght(userID: String, flyght: FlyghtViewModel, aircraftImageData: Data?) {
        let foundFlyghtView = FoundFlyghtAssembly().build(userID: userID, flyght: flyght, aircraftImageData: aircraftImageData)
        view?.showFoundFlyght(foundFlyghtView: foundFlyghtView)
    }
}
