//
//  FirebaseManager.swift
//  Aviato
//
//  Created by Admin on 18.09.2021.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseStorage


struct FirebaseUser: Decodable {
    let name: String
    let userID: String
    let email: String
}

final class FirebaseManager {
    private static let firestoreDatabase = Firestore.firestore()
    private static var databaseReference: DocumentReference? = nil
    private static let storage = Storage.storage()
    private static var storageReference: StorageReference? = nil
    
    static func authenticateUser(email: String, password: String, completion: @escaping(Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error as NSError?,
               let authError = AuthErrorCode.Code.init(rawValue: error.code) {
                switch authError {
                case .userNotFound:
                    completion(.failure(FirebaseErrors.userNotFound))
                case .wrongPassword:
                    completion(.failure(FirebaseErrors.wrongPassword))
                    print("Error: \(error.localizedDescription)")
                default:
                    completion(.failure(FirebaseErrors.other))
                    break
                }
            } else {
                let userInfo = Auth.auth().currentUser
                guard let userID = userInfo?.uid else { return }
                completion(.success(userID))
            }
        }
    }
    
    func createUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let _error = error as NSError?,
               let authError = AuthErrorCode.Code.init(rawValue: _error.code) {
                switch authError {
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
    
    static func saveImage(fireStoragePath: String, imagePathLocal: String) {
        guard let localPath = URL(string: imagePathLocal) else {return}
        storageReference = storage.reference()
        let imageReference = storageReference?.child(fireStoragePath)
        imageReference?.putFile(from: localPath, metadata: nil, completion: { metadata, error in
            guard let metadata = metadata else { return }
            print(metadata.size)
        })
        
    }
    
    static func loadImage(filestoragePath: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        storageReference = storage.reference()
        let pictureReference = storageReference?.child(filestoragePath)
        pictureReference?.getData(maxSize: 20 * 1024 * 1024, completion: { (data, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(data))
            }
        })
    }
    
    static func deleteImage(filestoragePath: String) {
        storageReference = storage.reference()
        let userFolderReference = storageReference?.child(filestoragePath)
        userFolderReference?.delete(completion: { error in
            if let error = error {
                print(error)
            }
        })
    }
    
    static func createUserProfile(userProfile: UserViewModel) -> Bool {
        databaseReference = firestoreDatabase.collection("users").addDocument(data: [
            "userID": userProfile.userID,
            "name": userProfile.name,
            "email": userProfile.email,
            "birthDate": userProfile.birthDate
        ])
        if databaseReference?.documentID != nil {
            return true
        }
        return false
    }
    
    static func saveFlyght(flyghtInfo: FlyghtInfoDataModel) -> String?{
        databaseReference = firestoreDatabase.collection(flyghtInfo.holder).addDocument(data: [
            "flyghtNumber" : flyghtInfo.flyghtNumber,
            "departureAirport" : flyghtInfo.departureAirport,
            "arrivalAirport" : flyghtInfo.arrivalAirport,
            "departureCity": flyghtInfo.departureCity,
            "arrivalCity": flyghtInfo.arrivalCity,
            "departureDate" : flyghtInfo.departureDate,
            "arrivalDate" : flyghtInfo.arrivalDate,
            "aircraft" : flyghtInfo.aircraft,
            "airline" : flyghtInfo.airline,
            "status" : flyghtInfo.status.rawValue
        ])
        
        if let flyghtID = databaseReference?.documentID {
            return flyghtID
        }
        return nil
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
    
    static func loadFlyghts(userID: String, completion: @escaping (Result<[FlyghtInfoDataModel], Error>) -> Void) {
        firestoreDatabase.collection(userID).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let snapshotDocuments = snapshot?.documents else {
                    completion(.failure(FirebaseErrors.other))
                    return
                }
                var flyghts = [FlyghtInfoDataModel]()
                
                for flyghtDocument in snapshotDocuments {
                    var flyght = FlyghtInfoDataModel(holder: userID,
                                                     flyghtID: flyghtDocument.documentID,
                                                     flyghtNumber: "",
                                                     departureAirport: "",
                                                     arrivalAirport: "",
                                                     departureDate: Date(),
                                                     arrivalDate: Date(),
                                                     aircraft: "",
                                                     airline: "",
                                                     status: .unknown,
                                                     departureCity: "",
                                                     arrivalCity: "")
                    
                    for element in flyghtDocument.data() {
                        switch element.key {
                        case "aircraft":
                            flyght.aircraft = element.value as? String ?? ""
                        case "flyghtNumber":
                            flyght.flyghtNumber = element.value as? String ?? ""
                        case "departureAirport":
                            flyght.departureAirport = element.value as? String ?? ""
                        case "arrivalAirport":
                            flyght.arrivalAirport = element.value as? String ?? ""
                        case "departureDate":
                            let rawDate = element.value as? Timestamp
                            flyght.departureDate = rawDate?.dateValue() ?? Date()
                        case "arrivalDate":
                            let rawDate = element.value as? Timestamp
                            flyght.arrivalDate = rawDate?.dateValue() ?? Date()
                        case "airline":
                            flyght.airline = element.value as? String ?? ""
                        case "status":
                            flyght.status = FlightStatus(rawValue: element.value as? String ?? "") ?? .unknown
                        case "departureCity":
                            flyght.departureCity = element.value as? String ?? ""
                        case "arrivalCity":
                            flyght.arrivalCity = element.value as? String ?? ""
                        default:
                            print("Something other data \(element.value as? String)")
                        }
                    }
                    flyghts.append(flyght)
                }
                completion(.success(flyghts))
            }
        }
        
    }
    
