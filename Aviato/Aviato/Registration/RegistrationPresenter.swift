//
//  RegistrationPresenter.swift
//  Aviato
//
//  Created by user188734 on 7/7/21.
//

import Foundation

protocol IRegistrationPresenter {
    func registerUser(view: IRegistrationViewController, username: String, password: String)
    
}

class RegistrationPresenter: IRegistrationPresenter {
    private let storageManager: IStorageManager = StorageManager()
    
    func registerUser(view: IRegistrationViewController, username: String, password: String) {
        if username.isEmpty || password.isEmpty {
            view.showAlert(message: "Введите данные")
        } else if let user = storageManager.loadUser(username: username, userID: nil) {
            view.showAlert(message: "Пользователь \(user.username) уже существует")
        }
        else {
            let user = UserViewModel(userID: UUID(), username: username, password: password)
            storageManager.addUser(user: user)
            view.dismissView()
        }
    }
}