//
//  IPresenter.swift
//  Aviato
//
//  Created by Vlad on 16.06.2021.
//

import Foundation

protocol IPresenter {
    func authentificateUser(view: IAlert, username: String, password: String)
    func registerUser(view: IAlert, username: String, password: String)
    func logout()
    func findFlyghtInfo(view: IFoundFlyghtViewController, flyghtNumber: String)
    func addToFavorite(view: IAlert, flyght: FlyghtViewModel) -> Bool
    func getFlyghts() -> [FlyghtViewModel]?
    func getFlyghtsCount() -> Int
    func updateFlyghtInfo(view: FavoriteFlyghtListViewController)
    func removeFlyght(flyghtID: UUID)
    func getFavorite(view: IFavoriteFlyghtViewController, flyghtID: UUID)
}
