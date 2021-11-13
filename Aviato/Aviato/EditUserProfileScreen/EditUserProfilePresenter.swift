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
    func updateUserInfo(userInfo: UserViewModel, userAvatar: UIImage?) -> Bool
    func getUser()
    func getImage(fileName: String) -> UIImage?
}

class EditUserProfilePresenter: IEditUserProfilePresenter {

    
    let storageManager = StorageManager()
    let userID: String
    let router: EditUserProfileRouter
    weak var view: EditUserProfileViewController?
    
    init(userID: String, router: EditUserProfileRouter) {
        self.router = router
        self.userID = userID
    }
    
    func updateUserInfo(userInfo: UserViewModel, userAvatar: UIImage?) -> Bool {
        let user = UserViewModel(userID: userID, password: "", birthDate: userInfo.birthDate, email: userInfo.email, name: userInfo.name)
        if validateUserData(userInfo: userInfo) {
            if let image = userAvatar {
                let savedPath = storageManager.saveImage(image: image, fileName: "\(userID)")
                FirebaseManager.saveImage(fireStoragePath: "images/\(user.userID)/avatar.png", imagePathLocal: savedPath)
            }
            storageManager.updateUser(userID: userID, userInfo: user)
            FirebaseManager.updateUserInfo(userInfo: user)
            router.closeView()
            return true
        } else {
            view?.showAlert(message: RootViewController.labels!.userExistsError)
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
    
    func getImage(fileName: String) -> UIImage? {
        return storageManager.loadImage(fileName: fileName)
    }
    
    func removeUser() {
        if let flyghts = storageManager.getFlyghts(userID: userID) {
            for flyght in flyghts {
                FirebaseManager.removeFlyght(flyghtID: flyght.flyghtID)
                storageManager.removeFlyght(flyghtID: flyght.flyghtID)
            }
        }
        storageManager.deleteUser(userID: self.userID)
        FirebaseManager.removeUser(userID: self.userID)
        FirebaseManager.deleteImage(filestoragePath: "images/\(self.userID)/avatar.png")
        KeyChainManager.deleteUserSession()
        router.logout()
    }
        
    func getUser() {
        let user = storageManager.loadUser(email: nil, userID: userID)
        view?.showUserInfo(userInfo: user ?? UserViewModel(userID: "", password: "", birthDate: Date(), email: "", name: ""))
    }
}
