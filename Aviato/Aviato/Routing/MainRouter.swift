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
    private let flyghtListViewController: FavoriteFlightsListViewController
    private let userProfileViewController: UserProfileViewController
    private let userProfileNavigationController: UINavigationController
    private let userID: String
    
    
    init(userID: String) {
        self.userID = userID
        tabBar = UITabBarController()
        tabBar.tabBar.backgroundColor = UIColor(red: 1, green: 0.8, blue: 1, alpha: 0.1)
        tabBar.tabBar.tintColor = .white
        tabBar.tabBar.barTintColor = .white
        
        
        searchScreenViewController = SearchScreenAssembly().build(userID: userID)
        mainNavigationController = UINavigationController(rootViewController: searchScreenViewController)
        
        flyghtListViewController = FavoriteListAssembly().build(userID: userID)
        flyghtListNavigationController = UINavigationController(rootViewController: flyghtListViewController)
        
        userProfileViewController = UserProfileAssembly().build(userID: userID)
        userProfileNavigationController = UINavigationController(rootViewController: userProfileViewController)
        
        if #available(iOS 13.0, *) {
            mainNavigationController.tabBarItem.image = UIImage(named: "tabBar_search_empty")
            mainNavigationController.tabBarItem.selectedImage = UIImage(named: "tabBar_search_filled")
            mainNavigationController.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5,left: 0,bottom: -5,right: 0)
            
            flyghtListNavigationController.tabBarItem.image = UIImage(named: "tabBar_favorite_empty")
            flyghtListNavigationController.tabBarItem.selectedImage = UIImage(named: "tabBar_favorite_filled")
            flyghtListNavigationController.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5,left: 0,bottom: -5,right: 0)
            
            userProfileNavigationController.tabBarItem.image = UIImage(named: "tabBar_profile_empty")
            userProfileNavigationController.tabBarItem.selectedImage = UIImage(named: "tabBar_profile_filled")
            userProfileNavigationController.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5,left: 0,bottom: -5,right: 0)
        }
        
        tabBar.setViewControllers([flyghtListNavigationController, mainNavigationController, userProfileNavigationController], animated: true)
        tabBar.selectedIndex = 1
    }
    
    func getTabBar() -> UITabBarController {
        return tabBar
    }
}
