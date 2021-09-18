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
            let hashedPassword = Crypto.getHash(inputString: username + password)
            let registerResponse = FirebaseManager.registerUser(email: email, password: hashedPassword)
            if registerResponse.0 {
                let user = UserViewModel(userID: UUID(uuidString: registerResponse.1) ?? UUID(), username: username, password: hashedPassword, birthDate: birthDate, email: email, name: name, avatarPath: "")
                storageManager.addUser(user: user)
                view.dismissView()
            } else if !registerResponse.0 && registerResponse.1.contains("The email address is already in use by another account."){
                view.showAlert(message: "Пользователь уже существует")
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
}
