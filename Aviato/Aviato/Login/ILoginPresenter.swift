//
//  ILoginPresenter.swift
//  Aviato
//
//  Created by user188734 on 7/7/21.
//

import Foundation

protocol ILoginPresenter {
    func authentificateUser(view: IAlert, username: String, password: String)
    func registerUser(view: IloginViewController)
    func logout()
}
