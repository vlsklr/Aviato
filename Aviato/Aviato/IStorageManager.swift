//
//  IStorageManager.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import Foundation

protocol IStorageManager {
    func loadUsers() -> [User]
    func addUser(user: UserViewModel)
}