    static func validateUserProfileChanges(email: String, completion: @escaping (Bool) -> Void) {
        let userID = getCurrentUserID()
        firestoreDatabase.collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if error != nil {
                completion(false)
            }
            guard let userInfo = snapshot?.documents.first else {
                completion(true)
                return
            }
            
            let uid = userInfo.data()["userID"] as! String
            if userID == uid {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    static func loadUserInfo(userID: String, completion: @escaping (Result<UserViewModel, Error>) -> Void) {
        let userID: String = userID
        var birthDate: Date?
        var email: String?
        var name: String?
        firestoreDatabase.collection("users").whereField("userID", isEqualTo: userID).getDocuments { QuerySnapshot, error in
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
                let user = UserViewModel(userID: userID, password: "", birthDate: birthDate ?? Date(), email: email ?? "WrongData", name: name ?? "WrongData")
                completion(.success(user))
            }
        }
    }
    
    static func updateUserInfo(userInfo: UserViewModel) {
        firestoreDatabase.collection("users").whereField("userID", isEqualTo: userInfo.userID).getDocuments { snapshot, error in
            if let error = error {
                print(error)
            } else {
                let document = snapshot?.documents.first
                document?.reference.updateData(["name" : userInfo.name, "birthDate" : userInfo.birthDate, "email" : userInfo.email])
                Auth.auth().currentUser?.updateEmail(to: userInfo.email) { error in
                }
            }
        }
    }
    
    static func removeUser(userID: String) {
        Auth.auth().currentUser?.delete(completion: { error in
            if let error = error {
                print("Что-то пошло не так при удалении аккаунта \(error)")
            } else {
                print("Аккаунт успешно удален")
                firestoreDatabase.collection("users").whereField("userID", isEqualTo: userID).getDocuments { snapshot, error in
                    snapshot?.documents.first?.reference.delete()
                }
            }
        })
        
    }
    
    static func removeFlyght(flyghtID: String) {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        deleteImage(filestoragePath: "images/\(userID)/\(flyghtID).png")
        firestoreDatabase.collection(userID).document(flyghtID).delete()
    }
    
    static func updateFlyghtInfo(flyght: FlyghtInfoDataModel) {
        firestoreDatabase.collection(flyght.holder).document(flyght.flyghtID).updateData(
            [
                "departureAirport": flyght.departureAirport,
                "departureCity": flyght.departureCity,
                "arrivalCity": flyght.arrivalCity,
                "arrivalAirport": flyght.arrivalAirport,
                "departureDate": flyght.departureDate,
                "arrivalDate": flyght.arrivalDate,
                "aircraft": flyght.aircraft,
                "status": flyght.status.rawValue
            ]
        )
    }
    
    static func loadLabels(completion: @escaping (Result<Labels, Error>) -> Void) {
        let locale = NSLocale.preferredLanguages.first
        let countryCode = locale?.contains("ru") ?? false ? "RU" : "EN"
        firestoreDatabase.collection("labels").document(countryCode).getDocument { snaphot, error in
            guard let snapshotData = snaphot?.data(), JSONSerialization.isValidJSONObject(snapshotData) else {
                completion(.failure(FirebaseErrors.other))
                return
            }
            do {
                let data = try JSONSerialization.data(withJSONObject: snapshotData)
                let labels = try JSONDecoder().decode(Labels.self, from: data)
                completion(.success(labels))
                print(labels)
            } catch let error {
                print(error)
                completion(.failure(error))
            }
        }
    }
}
