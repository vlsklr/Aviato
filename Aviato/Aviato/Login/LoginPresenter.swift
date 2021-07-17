//
//  LoginPresenter.swift
//  Aviato
//
//  Created by user188734 on 7/7/21.
//

import Foundation


class LoginPresenter: ILoginPresenter {
    
    let storageManager: IStorageManager = StorageManager()
    var userID: UUID = UUID()
    
    func authentificateUser(view: IAlert,username: String, password: String) {
        if username.isEmpty || password.isEmpty {
            view.showAlert(message: "Введите данные")
        }else {
            let user = storageManager.loadUser(username: username, userID: nil)
            if user?.username == username && user?.password == password && user?.userID != nil {
                self.userID = user!.userID
                KeyChainManager.saveSessionToKeyChain(userID: userID)
                AppDelegate.shared.rootViewController.switchToMainScreen(userID: userID)
            }
            else {
                view.showAlert(message: "Данные неверны или такого пользователя не существует")
            }
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
