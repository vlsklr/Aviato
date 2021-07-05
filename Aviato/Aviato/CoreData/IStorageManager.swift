//
//  IStorageManager.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import Foundation

protocol IStorageManager {
    func loadUser(username: String) -> UserViewModel?
    func addUser(user: UserViewModel) //, completion: @escaping () -> Void)
    func addFlyght(flyght: FlyghtViewModel)
    func removeFlyght(flyghtID: UUID)
    func updateFlyght(flyghtID: UUID, flyght: FlyghtViewModel)
    func getFlyghts(userID: UUID) -> [FlyghtViewModel]?
    func getFlyght(flyghtID: UUID) -> FlyghtViewModel?
    func flyghtsCount(userID: UUID) -> Int
    func contains(userID: UUID, flyghtNumber: String) -> Bool

}
