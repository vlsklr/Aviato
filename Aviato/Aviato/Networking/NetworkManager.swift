//
//  NetworkManager.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import Foundation

class NetworkManager {
    let headers = [
        "x-rapidapi-key": "80d9739b9fmsh282407e5e41686ap1bd973jsna0ddd84bd19b",
        "x-rapidapi-host": "aerodatabox.p.rapidapi.com"
    ]
    func reques() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://aerodatabox.p.rapidapi.com/flights/number/KL1395/2020-06-10")! as URL,                                             cachePolicy: .useProtocolCachePolicy,                                         timeoutInterval: 10.0)
        
    //    let url = URL(string: "https://aerodatabox.p.rapidapi.com/flights/number/KL1395/2020-06-10")! //ТАК ДЕЛАТЬ НЕЛЬЗЯ !!!
//        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
        }).resume()
    }



}

