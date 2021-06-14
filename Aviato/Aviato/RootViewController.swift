//
//  ViewController.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import UIKit

class RootViewController: UIViewController {
    private var currentViewController: UIViewController
    
    init() {
        self.currentViewController = LoginViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemRed
        // Do any additional setup after loading the view.
        
        addChild(currentViewController)
        currentViewController.view.frame = view.bounds
        view.addSubview(currentViewController.view)
        currentViewController.didMove(toParent: self)
        
    }
    
    
    
}

