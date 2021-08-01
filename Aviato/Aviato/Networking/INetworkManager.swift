//
//  INetworkManager.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import  Foundation

protocol INetworkManager {
    func loadFlyghtInfo(flyghtNumber: String, completion: @escaping (Result<FlyghtInfo, Error>) -> Void)
    func loadAircraftImage(url: String, completion: @escaping (Data) -> Void)
}
