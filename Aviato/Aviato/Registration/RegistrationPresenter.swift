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
        } else if let user = storageManager.loadUser(username: username, userID: nil) {
            view.showAlert(message: "Пользователь \(user.username) уже существует")
        }
        else {
            let hashedPassword = Crypto.getHash(inputString: username + password)
            let user = UserViewModel(userID: UUID(), username: username, password: hashedPassword, birthDate: birthDate, email: email, name: name, avatarPath: "")
            storageManager.addUser(user: user)
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                        if let _eror = error {
                            //something bad happning
                            print(_eror.localizedDescription )
                        }else{
                            //user registered successfully
                            print(result)
                        }
                     }
            view.dismissView()
        }
    }
}
