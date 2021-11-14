//
//  FoundFlyghtRouter.swift
//  Aviato
//
//  Created by Admin on 12.11.2021.
//

import Foundation

class FoundFlyghtRouter {
    weak var view: FoundFlyghtViewController?
    
    func closeViewController() {
        view?.dismiss(animated: true, completion: nil)
    }
}
