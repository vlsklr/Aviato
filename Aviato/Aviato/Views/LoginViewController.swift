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
    let logoView: UIImageView = UIImageView()
    let presenter: IPresenter
    
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
        setupLogoView()
        setupUsernameField()
        setupPasswordField()
        setupAuthButton()
        setupRegisterButton()
    }
    
    func setupLogoView() {
        self.view.addSubview(logoView)
        logoView.image = UIImage(named: "aviato_logo")
        logoView.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.top.equalToSuperview().offset(150)
            make.height.equalTo(100)
            
        })
    }
    
    func setupUsernameField() {
        self.view.addSubview(userNameField)
        userNameField.backgroundColor = .white
        userNameField.placeholder = "Имя пользователя"
        userNameField.layer.cornerRadius = 25
        userNameField.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        userNameField.textAlignment = .center
        userNameField.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.top.equalToSuperview().offset(350)
            make.height.equalTo(50)
            
        })
        
    }
    
    func setupPasswordField() {
        passwordField.backgroundColor = .white
        passwordField.isSecureTextEntry = true
        passwordField.layer.cornerRadius = 25
        passwordField.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        passwordField.textAlignment = .center
        passwordField.placeholder = "Пароль"
        self.view.addSubview(passwordField)
        passwordField.snp.makeConstraints({ (make) in
            make.top.equalTo(userNameField.snp.bottom)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.height.equalTo(50)
            
        })
    }
    func setupAuthButton() {
        self.view.addSubview(authButton)
        authButton.addTarget(self, action: #selector(authAction), for: .touchUpInside)
        authButton.backgroundColor = .blue
        authButton.setTitle("Войти", for: .normal)
        authButton.layer.cornerRadius = 25
        authButton.backgroundColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        authButton.layer.borderColor = UIColor.white.cgColor
        authButton.layer.borderWidth = 3
        authButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.height.equalTo(50)
        }
    }
    
    func setupRegisterButton() {
        self.view.addSubview(registerButton)
        registerButton.setTitle("Зарегистрироваться", for: .normal)
        registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        registerButton.backgroundColor = .blue
        registerButton.layer.cornerRadius = 25
        registerButton.backgroundColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        registerButton.layer.borderColor = UIColor.white.cgColor
        registerButton.layer.borderWidth = 3
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(authButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.height.equalTo(50)
        }
    }
    
    @objc func authAction() {
        guard let username = userNameField.text, let password = passwordField.text else{return}
        presenter.authentificateUser(view: self, username: username, password: password)
    }
    
    @objc func registerAction() {
        guard let username = userNameField.text, let password = passwordField.text else{return}
        presenter.registerUser(view: self, username: username, password: password)
    }
}

extension LoginViewController: IAlert {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        self.present(alert, animated: true)
    }
}
