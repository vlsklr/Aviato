//
//  ViewController.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import UIKit

class RootViewController: UIViewController {
    private var currentViewController: UIViewController = UIViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemRed
        showLoginScreen()
     
    }
    
    func showLoginScreen() {
        let loginViewController = LoginViewController()
        addChild(loginViewController)
        loginViewController.view.frame = view.bounds
        view.addSubview(loginViewController.view)
        loginViewController.didMove(toParent: self)
        currentViewController.willMove(toParent: nil)
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParent()
        currentViewController = loginViewController
    }
    
    func switchToMainScreen(userID: UUID) {
//        let mainViewController = MainViewController()
        let router = MainRouter(userID: userID)
        let mainViewController = router.getTabBar()
        addChild(mainViewController)
        mainViewController.view.frame = view.bounds
        view.addSubview(mainViewController.view)
        mainViewController.didMove(toParent: self)
        currentViewController.willMove(toParent: nil)
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParent()
        currentViewController = mainViewController
        //       let mainScreen = UINavigationController(rootViewController: mainViewController)
    }
    
    
    
}

