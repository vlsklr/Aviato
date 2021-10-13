//
//  IStorageManager.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import Foundation
import UIKit

protocol IStorageManager {
    func loadUser(email: String?, userID: String?) -> UserViewModel?
    func addUser(user: UserViewModel) //, completion: @escaping () -> Void)
    func deleteUser(userID: String)
    func updateUser(userID: String, userInfo: UserViewModel)
    func addFlyght(flyght: FlyghtViewModel)
    func removeFlyght(flyghtID: String)
    func updateFlyght(flyghtID: String, flyght: FlyghtViewModel)
    func getFlyghts(userID: String) -> [FlyghtViewModel]?
    func getFlyght(flyghtID: String) -> FlyghtViewModel?
    func flyghtsCount(userID: String) -> Int
    func contains(userID: String, flyghtNumber: String) -> Bool
    func loadImage(path: String) -> UIImage?
    func saveImage(image: UIImage, fileName: String) -> String

}
