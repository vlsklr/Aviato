//
//  EditUserProfilePresenter.swift
//  Aviato
//
//  Created by user188734 on 7/21/21.
//

import Foundation



protocol IEditUserProfilePresenter {
    func removeUser()
    func updateUserInfo(view: IEditUserProfileViewController,userInfo: UserViewModel) -> Bool
    func getUser(userEditingViewController: IEditUserProfileViewController)
}

class EditUserProfilePresenter: UserProfilePresenter, IEditUserProfilePresenter {
    
    func updateUserInfo(view: IEditUserProfileViewController,userInfo: UserViewModel) -> Bool {
        if validateUserData(userInfo: userInfo) {
            storageManager.updateUser(userID: userID, userInfo: userInfo)
            return true
        } else {
            view.showAlert(message: "Такой пользователь уже существует")
            return false
            
//            print("Такой пользователь уже существует")
        }
    }
    
    //Возвращает true, если имя пользователя не занято или не изменяется
    private func validateUserData(userInfo: UserViewModel) -> Bool {
        guard let user = storageManager.loadUser(username: userInfo.username, userID: nil) else { return true }
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
        let user = storageManager.loadUser(username: nil, userID: userID)
        userEditingViewController.showUserInfo(userInfo: user ?? UserViewModel(userID: UUID(), username: "", password: "", birthDate: Date(), email: "", name: ""))
    }
    
}
