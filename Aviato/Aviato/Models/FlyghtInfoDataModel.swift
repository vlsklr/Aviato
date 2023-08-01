//
//  FlyghtViewModel.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import Foundation
import UIKit

struct FlyghtInfoDataModel {
    let holder: String
    var flyghtID: String
    var flyghtNumber: String
    var departureAirport: String
    var arrivalAirport: String
    var departureDate: Date
    var arrivalDate: Date
    var aircraft: String
    var airline: String
    var status: FlightStatus
    var departureCity: String
    var arrivalCity: String
    var aircraftImage: UIImage?
}

enum FlightStatus: String, CodingKey, Decodable {
    case unknown = "Unknown"
    case expected = "Expected"
    case enRoute = "EnRoute"
    case checkIn = "CheckIn"
    case boarding = "Boarding"
    case gateClosed = "GateClosed"
    case departed = "Departed"
    case delayed = "Delayed"
    case approaching = "Approaching"
    case arrived = "Arrived"
    case canceled = "Canceled"
    case diverted = "Diverted"
    case canceledUncertain = "CanceledUncertain"
    
    var description: String {
        switch self {
        case .unknown:
            return "Неизвестно"
        case .expected:
            return "Ожидается"
        case .enRoute:
            return "В пути"
        case .checkIn:
            return "Регистрация"
        case .boarding:
            return "Посадка"
        case .gateClosed:
            return "Посадка завершена"
        case .departed:
            return "Отбыл"
        case .delayed:
            return "Задержан"
        case .approaching:
            return "Прибывает"
        case .arrived:
            return "Прибыл"
        case .canceled, .canceledUncertain:
            return "Отменен"
        case .diverted:
            return "Перенаправлен"
        }
    }
}


