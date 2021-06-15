//
//  FavoriteFlyghtListViewController.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import UIKit
import SnapKit

class FavoriteFlyghtListViewController: UIViewController {
    
    let flyghtNumberLaber: UILabel = UILabel()
    let saveButton: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
        setupLabel()
        setupButton()
        // Do any additional setup after loading the view.
    }
    
    
    func setupLabel() {
        self.view.addSubview(flyghtNumberLaber)
        flyghtNumberLaber.text = "1488"
        flyghtNumberLaber.backgroundColor = .white
        flyghtNumberLaber.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(150)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    
    func setupButton() {
        self.view.addSubview(saveButton)
        flyghtNumberLaber.text = "Save"
        flyghtNumberLaber.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.trailing.equalToSuperview().offset(16)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
    }
}
