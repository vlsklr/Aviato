//
//  IPresenter.swift
//  Aviato
//
//  Created by Vlad on 16.06.2021.
//

import Foundation

protocol IPresenter {
    func authentificateUser(username: String, password: String)
    func registerUser(username: String, password: String)
//    func findFlyghtInfo(flyghtNumber: String)
    func findFlyghtInfo(view: IFoundFlyghtViewController, flyghtNumber: String)
    func addToFavorite(flyght: FlyghtViewModel)
    func getFlyghts() -> [FlyghtViewModel]?
    
    func removeFlyght(flyghtID: UUID, completion: @escaping () -> Void)
    func getFavorite(view: IFavoriteFlyghtViewController, indexPath: IndexPath)
}
