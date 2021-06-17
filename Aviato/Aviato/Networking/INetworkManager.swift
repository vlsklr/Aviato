//
//  INetworkManager.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import Foundation

protocol INetworkManager {
//    func loadFlyghtInfo(flyghtNumber: String) -> FlyghtInfo?
    func loadFlyghtInfo(flyghtNumber: String, completion: @escaping (Result<FlyghtInfo, Error>) -> Void)
    
}
