//
//  FirebaseManager.swift
//  Aviato
//
//  Created by Admin on 18.09.2021.
//

import Foundation
import FirebaseAuth
import Firebase


struct FirebaseUser: Decodable {
    let name: String
    let userID: String
    let email: String
}

final class FirebaseManager {
    private static let db = Firestore.firestore()
    private static var ref: DocumentReference? = nil
    
    static func authenticateUser(email: String, password: String, completion: @escaping(Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error as NSError? {
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
    
     func createUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let _error = error as NSError? {
                switch AuthErrorCode(rawValue: _error.code) {
                case .emailAlreadyInUse:
                    completion(.failure(FirebaseErrors.emailAlreadyInUse))
                case .weakPassword:
                    completion(.failure(FirebaseErrors.weakPassword))
                default:
                    completion(.failure(FirebaseErrors.other))
                }
            } else {
                guard let userID = result?.user.uid else {return}
                completion(.success(userID))
            }
        }
    }
    
    static func createUserProfile(userProfile: UserViewModel) -> Bool {
        ref = db.collection("users").addDocument(data: [
            "userID": userProfile.userID,
            "name": userProfile.name,
            "email": userProfile.email,
            "birthDate": userProfile.birthDate
        ])
        if ref?.documentID != nil {
            return true
        }
        return false
    }
    
    static func logout() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("При выходе что-то пошло не так \(signOutError)")
        }
    }
    
    static func getCurrentUserID() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
   static func loadUserInfo(userID: String, completion: @escaping (Result<UserViewModel, Error>) -> Void) {
    let userID: String = userID
    var birthDate: Date?
    var email: String?
    var name: String?
//    var avatarPath: String
        db.collection("users").whereField("userID", isEqualTo: userID).getDocuments { QuerySnapshot, error in
            if let _error = error {
                completion(.failure(_error))
                print("SomethingWrong")
            } else {
                guard let userInfo = QuerySnapshot?.documents.first else {return}
                for element in userInfo.data() {
                    switch element.key {
                    case "email":
                        print("EMAIL: \(element.value)")
                        email = element.value as? String
                    case "name":
                        print("NAME: \(element.value)")
                        name = element.value as? String
                    case "birthDate":
                        print("BIRTHDATE: \(element.value)")
                        let birthTimeStamp = element.value as? Timestamp
                        birthDate = birthTimeStamp?.dateValue()
                    default:
                        print("OTHER DATA \(element.value)")
                    }
                }
                let user = UserViewModel(userID: userID, password: "", birthDate: birthDate ?? Date(), email: email ?? "WrongData", name: name ?? "WrongData", avatarPath: "")
                completion(.success(user))
            }
        }
    }
    
    static func updateUserInfo(userInfo: UserViewModel) {
                               //, completion: @escaping (Result<UserViewModel, Error>) -> Void) {
        let entityReference = db.collection("users").document(userInfo.userID)
        entityReference.updateData(["name" : userInfo.name])
        
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
