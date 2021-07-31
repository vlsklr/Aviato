//
//  IStorageManager.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import Foundation
import UIKit

protocol IStorageManager {
    func loadUser(username: String?, userID: UUID?) -> UserViewModel?
    func addUser(user: UserViewModel) //, completion: @escaping () -> Void)
    func deleteUser(userID: UUID)
    func updateUser(userID: UUID, userInfo: UserViewModel) 
    func addFlyght(flyght: FlyghtViewModel)
    func removeFlyght(flyghtID: UUID)
    func updateFlyght(flyghtID: UUID, flyght: FlyghtViewModel)
    func getFlyghts(userID: UUID) -> [FlyghtViewModel]?
    func getFlyght(flyghtID: UUID) -> FlyghtViewModel?
    func flyghtsCount(userID: UUID) -> Int
    func contains(userID: UUID, flyghtNumber: String) -> Bool
    func loadImage(path: String) -> UIImage?
    func saveImage(image: UIImage, fileName: String) -> String

}
