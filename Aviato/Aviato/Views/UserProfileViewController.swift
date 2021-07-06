//
//  UserProfileViewController.swift
//  Aviato
//
//  Created by user188734 on 7/6/21.
//

import UIKit
import SnapKit

class UserProfileViewController: UIViewController {
    
    let presenter: IPresenter
    let usernameLabel: UILabel = UILabel()
    let logoutButton: UIButton = UIButton()
    
    init(presenter: IPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupUsernameLabel()
        setupLogoutButton()
        setupData()
    }
    
    func setupUsernameLabel() {
        self.view.addSubview(usernameLabel)
        usernameLabel.text = "123456"
        usernameLabel.backgroundColor = .white
        usernameLabel.layer.cornerRadius = 25
        usernameLabel.clipsToBounds = true
        usernameLabel.textAlignment = .center
        usernameLabel.numberOfLines = 0
        usernameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }
    
    func setupLogoutButton() {
        self.view.addSubview(logoutButton)
        logoutButton.setTitle("Выйти", for: .normal)
        logoutButton.backgroundColor = .clear
        logoutButton.setTitleColor(.red, for: .normal)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        logoutButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(50)
            make.width.equalTo(75)
            make.height.equalTo(50)
        }
    }
    
    @objc func logout() {
        presenter.logout()
    }
    
    func setupData() {
        let userInfo: UserViewModel = presenter.getUser() ?? UserViewModel(userID: UUID(), username: "111", password: "111")
        usernameLabel.text = "Имя пользователя: " + userInfo.username
    }
}
