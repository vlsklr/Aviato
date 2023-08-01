//
//  Labels.swift
//  Aviato
//
//  Created by Admin on 31.10.2021.
//

import Foundation


struct Labels: Decodable {
    let loginScreenTitle: String
    let loginScreenSubtitle: String
    let forgetPassword: String
    let loginMethodsTitle: String
    let registerMethodsTitle: String
    let loginButtonRegular: String
    let loginButtonBold: String
    let emailField: String
    let passwordField: String
    let loginButton: String
    let createAccountButtonRegular: String?
    let createAccountButtonBold: String?
    let userNameField: String
    let registerButton: String
    let birthDateField: String
    let searchScreenTitle: String
    let searchBarPlaceholder: String
    let searchHistoryButtonTitle: String
    let findFlyghtButton: String
    let favoriteCellFlyghtNumber: String
    let favoriteCellDepartureDate: String
    let deleteFlyghtButton: String
    let editUserProfileButton: String
    let logoutButton: String
    let calncelButton: String
    let saveButton: String
    let deleteUserButton: String
    
    let addToFavorite: String
    let removeFromFavorite: String
    let flyghtNumber: String
    let flyghtStatus: String
    let departureAirport: String
    let departureTimeUTC: String
    let departureTimeLocal: String
    let arriveAirport: String
    let arriveTimeUTC: String
    let arriveTimeLocal: String
    let aircraft: String
    let enroute: String
    let departureTitle: String
    let arrivalTitle: String
    
    let emptyDataError: String
    let invalidEmailOrPasswordError: String
    let otherLoginError: String
    
    let camera: String
    let gallery: String
    let error: String
    let errorDuringUpdateFlyghtInfo: String
    let userExistsError: String
    let flyghtAlreadyExists: String
    let flyghtNotFound: String
    
    let shortPasswordError: String
}
