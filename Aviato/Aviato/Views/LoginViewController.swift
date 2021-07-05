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
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        setupSwipeDown()
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
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.top.equalTo(logoView.snp.bottom).offset(75)
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
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.height.equalTo(50)
            
        })
    }
    func setupAuthButton() {
        self.view.addSubview(authButton)
        authButton.addTarget(self, action: #selector(authAction), for: .touchUpInside)
        authButton.addTarget(self, action: #selector(anim), for: .touchDown)
        authButton.setTitle("Войти", for: .normal)
        authButton.layer.cornerRadius = 25
        authButton.backgroundColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        authButton.layer.borderColor = UIColor.white.cgColor
        authButton.layer.borderWidth = 3
        authButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordField.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.height.equalTo(50)
        }
    }
    
    func setupRegisterButton() {
        self.view.addSubview(registerButton)
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.darkGray,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributeString = NSMutableAttributedString(
            string: "Все еще нет аккаунта?",
            attributes: yourAttributes
        )
        registerButton.setAttributedTitle(attributeString, for: .normal)
        registerButton.backgroundColor = .clear
        registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(authButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.height.equalTo(50)
        }
    }
    
    func setupSwipeDown() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.hideKeyboardOnSwipeDown))
        swipeDown.delegate = self
        swipeDown.direction =  UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc func anim(button: UIButton) {
        var animator = UIViewPropertyAnimator()
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            button.backgroundColor = .white
            button.layer.borderColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1).cgColor
            button.setTitleColor(UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1), for: .highlighted)
        })
        animator.startAnimation()
    }
    
    @objc func authAction() {
        var animator = UIViewPropertyAnimator()
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            self.authButton.backgroundColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
            self.authButton.layer.borderColor = UIColor.white.cgColor
        })
        animator.startAnimation()
        guard let username = userNameField.text, let password = passwordField.text else{return}
        presenter.authentificateUser(view: self, username: username, password: password)
    }
    
    @objc func hideKeyboardOnSwipeDown() {
        view.endEditing(true)
    }
    
    @objc func registerAction() {
        let registrationViewController = RegistrationViewController()
        self.present(registrationViewController, animated: true, completion: nil)
    }
}

extension LoginViewController: IAlert {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        self.present(alert, animated: true)
    }
}

extension LoginViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
