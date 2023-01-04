//
//  UIViewController.swift
//  Aviato
//
//  Created by v.sklyarov on 03.01.2023.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: RootViewController.labels!.error, message: message, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "ОК", style: .default))
        self.present(alert, animated: true)
    }
    
}
