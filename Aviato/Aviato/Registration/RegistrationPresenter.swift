//
//  RegistrationPresenter.swift
//  Aviato
//
//  Created by user188734 on 7/7/21.
//

import Foundation

protocol IRegistrationPresenter {
    func registerUser(view: IRegistrationViewController, password: String, birthDate: Date, email: String, name: String)
    
}

class RegistrationPresenter: IRegistrationPresenter {
    private let storageManager: IStorageManager = StorageManager()
    let firebaseManager = FirebaseManager()
    func registerUser(view: IRegistrationViewController, password: String, birthDate: Date, email: String, name: String) {
        if email.isEmpty || password.isEmpty {
            view.showAlert(message: "Введите данные")
        } else {
            let hashedPassword = Crypto.getHash(inputString: email + password)
            firebaseManager.createUser(email: email, password: hashedPassword) {[weak self] result in
                switch result {
                case .failure(let error):
                    if let _error = error as? FirebaseErrors {
                        print(error)
                        switch _error {
                        case .emailAlreadyInUse:
                            view.showAlert(message: "Пользователь уже существует")
                        case .weakPassword:
                            view.showAlert(message: "Пароль должен содержать более 6 символов")
                        case .other:
                            view.showAlert(message: "Что-то пошло не так - попробуйте позже")
                        default:
                            view.showAlert(message: "Что-то пошло не так - попробуйте позже")
                        }
                    }
                case .success(let userID):
                    print(userID)
                    let user = UserViewModel(userID: userID, password: hashedPassword, birthDate: birthDate, email: email, name: name)
                    if FirebaseManager.createUserProfile(userProfile: user){
                        self?.storageManager.addUser(user: user)
                        view.dismissView()
                    } else {
                        view.showAlert(message: "Что-то пошло не так - попробуйте позже")

                    }
                 
                    
                }
            }
            
            //                    db.collection("users").whereField("userID", isEqualTo: userID).getDocuments { QuerySnapshot, error in
            //                        if let _error = error {
            //                            print("SomethingWrong")
            //                        } else {
            //                            let user = QuerySnapshot!.documents.first
            //                            print(user)
            //                        }
            //                    }
            
            
        }
    }
}
