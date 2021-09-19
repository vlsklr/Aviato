//
//  LoginPresenter.swift
//  Aviato
//
//  Created by user188734 on 7/7/21.
//

import Foundation
import FirebaseAuth

class LoginPresenter: ILoginPresenter {
    
    let storageManager: IStorageManager = StorageManager()
    var userID: UUID = UUID()
    
    func authentificateUser(view: IAlert,username: String, password: String) {
        if username.isEmpty || password.isEmpty {
            view.showAlert(message: "Введите данные")
        } else {
            let hashedPassword = Crypto.getHash(inputString: username + password)
            Auth.auth().signIn(withEmail: username, password: hashedPassword) { result, error in
                if let error = error as? NSError {
                    switch AuthErrorCode(rawValue: error.code) {
                    case .invalidEmail, .wrongPassword:
                        view.showAlert(message: "Данные неверны или такого пользователя не существует")
                        print("Error: \(error.localizedDescription)")
                    default:
                        view.showAlert(message: "Что-то пошло не так, попробуйте позже")
                    }
                } else {
                    let userInfo = Auth.auth().currentUser
                    let email = userInfo?.email
                    guard let userIDStr = userInfo?.uid else { return }
                    self.userID = UUID(uuidString: userIDStr) ?? UUID()
                    KeyChainManager.saveSessionToKeyChain(userID: self.userID)
                    AppDelegate.shared.rootViewController.switchToMainScreen(userID: self.userID)
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
