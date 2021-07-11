//
//  registrationViewController.swift
//  Aviato
//
//  Created by user188734 on 7/5/21.
//

import UIKit
import SnapKit

class RegistrationViewController: UIViewController {
    let usernameField: UITextField = UITextField()
    let passwordField: UITextField = UITextField()
    let registerButton: UIButton = UIButton()
    let presenter: IRegistrationPresenter
    
    init(presenter: IRegistrationPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        setupUsernameField()
        setupPasswordField()
        setupRegisterButton()
    }
    
    func setupUsernameField() {
        self.view.addSubview(usernameField)
        usernameField.backgroundColor = .white
        usernameField.layer.cornerRadius = 25
        usernameField.placeholder = "Имя пользователя"
        usernameField.textAlignment = .center
        usernameField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.top.equalToSuperview().offset(50)
            make.height.equalTo(50)
        }
    }
    
    func setupPasswordField() {
        self.view.addSubview(passwordField)
        passwordField.layer.cornerRadius = 25
        passwordField.placeholder = "Пароль"
        passwordField.textAlignment = .center
        passwordField.isSecureTextEntry = true
        passwordField.backgroundColor = .white
        passwordField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.top.equalTo(usernameField.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
    }
    
    func setupRegisterButton() {
        self.view.addSubview(registerButton)
        registerButton.addTarget(self, action: #selector(registerUser), for: .touchUpInside)
        registerButton.setTitle("Зарегистрироваться", for: .normal)
        registerButton.layer.cornerRadius = 25
        registerButton.backgroundColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        registerButton.layer.borderColor = UIColor.white.cgColor
        registerButton.layer.borderWidth = 3
        registerButton.addTarget(self, action: #selector(animate), for: .touchDown)
        registerButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.top.equalTo(passwordField.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
    }
    
    @objc func animate() {
        var animator = UIViewPropertyAnimator()
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            self.registerButton.backgroundColor = .white
            self.registerButton.layer.borderColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1).cgColor
            self.registerButton.setTitleColor(UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1), for: .highlighted)
        })
        animator.startAnimation()
    }
    
    @objc func registerUser() {
        var animator = UIViewPropertyAnimator()
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            self.registerButton.backgroundColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
            self.registerButton.layer.borderColor = UIColor.white.cgColor
        })
        animator.startAnimation()
        guard let username = usernameField.text, let password = passwordField.text else {
            return
        }
        //При случае спросить нормально ли делать так, что сама View себя закрывает, по результату работы метода презентера или команду на закрытие должен отдать сам презентер
         presenter.registerUser(view: self, username: username, password: password) 
    }
}

extension RegistrationViewController: IAlert {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        self.present(alert, animated: true)
    }
}

extension RegistrationViewController: IRegistrationViewController {
    func presentSelf() {
        self.present(self, animated: true, completion: nil)

    }
    
    func dismissView() {
        dismiss(animated: true)
    }
    
    
}
