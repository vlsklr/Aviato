//
//  RegistrationPresenter.swift
//  Aviato
//
//  Created by user188734 on 7/7/21.
//

import Foundation

import FirebaseAuth
import Firebase


protocol IRegistrationPresenter {
    func registerUser(view: IRegistrationViewController, username: String, password: String, birthDate: Date, email: String, name: String)
    
}

class RegistrationPresenter: IRegistrationPresenter {
    private let storageManager: IStorageManager = StorageManager()
    
    func registerUser(view: IRegistrationViewController, username: String, password: String, birthDate: Date, email: String, name: String) {
        if email.isEmpty || password.isEmpty {
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
                    
                } else {
                    print(result?.user.uid)
                    guard let userID = result?.user.uid else {return}
                    let user = UserViewModel(userID: userID, username: username, password: hashedPassword, birthDate: birthDate, email: email, name: name, avatarPath: "")
                    self.storageManager.addUser(user: user)
                    let db = Firestore.firestore()
                    var ref: DocumentReference? = nil
                    ref = db.collection("users").addDocument(data: [
                        "userID": userID,
                        "name": name,
                        "email": email
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(ref!.documentID)")
                        }
                    }
                    
                    let currentUser = db.collection("users").whereField("userID", isEqualTo: userID)
                    
                    db.collection("users").getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                            }
                        }
                    }
                    
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
