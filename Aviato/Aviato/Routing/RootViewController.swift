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
        guard let userID = KeyChainManager.readUserSession() else {
            showLoginScreen()
            return
        }
        showMainScreen(userID: userID)


    }
    
    func showLoginScreen() {
        let loginPresenter: ILoginPresenter = LoginPresenter()
        let loginViewController = LoginViewController(presenter: loginPresenter)
        addChild(loginViewController)
        loginViewController.view.frame = view.bounds
        view.addSubview(loginViewController.view)
        loginViewController.didMove(toParent: self)
        currentViewController.willMove(toParent: nil)
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParent()
        currentViewController = loginViewController
    }
    
    func showMainScreen(userID: UUID) {
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
    }
    
    func switchToMainScreen(userID: UUID) {
        let router = MainRouter(userID: userID)
        let mainViewController = router.getTabBar()
        animateFadeTransition(to: mainViewController)
    }
    
    func switchToLogout() {
        let loginPresenter: ILoginPresenter = LoginPresenter()
        let loginViewController = LoginViewController(presenter: loginPresenter)
        let logoutScreen = UINavigationController(rootViewController: loginViewController)
        animateDismissTransition(to: logoutScreen)
    }
    
    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        let initialFrame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        currentViewController.willMove(toParent: nil)
        new.view.frame = initialFrame
        addChild(new)
        transition(from: currentViewController, to: new, duration: 1, options: [], animations: {
            new.view.frame = self.view.bounds
        }) { completed in
            self.currentViewController.removeFromParent()
            new.didMove(toParent: self)
            self.currentViewController = new
            completion?()
        }
    }
    
    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        currentViewController.willMove(toParent: nil)
        addChild(new)
        transition(from: currentViewController, to: new, duration: 0.5, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
        }) { completed in
            self.currentViewController.removeFromParent()
            new.didMove(toParent: self)
            self.currentViewController = new
            completion?()
        }
    }
    
}

