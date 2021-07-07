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
    private let mainPresenter: IMainPresenter
    private let flyghtListNavigationController: UINavigationController
    private let flyghtListViewController: FavoriteFlyghtListViewController
    private let userProfileViewController: UserProfileViewController
    private let userProfileNavigationController: UINavigationController
    private let presenter: IPresenter
    private let userID: UUID
    
    
    init(presenter: IPresenter, userID: UUID) {
        self.presenter = presenter
        self.userID = UUID()
        self.tabBar = UITabBarController()
        tabBar.tabBar.barTintColor =  UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        self.mainPresenter = MainPresenter(userID: userID)
        self.mainViewController = MainViewController(presenter: self.mainPresenter)
        self.mainNavigationController = UINavigationController(rootViewController: self.mainViewController)
        self.mainNavigationController.tabBarItem.title = "Найти"
        
        self.flyghtListViewController = FavoriteFlyghtListViewController(presenter: self.presenter )
        self.flyghtListNavigationController = UINavigationController(rootViewController: self.flyghtListViewController)
        self.flyghtListNavigationController.tabBarItem.title = "Избранное"
        
        self.userProfileViewController = UserProfileViewController(presenter: self.presenter)
        self.userProfileNavigationController = UINavigationController(rootViewController: self.userProfileViewController)
        self.userProfileNavigationController.tabBarItem.title = "Профиль"
        
        
        
        if #available(iOS 13.0, *) {
            self.mainNavigationController.tabBarItem.image = UIImage(systemName: "airplane")
            self.flyghtListNavigationController.tabBarItem.image = UIImage(systemName: "star.fill")
            self.userProfileNavigationController.tabBarItem.image = UIImage(systemName: "person.crop.square.fill")
        } else {
        }
        
        self.tabBar.setViewControllers([self.mainNavigationController, self.flyghtListNavigationController, self.userProfileNavigationController], animated: true)
    }
    
    func getTabBar() -> UITabBarController {
        return self.tabBar
    }
}
