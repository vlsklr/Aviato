//
//  EditUserProfilePresenter.swift
//  Aviato
//
//  Created by user188734 on 7/21/21.
//

import Foundation



protocol IEditUserProfilePresenter {
    func removeUser()
    func updateUserInfo(userInfo: UserViewModel)
    func getUser(userEditingViewController: IEditUserProfileViewController)
}

class EditUserProfilePresenter: UserProfilePresenter, IEditUserProfilePresenter {
    
    func updateUserInfo(userInfo: UserViewModel) {
        storageManager.updateUser(userID: userID, userInfo: userInfo)
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
