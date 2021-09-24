//
//  FirebaseManager.swift
//  Aviato
//
//  Created by Admin on 18.09.2021.
//

import Foundation
import FirebaseAuth
import Firebase

final class FirebaseManager {
    private let db = Firestore.firestore()
    private var ref: DocumentReference? = nil

   static func authenticateUser(email: String, password: String, completion: @escaping(Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error as? NSError {
                switch AuthErrorCode(rawValue: error.code) {
                case .invalidEmail:
                    completion(.failure(FirebaseErrors.invalidEmail))
                case .wrongPassword:
                    completion(.failure(FirebaseErrors.wrongPassword))
                    print("Error: \(error.localizedDescription)")
                default:
                    completion(.failure(FirebaseErrors.other))
                    break
//                    view.showAlert(message: "Что-то пошло не так, попробуйте позже")
                }
            } else {
                let userInfo = Auth.auth().currentUser
                guard let userID = userInfo?.uid else { return }
                completion(.success(userID))
                
//                KeyChainManager.saveSessionToKeyChain(userID: userID)
//                AppDelegate.shared.rootViewController.switchToMainScreen(userID: userID)
            }
        }
    }
    
    func createUser(email: String, password: String, completion: @escaping (Result<String, NSError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let _eror = error as? NSError {
                completion(.failure(_eror))
            } else {
                guard let userID = result?.user.uid else {return}
                completion(.success(userID))
            }
        }
    }
    
    func createUserProfile(userProfile: UserViewModel) -> Bool {
        ref = db.collection("users").addDocument(data: [
                    "userID": userProfile.userID,
                    "name": userProfile.name,
                    "email": userProfile.email
                ])
        if ref?.documentID != nil {
            return true
        }
        return false
    }
}

//        db.collection("users").whereField("userID", isEqualTo: userID).getDocuments { QuerySnapshot, error in
//            if let _error = error {
//                print("SomethingWrong")
//            } else {
//                let user = QuerySnapshot!.documents.first
//                print(user)
//            }
//        }
