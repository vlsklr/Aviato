//
//  EditUserProfilePresenter.swift
//  Aviato
//
//  Created by user188734 on 7/21/21.
//

import Foundation
import UIKit



protocol IEditUserProfilePresenter {
    func removeUser()
    func updateUserInfo(view: IEditUserProfileViewController, userInfo: UserViewModel, userAvatar: UIImage?) -> Bool
    func getUser(userEditingViewController: IEditUserProfileViewController)
    func getImage(path: String) -> UIImage?
}

class EditUserProfilePresenter: UserProfilePresenter, IEditUserProfilePresenter {
    
    func updateUserInfo(view: IEditUserProfileViewController, userInfo: UserViewModel, userAvatar: UIImage?) -> Bool {
        var user = UserViewModel(userID: userID, password: "", birthDate: userInfo.birthDate, email: userInfo.email, name: userInfo.name, avatarPath: userInfo.avatarPath)
        if validateUserData(userInfo: userInfo) {
            if let image = userAvatar {
                let savedPath = storageManager.saveImage(image: image, fileName: "\(userID)")
                FirebaseManager.saveImage(fireStoragePath: "images/\(user.userID)/avatar.jpg", imagePathLocal: savedPath)
                user.avatarPath = savedPath
            }
            storageManager.updateUser(userID: userID, userInfo: user)
            FirebaseManager.updateUserInfo(userInfo: user)
//            FirebaseManager.up
            return true
        } else {
            view.showAlert(message: "Такой пользователь уже существует")
            return false
        }
    }
    
    //Возвращает true, если имя пользователя не занято или не изменяется
    private func validateUserData(userInfo: UserViewModel) -> Bool {
        guard let user = storageManager.loadUser(email: userInfo.email, userID: nil) else { return true }
        if user.userID == userID {
            return true
        } else {
            return false
        }
    }
    
    
    func removeUser() {
        if let flyghts = storageManager.getFlyghts(userID: userID) {
            for flyght in flyghts {
                FirebaseManager.removeFlyght(flyghtID: flyght.flyghtID)
//                FirebaseManager.deleteImage(filestoragePath: "images/\(userID)/\(flyght.flyghtID).jpg")
                storageManager.removeFlyght(flyghtID: flyght.flyghtID)
            }
        }
        storageManager.deleteUser(userID: self.userID)
        FirebaseManager.removeUser(userID: self.userID)
        FirebaseManager.deleteImage(filestoragePath: "images/\(self.userID)/avatar.jpg")
        logout()
    }
    
    func getUser(userEditingViewController: IEditUserProfileViewController) {
        let user = storageManager.loadUser(email: nil, userID: userID)
        userEditingViewController.showUserInfo(userInfo: user ?? UserViewModel(userID: "", password: "", birthDate: Date(), email: "", name: "", avatarPath: ""))
    }
}
