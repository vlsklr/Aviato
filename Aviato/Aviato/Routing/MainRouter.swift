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
        self.mainViewController = MainViewController(presenter: self.presenter)
        self.mainNavigationController = UINavigationController(rootViewController: self.mainViewController)
        self.mainNavigationController.tabBarItem.title = "123"
        self.flyghtListViewController = FavoriteFlyghtListViewController(presenter: self.presenter )
        self.flyghtListNavigationController = UINavigationController(rootViewController: self.flyghtListViewController)
        self.flyghtListNavigationController.tabBarItem.title = "345"
        self.tabBar.setViewControllers([self.mainNavigationController, self.flyghtListNavigationController], animated: true)
    }
    
    func getTabBar() -> UITabBarController {
        return self.tabBar
    }
}
