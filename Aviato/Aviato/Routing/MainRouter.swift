//
//  MainRouter.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import Foundation
import UIKit

class MainRouter {
    
    let userID: UUID
    private let tabBar: UITabBarController
    
    private let mainNavigationController: UINavigationController
    private let mainViewController: MainViewController
  
    private let flyghtListNavigationController: UINavigationController
    private let flyghtListViewController: FavoriteFlyghtListViewController
    
    
    init(userID: UUID) {
        self.userID = userID
        self.tabBar = UITabBarController()
        
        self.mainViewController = MainViewController(userID: self.userID)
        self.mainNavigationController = UINavigationController(rootViewController: self.mainViewController)
        self.mainNavigationController.tabBarItem.title = "123"
        
        self.flyghtListViewController = FavoriteFlyghtListViewController(userID: self.userID )
        self.flyghtListNavigationController = UINavigationController(rootViewController: self.flyghtListViewController)
        self.flyghtListNavigationController.tabBarItem.title = "345"
        
        self.tabBar.setViewControllers([self.mainNavigationController, self.flyghtListNavigationController], animated: true)
    }
    
    func getTabBar() -> UITabBarController {
        return self.tabBar
    }
}
