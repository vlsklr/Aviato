//
//  LoginViewController.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    let userNameField: UITextField = UITextField()
    let passwordField: UITextField = UITextField()
    let authButton: UIButton = UIButton()
    let registerButton: UIButton = UIButton()
    
    let storage: IStorageManager = StorageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        setupUsernameField()
        setupPasswordField()
        setupAuthButton()
        setupRegisterButton()
    }
    
    func setupUsernameField() {
        self.view.addSubview(userNameField)
        userNameField.backgroundColor = .cyan
        userNameField.placeholder = "Имя пользователя"
        userNameField.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(250)
            make.height.equalTo(25)
            make.width.equalTo(150)
        })
    }
    
    func setupPasswordField() {
        passwordField.backgroundColor = .white
        passwordField.isSecureTextEntry = true
        passwordField.placeholder = "Пароль"
        self.view.addSubview(passwordField)
        passwordField.snp.makeConstraints({ (make) in
            make.top.equalTo(userNameField).offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
            make.width.equalTo(150)
            
        })
    }
    func setupAuthButton() {
        self.view.addSubview(authButton)
        authButton.addTarget(self, action: #selector(authAction), for: .touchUpInside)
        authButton.backgroundColor = .blue
        authButton.setTitle("Войти", for: .normal)
        authButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordField).offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
            make.width.equalTo(150)
        }
    }
    
    func setupRegisterButton() {
        self.view.addSubview(registerButton)
        registerButton.setTitle("Зарегистрироваться", for: .normal)
        registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        registerButton.backgroundColor = .blue
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(authButton).offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
            make.width.equalTo(150)
        }
        
        
    }
    
    @objc func authAction() {
        print("Auth")
        guard let username = userNameField.text, let password = passwordField.text else{return}
        if !username.isEmpty && !password.isEmpty{
            let user = storage.loadUser(username: username)
            if user?.username == username && user?.password == password {
                print("logged in")
                AppDelegate.shared.rootViewController.switchToMainScreen()
            }
        }
        //AppDelegate.shared.rootViewController.switchToMainScreen()
    }
    
    @objc func registerAction() {
        print("Register")
        let user = UserViewModel(userID: UUID(), username: userNameField.text!, password: passwordField.text!)
        storage.addUser(user: user) {
            AppDelegate.shared.rootViewController.switchToMainScreen()
            
        }
        
    }
}
