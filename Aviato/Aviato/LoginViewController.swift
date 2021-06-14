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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUsernameField()
        setupPasswordField()
        setupAuthButton()
        setupRegisterButton()
        self.view.backgroundColor = .green
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
    }
    
    @objc func registerAction() {
        print("Register")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
