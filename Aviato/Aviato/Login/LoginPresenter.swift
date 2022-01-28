//
//  LoginPresenter.swift
//  Aviato
//
//  Created by user188734 on 7/7/21.
//

import Foundation
import UIKit

protocol ILoginPresenter {
    func authentificateUser(email: String, password: String)
    func registerUser()
}

class LoginPresenter: ILoginPresenter {
    let storageManager: IStorageManager = StorageManager()
    let loginRouter: ILoginRouter
    weak var view: ILoginViewController?
    
    init(router: LoginRouter) {
        loginRouter = router
    }
    func authentificateUser(email: String, password: String) {
        if email.isEmpty || password.isEmpty {
            self.view?.alertController.showAlert(message: RootViewController.labels!.emptyDataError)
        } else {
            let hashedPassword = Crypto.getHash(inputString: email + password)
            FirebaseManager.authenticateUser(email: email, password: hashedPassword) { [weak self] result in
                switch result {
                case .failure(let error):
                    if let _error = error as? FirebaseErrors {
                        switch _error {
                        case .userNotFound, .wrongPassword:
                            self?.view?.alertController.showAlert(message: RootViewController.labels!.invalidEmailOrPasswordError)
                        case .other:
                            self?.view?.alertController.showAlert(message: RootViewController.labels!.otherLoginError)
                        default:
                            self?.view?.alertController.showAlert(message: RootViewController.labels!.otherLoginError)
                        }
                    }
                    
                case .success(let userID):
                    KeyChainManager.saveSessionToKeyChain(userID: userID)
                    FirebaseManager.loadUserInfo(userID: userID){ result in
                        switch result {
                        case .success(let user):
                            let userID = user.userID
                            FirebaseManager.loadImage(filestoragePath: "images/\(userID)/avatar.png"){ [self] result in
                                switch result {
                                case .failure(let error):
                                    print(error)
                                case .success(let data):
                                    guard let data = data, let image = UIImage(data: data) else {
                                        return
                                    }
                                    self?.storageManager.saveImage(image: image, fileName: "\(user.userID)")
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object:nil, userInfo: nil)
                                }
                            }
                            self?.storageManager.addUser(user: user)
                            self?.loginRouter.switchToMainScreen(userID: userID)
                            FirebaseManager.loadFlyghts(userID: userID) { [self] result in
                                switch result {
                                case .failure(let error):
                                    print(error)
                                case .success(let flyghts):
                                    print("LOADED")
                                    for flyght in flyghts {
                                        self?.storageManager.addFlyght(flyght: flyght)
                                    }
                                }
                            }
                        case .failure(let error):
                            print("При загрузке данных что-то пошло не так \(error)")
                        }
                    }
                    
                }
            }
        }
    }
    
    func registerUser() {
        loginRouter.showRegisterScreen()
    }
}
