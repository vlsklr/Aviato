//
//  LoginPresenter.swift
//  Aviato
//
//  Created by user188734 on 7/7/21.
//

import Foundation
import UIKit

class LoginPresenter: ILoginPresenter {
    
    let storageManager: IStorageManager = StorageManager()
    //    var userID: String = ""
    func authentificateUser(view: IAlert,email: String, password: String) {
        if email.isEmpty || password.isEmpty {
            view.showAlert(message: "Введите данные")
        } else {
            let hashedPassword = Crypto.getHash(inputString: email + password)
            FirebaseManager.authenticateUser(email: email, password: hashedPassword) { result in
                switch result {
                case .failure(let error):
                    if let _error = error as? FirebaseErrors {
                        switch _error {
                        case .invalidEmail, .wrongPassword:
                            view.showAlert(message: "Email или пароль неправильный")
                        case .other:
                            view.showAlert(message: "Что-то пошло не так - попробуйте позже")
                        default:
                            view.showAlert(message: "Что-то пошло не так - попробуйте позже")
                        }
                    }
                    
                case .success(let userID):
                    KeyChainManager.saveSessionToKeyChain(userID: userID)
                    FirebaseManager.loadUserInfo(userID: userID){ [weak self] result in
                        switch result {
                        case .success(var user):
                            let userID = user.userID
                            FirebaseManager.loadImage(filestoragePath: "images/\(userID)/avatar.jpg"){ [self] result in
                                switch result {
                                case .failure(let error):
                                    print(error)
                                case .success(let data):
                                    guard let data = data, let image = UIImage(data: data) else {
                                        return
                                    }
                                    if let imagePath = self?.storageManager.saveImage(image: image, fileName: "\(user.userID)") {
                                        user.avatarPath = imagePath
                                        self?.storageManager.updateUser(userID: user.userID, userInfo: user)
//                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object:nil, userInfo: nil)

                                    }
                                }
                            }
                            self?.storageManager.addUser(user: user)
                            AppDelegate.shared.rootViewController.switchToMainScreen(userID: userID)
	
                            
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
    
    // Метод создает экземпляр ViewController экрана регистрации и говорит вызвавшему ViewController отобразить этот ViewController
    func registerUser(view: IloginViewController) {
        let registrationPresenter: IRegistrationPresenter = RegistrationPresenter()
        let registrationViewController = RegistrationViewController(presenter: registrationPresenter)
        DispatchQueue.main.async {
            view.presentRegisterViewController(view: registrationViewController)
        }
    }
    
    func logout() {
        AppDelegate.shared.rootViewController.showLoginScreen()
    }
}
