//
//  FlyghtViewModel.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import Foundation

struct FlyghtViewModel {
    let holder: UUID
    let flyghtID: UUID
    var flyghtNumber: String
    var departureAirport: String
    var arrivalAirport: String
    var departureDate: Date
    var arrivalDate: Date
    var aircraft: String
    var airline: String
    
    var departureDateLocal: String
    var arrivalDateLocal: String
    
}


