//
//  INetworkManager.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//


protocol INetworkManager {
    func loadFlyghtInfo(flyghtNumber: String, completion: @escaping (Result<FlyghtInfo, Error>) -> Void)
}
