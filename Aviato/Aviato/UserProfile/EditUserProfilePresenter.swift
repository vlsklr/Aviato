//
//  EditUserProfilePresenter.swift
//  Aviato
//
//  Created by user188734 on 7/21/21.
//

import Foundation



protocol IEditUserProfilePresenter {
    func removeUser()
    func editUser()
}

class EditUserProfilePresenter: IEditUserProfilePresenter {
    let storageManager: IStorageManager = StorageManager()
    
    func editUser() {
        
    }
    
    
    func logout() {
        KeyChainManager.deleteUserSession()
        AppDelegate.shared.rootViewController.switchToLogout()
    }
    
    func removeUser() {
        storageManager.deleteUser(userID: self.userID)
        logout()
    }
    
    let userID: UUID

    
    init(userID: UUID) {
        self.userID = userID
    }
    
}
