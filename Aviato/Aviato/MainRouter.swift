//
//  MainRouter.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import Foundation
import UIKit

class MainRouter {
    
    private let tabBar: UITabBarController
    private let mainNavigationController: UINavigationController
    private let mainViewController: MainViewController
  
    
    private let flyghtListNavigationController: UINavigationController
    private let flyghtListViewController: FavoriteFlyghtListViewController
    
    init() {
        self.tabBar = UITabBarController()
        
        self.mainViewController = MainViewController()
        self.mainNavigationController = UINavigationController(rootViewController: self.mainViewController)
        self.mainNavigationController.tabBarItem.title = "123"
        
        self.flyghtListViewController = FavoriteFlyghtListViewController()
        self.flyghtListNavigationController = UINavigationController(rootViewController: self.flyghtListViewController)
        self.flyghtListNavigationController.tabBarItem.title = "345"
        
        self.tabBar.setViewControllers([self.mainNavigationController, self.flyghtListNavigationController], animated: true)
    }
    
    func getTabBar() -> UITabBarController {
        return self.tabBar
    }
}
