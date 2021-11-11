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
//    private let searchScreenPresenter: ISearchScreenPresenter
    private let flyghtsListPresenter: IFavoriteFlyghtListPresenter
    private let flyghtListNavigationController: UINavigationController
    private let flyghtListViewController: FavoriteFlyghtListViewController
    private let userProfileViewController: UserProfileViewController
    private let userProfileNavigationController: UINavigationController
    private let userProfilePresenter: IUserProfilePresenter
    private let userID: String
    
    
    init(userID: String) {
        self.userID = userID
        self.tabBar = UITabBarController()
        tabBar.tabBar.barTintColor =  UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        
//        self.searchScreenPresenter = SearchScreenPresenter(userID: userID)
        self.searchScreenViewController = SearchScreenAssembly().build(userID: userID)
        self.mainNavigationController = UINavigationController(rootViewController: self.searchScreenViewController)
        self.mainNavigationController.tabBarItem.title = RootViewController.labels!.tabBarFind
        
        self.flyghtsListPresenter = FavoriteFlyghtListPresenter(userID: userID)
        self.flyghtListViewController = FavoriteFlyghtListViewController(presenter: self.flyghtsListPresenter)
        self.flyghtListNavigationController = UINavigationController(rootViewController: self.flyghtListViewController)
        self.flyghtListNavigationController.tabBarItem.title = RootViewController.labels!.tabBarFavorite
        
        self.userProfilePresenter = UserProfilePresenter(userID: userID)
        self.userProfileViewController = UserProfileViewController(presenter: self.userProfilePresenter)
        self.userProfileNavigationController = UINavigationController(rootViewController: self.userProfileViewController)
        self.userProfileNavigationController.tabBarItem.title = RootViewController.labels!.tabBarProfile
        
        
        
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
