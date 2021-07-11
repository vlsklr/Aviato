//
//  IMainPresenter.swift
//  Aviato
//
//  Created by Vlad on 07.07.2021.
//

import Foundation


protocol IMainPresenter {
    func findFlyghtInfo(view: IMainViewController, flyghtNumber: String)
}
