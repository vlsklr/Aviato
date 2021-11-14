//
//  FoundFlyghtAssembly.swift
//  Aviato
//
//  Created by Admin on 11.11.2021.
//

import Foundation
import UIKit

class FoundFlyghtAssembly {
    func build(userID: String, flyght: FlyghtViewModel, aircraftImageData: Data?) -> FoundFlyghtViewController {
        let router = FoundFlyghtRouter()
        let presenter = FoundFlyghtPresenter(userID: userID, flyght: flyght, router: router)
        var view: FoundFlyghtViewController
        if let aircraftImageData = aircraftImageData, let image = UIImage(data: aircraftImageData) {
            view = FoundFlyghtViewController(flyghtViewInfo: flyght, presenter: presenter, aircraftPicture: image)
        } else {
            view = FoundFlyghtViewController(flyghtViewInfo: flyght, presenter: presenter)
        }
        router.view = view
        presenter.view = view
        view.setupLabelsText(flyghtViewInfo: flyght)
        return view
    }
}
