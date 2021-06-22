//
//  ViewController.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import UIKit

class RootViewController: UIViewController {
    private var currentViewController: UIViewController = UIViewController()
    private var presenter: IPresenter = Presenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoginScreen()
    }
    
    func showLoginScreen() {
        let loginViewController = LoginViewController(presenter: presenter)
        addChild(loginViewController)
        loginViewController.view.frame = view.bounds
        view.addSubview(loginViewController.view)
        loginViewController.didMove(toParent: self)
        currentViewController.willMove(toParent: nil)
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParent()
        currentViewController = loginViewController
    }
    
    func switchToMainScreen() {
        let router = MainRouter(presenter: presenter)
        let mainViewController = router.getTabBar()
        animateFadeTransition(to: mainViewController)
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

