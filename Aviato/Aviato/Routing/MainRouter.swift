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
    private let searchScreenViewController: SearchScreenViewController
    private let flyghtListNavigationController: UINavigationController
    private let flyghtListViewController: FavoriteFlyghtListViewController
    private let userProfileViewController: UserProfileViewController
    private let userProfileNavigationController: UINavigationController
    private let userID: String
    
    
    init(userID: String) {
        self.userID = userID
        tabBar = UITabBarController()
        tabBar.tabBar.barTintColor =  UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        
        searchScreenViewController = SearchScreenAssembly().build(userID: userID)
        mainNavigationController = UINavigationController(rootViewController: searchScreenViewController)
        mainNavigationController.tabBarItem.title = RootViewController.labels!.tabBarFind
        
        flyghtListViewController = FavoriteListAssembly().build(userID: userID)
        flyghtListNavigationController = UINavigationController(rootViewController: flyghtListViewController)
        flyghtListNavigationController.tabBarItem.title = RootViewController.labels!.tabBarFavorite
        
        userProfileViewController = UserProfileAssembly().build(userID: userID)
        userProfileNavigationController = UINavigationController(rootViewController: userProfileViewController)
        userProfileNavigationController.tabBarItem.title = RootViewController.labels!.tabBarProfile
        
        if #available(iOS 13.0, *) {
            mainNavigationController.tabBarItem.image = UIImage(systemName: "airplane")
            flyghtListNavigationController.tabBarItem.image = UIImage(systemName: "star.fill")
            userProfileNavigationController.tabBarItem.image = UIImage(systemName: "person.crop.square.fill")
        } else {
        }
        
        tabBar.setViewControllers([mainNavigationController, flyghtListNavigationController, userProfileNavigationController], animated: true)
    }
    
    func getTabBar() -> UITabBarController {
        return tabBar
    }
}
