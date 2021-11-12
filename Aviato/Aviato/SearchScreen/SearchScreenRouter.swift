//
//  SearchScreenRouter.swift
//  Aviato
//
//  Created by Admin on 11.11.2021.
//

import Foundation
import UIKit

class SearchScreenRouter {
    weak var view: SearchScreenViewController?
    
    func showFoundFlyght(userID: String, flyght: FlyghtViewModel, aircraftImageData: Data?) {
        let foundFlyghtView = FoundFlyghtAssembly().build(userID: userID, flyght: flyght, aircraftImageData: aircraftImageData)
        view?.present(foundFlyghtView, animated: true, completion: nil)
    }
    
}
