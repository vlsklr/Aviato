//
//  FirebaseErrors.swift
//  Aviato
//
//  Created by Admin on 24.09.2021.
//

import Foundation

enum FirebaseErrors: Error {
    case emailAlreadyInUse
    case weakPassword
    case invalidEmail
    case wrongPassword
    case other
}
