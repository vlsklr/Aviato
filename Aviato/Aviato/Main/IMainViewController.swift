//
//  IMainViewController.swift
//  Aviato
//
//  Created by Vlad on 07.07.2021.
//

import Foundation

protocol IMainViewController: IAlert {
    func toggleActivityIndicator()
    func showFoundFlyght(foundFlyghtViewController: FoundFlyghtViewController)
}
