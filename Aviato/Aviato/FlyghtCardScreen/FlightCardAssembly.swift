//
//  FavoriteAssembly.swift
//  Aviato
//
//  Created by Admin on 11.11.2021.
//

import Foundation
import UIKit

class FlightCardAssembly {
    func build(flight: FlyghtInfoDataModel, aircraftImage: UIImage?) -> FlightCardViewController {
        var dataModel = flight
        dataModel.aircraftImage = aircraftImage
        let presenter = FlightCardPresenter(dataModel: dataModel,
                                            storageManager: StorageManager())
        let view = FlightCardViewController(presenter: presenter)
        presenter.view = view
        return view
    }
}
