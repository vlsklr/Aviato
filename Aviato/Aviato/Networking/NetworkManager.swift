//
//  NetworkManager.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import Foundation

struct Departure: Decodable {
    let scheduledTimeUtc: String
    let airport: Airport
}

struct Arrival: Decodable {
    let scheduledTimeUtc: String
    let airport: Airport
}

struct Airport: Decodable {
    let name: String
    let countryCode: String
}

struct Aircraft: Decodable {
    let model: String
}

struct Airline: Decodable {
    let name: String
}

struct FlyghtInfo: Decodable {
    let codeshareStatus: String
    let number: String
    let status: String
    let arrival: Arrival
    let departure: Departure
    let aircraft: Aircraft
    let airline: Airline
}


class NetworkManager: INetworkManager {
    let headers = [
        "x-rapidapi-key": "80d9739b9fmsh282407e5e41686ap1bd973jsna0ddd84bd19b",
        "x-rapidapi-host": "aerodatabox.p.rapidapi.com"
    ]
    func loadFlyghtInfo(flyghtNumber: String) -> FlyghtInfo? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        let request = NSMutableURLRequest(url: NSURL(string: "https://aerodatabox.p.rapidapi.com/flights/number/\(flyghtNumber))/\(dateString)?withAircraftImage=false&withLocation=false")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        var flyght: FlyghtInfo? = nil
        session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                if let data = data {
                    if httpResponse?.statusCode == 200 {
                        print("ДВЕСТИ!!!11")
                        if let result: [FlyghtInfo] = try? JSONDecoder().decode([FlyghtInfo].self, from: data) {
                            if let flyghtInfo = result.last {
                                flyght = flyghtInfo
                                print(flyghtInfo.departure.airport.name)
                            }
                        }
                    }
                    
                }
            }
        }).resume()
        return flyght
        
    }
    
    
    
}

