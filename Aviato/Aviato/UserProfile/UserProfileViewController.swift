//
//  UserProfileViewController.swift
//  Aviato
//
//  Created by user188734 on 7/6/21.
//

import UIKit
import SnapKit

protocol IUserProfileViewController {
    func showUserInfo(userInfo: UserViewModel)
    
}

class UserProfileViewController: UIViewController, IUserProfileViewController {
    
    let presenter: IUserProfilePresenter
    let usernameLabel: UILabel = UILabel()
    let logoutButton: UIButton = UIButton()
    let removeUserButton: UIButton = UIButton()
    var buttonPressed: Bool = false
    
    init(presenter: IUserProfilePresenter) {
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
        setupRemoveUserButton()
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
    
    func setupRemoveUserButton() {
        self.view.addSubview(removeUserButton)
        removeUserButton.setTitle("Удалить пользователя", for: .normal)
        removeUserButton.layer.cornerRadius = 25
        removeUserButton.backgroundColor = .red
        removeUserButton.layer.borderColor = UIColor.white.cgColor
        removeUserButton.layer.borderWidth = 3
        removeUserButton.addTarget(self, action: #selector(toggleAnimationButtonColor(button: )), for: .touchDown)
        removeUserButton.addTarget(self, action: #selector(removeUser), for: .touchUpInside)
        removeUserButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.bottom.equalToSuperview().offset(-100)
            make.height.equalTo(50)
        }
    }
    
    @objc func removeUser() {
        toggleAnimationButtonColor(button: self.removeUserButton)
        presenter.removeUser()
    }
    
    @objc func logout() {
        presenter.logout()
    }
    
    @objc func toggleAnimationButtonColor(button: UIButton) {
        var animator = UIViewPropertyAnimator()
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            button.backgroundColor = self.buttonPressed ? .white : .red
            button.layer.borderColor = self.buttonPressed ? UIColor.red.cgColor : UIColor.white.cgColor
            button.setTitleColor(self.buttonPressed ? UIColor.red : UIColor.white, for: .highlighted)
        })
        buttonPressed = !buttonPressed
        animator.startAnimation()
    }
    
    func setupData() {
        presenter.getUser(userViewController: self)
    }
    
    func showUserInfo(userInfo: UserViewModel) {
        usernameLabel.text = "Имя пользователя: " + userInfo.username
        
    }
    
}
