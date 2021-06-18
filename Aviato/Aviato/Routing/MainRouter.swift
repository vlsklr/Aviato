//
//  MainRouter.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import UIKit

class MainRouter {
    
    private let tabBar: UITabBarController
    private let mainNavigationController: UINavigationController
    private let mainViewController: MainViewController
    private let flyghtListNavigationController: UINavigationController
    private let flyghtListViewController: FavoriteFlyghtListViewController
    private let presenter: IPresenter
    
    
    init(presenter: IPresenter) {
        self.presenter = presenter
        self.tabBar = UITabBarController()
        tabBar.tabBar.barTintColor =  UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        self.mainViewController = MainViewController(presenter: self.presenter)
        self.mainNavigationController = UINavigationController(rootViewController: self.mainViewController)
        self.mainNavigationController.tabBarItem.title = "Найти"
        
        self.flyghtListViewController = FavoriteFlyghtListViewController(presenter: self.presenter )
        self.flyghtListNavigationController = UINavigationController(rootViewController: self.flyghtListViewController)
        self.flyghtListNavigationController.tabBarItem.title = "Избранное"
        
        if #available(iOS 13.0, *) {
            self.mainNavigationController.tabBarItem.image = UIImage(systemName: "airplane")
            self.flyghtListNavigationController.tabBarItem.image = UIImage(systemName: "star.fill")
        } else {
        }
        
        self.tabBar.setViewControllers([self.mainNavigationController, self.flyghtListNavigationController], animated: true)
    }
    
    func getTabBar() -> UITabBarController {
        return self.tabBar
    }
}
