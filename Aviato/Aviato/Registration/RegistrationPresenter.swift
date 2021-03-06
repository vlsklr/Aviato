//
//  RegistrationPresenter.swift
//  Aviato
//
//  Created by user188734 on 7/7/21.
//

import Foundation

protocol IRegistrationPresenter {
    func registerUser(password: String, birthDate: Date, email: String, name: String)
}

class RegistrationPresenter: IRegistrationPresenter {
    private let storageManager: IStorageManager = StorageManager()
    let firebaseManager = FirebaseManager()
    let router: IRegistrationRouter
    weak var view: IRegistrationViewController?
    
    init(router: RegistrationRouter) {
        self.router = router
    }
    
    func registerUser(password: String, birthDate: Date, email: String, name: String) {
        if email.isEmpty || password.isEmpty {
            self.view?.alertController.showAlert(message: RootViewController.labels!.emptyDataError)
        } else {
            let hashedPassword = Crypto.getHash(inputString: email + password)
            firebaseManager.createUser(email: email, password: hashedPassword) {[weak self] result in
                switch result {
                case .failure(let error):
                    if let _error = error as? FirebaseErrors {
                        print(error)
                        switch _error {
                        case .emailAlreadyInUse:
                            self?.view?.alertController.showAlert(message: RootViewController.labels!.userExistsError)
                        case .weakPassword:
                            self?.view?.alertController.showAlert(message: RootViewController.labels!.shortPasswordError)
                        case .other:
                            self?.view?.alertController.showAlert(message: RootViewController.labels!.otherLoginError)
                        default:
                            self?.view?.alertController.showAlert(message: RootViewController.labels!.otherLoginError)
                        }
                    }
                case .success(let userID):
                    print(userID)
                    let user = UserViewModel(userID: userID, password: hashedPassword, birthDate: birthDate, email: email, name: name)
                    if FirebaseManager.createUserProfile(userProfile: user) {
                        self?.storageManager.addUser(user: user)
                        self?.router.returnToLoginScreen()
                    } else {
                        self?.view?.alertController.showAlert(message: RootViewController.labels!.otherLoginError)
                    }
                }
            }
        }
    }
}
