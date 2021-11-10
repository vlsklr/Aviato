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
    let loginRouter: LoginRouter
    weak var view: LoginViewController?
    
    init(router: LoginRouter) {
        loginRouter = router
    }
    func authentificateUser(email: String, password: String) {
        if email.isEmpty || password.isEmpty {
            self.view?.showAlert(message: RootViewController.labels!.emptyDataError)
        } else {
            let hashedPassword = Crypto.getHash(inputString: email + password)
            FirebaseManager.authenticateUser(email: email, password: hashedPassword) { result in
                switch result {
                case .failure(let error):
                    if let _error = error as? FirebaseErrors {
                        switch _error {
                        case .userNotFound, .wrongPassword:
                            self.view?.showAlert(message: RootViewController.labels!.invalidEmailOrPasswordError)
                        case .other:
                            self.view?.showAlert(message: RootViewController.labels!.otherLoginError)
                        default:
                            self.view?.showAlert(message: RootViewController.labels!.otherLoginError)
                        }
                    }
                    
                case .success(let userID):
                    KeyChainManager.saveSessionToKeyChain(userID: userID)
                    FirebaseManager.loadUserInfo(userID: userID){ [weak self] result in
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
            
            
            
            //            let user = storageManager.loadUser(username: username, userID: nil)
            //            let hashedPassword = Crypto.getHash(inputString: username + password)
            //            if user?.username == username && user?.password == hashedPassword && user?.userID != nil {
            //                self.userID = user!.userID
            //                KeyChainManager.saveSessionToKeyChain(userID: userID)
            //                AppDelegate.shared.rootViewController.switchToMainScreen(userID: userID)
            //            }
            //            else {
            //                view.showAlert(message: "Данные неверны или такого пользователя не существует")
            //            }
        }
    }
    
    func registerUser() {
        loginRouter.showRegisterScreen()
    }
}
