//
//  IAlert.swift
//  Aviato
//
//  Created by user188734 on 6/17/21.
//
import UIKit

protocol IAlert {
    var view: UIViewController? { get set }
    func showAlert(message: String)
}

class AlertController: IAlert {
    weak var view: UIViewController?
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: RootViewController.labels!.error, message: message, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "ОК", style: .default))
                DispatchQueue.main.async {
                    self.view?.present(alert, animated: true)
                }
    }
}
