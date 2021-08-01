//
//  IFoundFlyghtViewController.swift
//  Aviato
//
//  Created by Vlad on 17.06.2021.
//
import Foundation

protocol IFoundFlyghtViewController: IAlert {
    func dismissFoundView()
    func showImage(imageData: Data)
}
