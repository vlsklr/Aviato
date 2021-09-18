//
//  FirebaseManager.swift
//  Aviato
//
//  Created by Admin on 18.09.2021.
//

import Foundation
import FirebaseAuth

final class FirebaseManager {
    
    static func registerUser(email: String, password: String) -> (Bool, String) {
        var success: Bool = false
        var message: String = ""
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let _eror = error {
                //something bad happning
                print(_eror.localizedDescription)
//                print(_eror.asAFError?.failureReason)
                success = false
                message = _eror.localizedDescription
            }else{
                //user registered successfully
                print(result?.user.uid)
                success = true
                message = result?.user.uid ?? ""
            }
        }
        
        return (success, message)
    }
}
