//
//  FoundFlyghtRouter.swift
//  Aviato
//
//  Created by Admin on 12.11.2021.
//

import Foundation

protocol IFoundFlyghtRouter {
    func closeViewController()
}

class FoundFlyghtRouter: IFoundFlyghtRouter {
    weak var view: IFoundFlyghtViewController?
    
    func closeViewController() {
        view?.closeView()
    }
}
