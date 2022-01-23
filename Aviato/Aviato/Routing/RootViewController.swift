//
//  ViewController.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import UIKit

class RootViewController: UIViewController {
    private var currentViewController: UIViewController = UIViewController()
    static var labels: Labels?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseManager.loadLabels { [unowned self] result in
            switch result {
            case .success(let loadedLabels):
                RootViewController.labels = loadedLabels
                guard let userID = KeyChainManager.readUserSession(), let firebaseUserID = FirebaseManager.getCurrentUserID() else {
                    self.showLoginScreen()
                    return
                }
                if userID == firebaseUserID {
                    self.showMainScreen(userID: userID)
                } else {
                    KeyChainManager.deleteUserSession()
                    FirebaseManager.logout()
                    self.showLoginScreen()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func showLoginScreen() {
        let loginViewController = LoginAssembly().build()
        addChild(loginViewController)
        loginViewController.view.frame = view.bounds
        view.addSubview(loginViewController.view)
        loginViewController.didMove(toParent: self)
        currentViewController.willMove(toParent: nil)
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParent()
        currentViewController = loginViewController
    }
    
    func showMainScreen(userID: String) {
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
    
    func switchToMainScreen(userID: String) {
        let router = MainRouter(userID: userID)
        let mainViewController = router.getTabBar()
        animateFadeTransition(to: mainViewController)
    }
    
    func switchToLogout() {
        let loginViewController = LoginAssembly().build()
        let logoutScreen = UINavigationController(rootViewController: loginViewController)
        animateDismissTransition(to: logoutScreen)
    }
    
    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        let initialFrame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        currentViewController.willMove(toParent: nil)
        new.view.frame = initialFrame
        addChild(new)
        transition(from: currentViewController, to: new, duration: 1, options: [], animations: { [unowned self] in
            new.view.frame = self.view.bounds
        }) { [unowned self] completed in
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
        }) {[unowned self] completed in
            self.currentViewController.removeFromParent()
            new.didMove(toParent: self)
            self.currentViewController = new
            completion?()
        }
    }
}

