//
//  EditUserProfilePresenter.swift
//  Aviato
//
//  Created by user188734 on 7/21/21.
//

import Foundation
import UIKit

protocol IEditUserProfilePresenter: AnyObject {
    func removeUser()
    func updateUserInfo(userInfo: UserViewModel, userAvatar: UIImage?)
    func getUser()
    func getImage(fileName: String) -> UIImage?
}

class EditUserProfilePresenter: IEditUserProfilePresenter {

    
    let storageManager = StorageManager()
    let userID: String
    let router: IEditUserProfileRouter
    weak var view: IEditUserProfileViewController?
    
    init(userID: String, router: EditUserProfileRouter) {
        self.router = router
        self.userID = userID
    }
    
    func updateUserInfo(userInfo: UserViewModel, userAvatar: UIImage?) {
        let user = UserViewModel(userID: userID, password: "", birthDate: userInfo.birthDate, email: userInfo.email, name: userInfo.name)
        FirebaseManager.validateUserProfileChanges(email: user.email) { [unowned self] result in
            if result == true {
                if let image = userAvatar {
                    let savedPath = self.storageManager.saveImage(image: image, fileName: "\(self.userID)")
                    FirebaseManager.saveImage(fireStoragePath: "images/\(user.userID)/avatar.png", imagePathLocal: savedPath)
                }
                self.storageManager.updateUser(userID: self.userID, userInfo: user)
                FirebaseManager.updateUserInfo(userInfo: user)
                self.router.closeView()
            } else {
                self.view?.alertController.showAlert(message: RootViewController.labels!.userExistsError)
            }
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
