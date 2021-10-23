//
//  UserProfilePresenter.swift
//  Aviato
//
//  Created by Vlad on 11.07.2021.
//

import Foundation
import UIKit

protocol IUserProfilePresenter {
    func logout()
    func getUser(userViewController: IUserProfileViewController)
    func editUser(view: IUserProfileViewController)
    func getImage(path: String) -> UIImage?
    
}

class UserProfilePresenter: IUserProfilePresenter {
    
    let userID: String
    let storageManager = StorageManager()
    
    init(userID: String) {
        self.userID = userID
    }
    
    func getUser(userViewController: IUserProfileViewController) {
        if let user = storageManager.loadUser(email: nil, userID: userID) {
            userViewController.showUserInfo(userInfo: user)
        } else {
//            FirebaseManager.loadUserInfo(userID: userID){ [weak self] result in
//                switch result {
//                case .success(var user):
//                    let userID = user.userID
//                    FirebaseManager.loadImage(filestoragePath: "images/\(userID)/avatar.jpg"){ [weak self] result in
//                        switch result {
//                        case .failure(let error):
//                            print(error)
//                        case .success(let data):
//                            guard let data = data, let image = UIImage(data: data) else {
//                                return
//                            }
//                            if let imagePath = self?.storageManager.saveImage(image: image, fileName: "\(user.userID)") {
//                                user.avatarPath = imagePath
//                                self?.storageManager.updateUser(userID: user.userID, userInfo: user)
//                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object:nil, userInfo: nil)
//                            }
//                        }
//                    }
//                    self?.storageManager.addUser(user: user)
//                    userViewController.showUserInfo(userInfo: user)
//                case .failure(let error):
//                    print("При загрузке данных что-то пошло не так \(error)")
//                }
//            }
            
        }
        
    }
    
    func logout() {
        if let flyghts = storageManager.getFlyghts(userID: userID) {
            for flyght in flyghts {
                storageManager.removeFlyght(flyghtID: flyght.flyghtID)
            }
        }
        storageManager.deleteUser(userID: userID)
        FirebaseManager.logout()
        KeyChainManager.deleteUserSession()
        AppDelegate.shared.rootViewController.switchToLogout()
    }
    
    
    func editUser(view: IUserProfileViewController) {
        let presenter: IEditUserProfilePresenter = EditUserProfilePresenter(userID: self.userID)
        let viewController: EditUserProfileViewController = EditUserProfileViewController(editPresenter: presenter)
        view.showEditUserProfileScreen(view: viewController)
    }
    
    func getImage(path: String) -> UIImage? {
        return storageManager.loadImage(path: path)
    }
    
}
