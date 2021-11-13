//
//  FavoriteAssembly.swift
//  Aviato
//
//  Created by Admin on 11.11.2021.
//

import Foundation
import UIKit

class FavoriteAssembly {
    
    func build(flyght: FlyghtViewModel, aircraftImage: UIImage?) -> FavoriteViewController {
        let router = FavoriteRouter()
        let presenter = FavoriteFlyghtPresenter(router: router)
        if let aircraftImage = aircraftImage {
         let view = FavoriteViewController(aircraftImage: aircraftImage)
            router.view = view
            presenter.view = view
            view.setupLabelsText(flyghtViewInfo: flyght)
            return view
        } else {
            let view = FavoriteViewController()
            router.view = view
            presenter.view = view
            view.setupLabelsText(flyghtViewInfo: flyght)
            return view
        }
    }
    
}
