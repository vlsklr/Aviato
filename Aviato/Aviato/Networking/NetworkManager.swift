//
//  NetworkManager.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import Foundation
import Alamofire

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
    let image: Image
}

struct Image: Decodable {
    let url: String
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

protocol INetworkManager {
    func loadFlyghtInfo(flyghtNumber: String, completion: @escaping (Result<FlyghtInfo, Error>) -> Void)
    func loadAircraftImage(url: String, completion: @escaping (Data) -> Void)
}

class NetworkManager: INetworkManager {
    let headers = [
        "x-rapidapi-key": "",
        "x-rapidapi-host": "aerodatabox.p.rapidapi.com"
    ]
    
    func loadFlyghtInfo(flyghtNumber: String, completion: @escaping (Result<FlyghtInfo, Error>) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        guard let url = URL(string: "https://aerodatabox.p.rapidapi.com/flights/number/\(flyghtNumber)/\(dateString)?withAircraftImage=true&withLocation=false") else { return }
        print(url)
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        request.timeoutInterval = 25
        var flyght: FlyghtInfo? = nil
        session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                completion(.failure(FlyghtErrors.wrongFlyght))
            } else {
                let httpResponse = response as? HTTPURLResponse
                if let data = data {
                    if httpResponse?.statusCode == 200, let result: [FlyghtInfo] = try? JSONDecoder().decode([FlyghtInfo].self, from: data), let flyghtInfo = result.last {
                        print("ДВЕСТИ!!!11")
                        flyght = flyghtInfo
                        completion(.success(flyght!))
                        print(flyghtInfo.departure.airport.name)
                    }
                    else {
                        completion(.failure(FlyghtErrors.wrongFlyght))
                    }
                }
            }
        }).resume()
    }
    func loadAircraftImage(url: String, completion: @escaping (Data) -> Void) {
        AF.request(url).response { response in
            completion(response.data ?? Data())
        }
    }
}

