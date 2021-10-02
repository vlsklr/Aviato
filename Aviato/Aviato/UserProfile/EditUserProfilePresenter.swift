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
        var user = userInfo
        if validateUserData(userInfo: userInfo) {
            if let image = userAvatar {
                let savedPath = storageManager.saveImage(image: image, fileName: "\(userID)")
                user.avatarPath = savedPath
            }
            storageManager.updateUser(userID: userID, userInfo: user)
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
        storageManager.deleteUser(userID: self.userID)
        logout()
    }
    
    func getUser(userEditingViewController: IEditUserProfileViewController) {
        let user = storageManager.loadUser(email: nil, userID: userID)
        userEditingViewController.showUserInfo(userInfo: user ?? UserViewModel(userID: "", password: "", birthDate: Date(), email: "", name: "", avatarPath: ""))
    }
}
