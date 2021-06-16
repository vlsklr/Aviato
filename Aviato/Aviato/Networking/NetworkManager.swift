//
//  NetworkManager.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import Foundation

//struct Departure: Decodable {
////    let scheduledTimeLocal: String
//    let airport: [Airport]
//}
//
//struct Airport: Decodable {
//    let icao: String
//}

struct Flyghts: Decodable {
    //рабочие ключи
//    let codeshareStatus: String
//    let number: String
//    let status: String
    
    
    
    //    let departure: String

//    let departureAirport: String
//    let departureTime: Date
//    let arrivarlAirport: String
    
//    let departure: [Departure]
    
    
    let shortName: String

}



struct JSONContainer: Decodable {
    let departure: [Flyghts]
}

extension JSONContainer {
    enum CodingKeys: String, CodingKey {
        case airport
        enum DepartureKeys: String, CodingKey {
            case shortName = "shortName"
        }
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let departureContainer = try container.nestedContainer(keyedBy: CodingKeys.DepartureKeys.self, forKey: .airport)
        departure = try departureContainer.decode([Flyghts].self, forKey: .shortName)
    }
}

class NetworkManager {
    let headers = [
        "x-rapidapi-key": "80d9739b9fmsh282407e5e41686ap1bd973jsna0ddd84bd19b",
        "x-rapidapi-host": "aerodatabox.p.rapidapi.com"
    ]
    func reques() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://aerodatabox.p.rapidapi.com/flights/number/KL0422/2021-06-16?withAircraftImage=true&withLocation=true")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                if let data = data {
                    print()
                    if let result: [Flyghts] = try? JSONDecoder().decode([Flyghts].self, from: data) {
                        print("RESULT IS \(result)")
                        //                                       completion(.success(("\(response.statusCode)","\(result)")))
                    }
                }
                print(httpResponse)
            }
        }).resume()
    }
    
    
    
}

