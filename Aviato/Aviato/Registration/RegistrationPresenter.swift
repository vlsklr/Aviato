//
//  RegistrationPresenter.swift
//  Aviato
//
//  Created by user188734 on 7/7/21.
//

import Foundation

import FirebaseAuth


protocol IRegistrationPresenter {
    func registerUser(view: IRegistrationViewController, username: String, password: String, birthDate: Date, email: String, name: String)
    
}

class RegistrationPresenter: IRegistrationPresenter {
    private let storageManager: IStorageManager = StorageManager()
    
    func registerUser(view: IRegistrationViewController, username: String, password: String, birthDate: Date, email: String, name: String) {
        if username.isEmpty || password.isEmpty {
            view.showAlert(message: "Введите данные")
        } else {
            let hashedPassword = Crypto.getHash(inputString: email + password)
            Auth.auth().createUser(withEmail: email, password: hashedPassword) { (result, error) in
                if let _eror = error as? NSError{
                    switch AuthErrorCode(rawValue: _eror.code) {
                    case .emailAlreadyInUse:
                        view.showAlert(message: "Пользователь уже существует")
                    case .weakPassword:
                        view.showAlert(message: "Пароль должен содержать более 6 символов")
                    default:
                        view.showAlert(message: "Что-то пошло не так - попробуйте позже")
                    }
                    print(_eror.localizedDescription)
                    
                }else{
                    print(result?.user.uid)
                    guard let userIDString = result?.user.uid else {return}
                    let user = UserViewModel(userID: UUID(uuidString: userIDString) ?? UUID(), username: username, password: hashedPassword, birthDate: birthDate, email: email, name: name, avatarPath: "")
                    self.storageManager.addUser(user: user)
                    view.dismissView()
                    
                }
            }
            
        }
        
    }
    
    //        else if let user = storageManager.loadUser(username: username, userID: nil) {
    //            view.showAlert(message: "Пользователь \(user.username) уже существует")
    //        }
    //        else {
    //            let hashedPassword = Crypto.getHash(inputString: username + password)
    //            let user = UserViewModel(userID: UUID(), username: username, password: hashedPassword, birthDate: birthDate, email: email, name: name, avatarPath: "")
    //            storageManager.addUser(user: user)
    //
    //            view.dismissView()
    //        }
    
}
