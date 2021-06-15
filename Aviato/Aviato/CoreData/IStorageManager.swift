//
//  IStorageManager.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import Foundation

protocol IStorageManager {
    func loadUser(username: String) -> UserViewModel?
    func addUser(user: UserViewModel, completion: @escaping () -> Void)
    func AddFlyght(flyght: FlyghtViewModel)
    func removeFlyght(flyghtID: UUID, completion: @escaping () -> Void)
    func getFlyghts(userID: UUID) -> [FlyghtViewModel]?
    func getFlyght(flyghtID: UUID) -> FlyghtViewModel?

}