//
//  IFoundFlyghtViewController.swift
//  Aviato
//
//  Created by Vlad on 17.06.2021.
//


protocol IFoundFlyghtViewController: IAlert {
    func showFoundFlyght(flyghtViewInfo: FlyghtViewModel)
}
