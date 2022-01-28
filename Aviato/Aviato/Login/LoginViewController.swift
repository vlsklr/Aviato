//
//  LoginViewController.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import UIKit
import SnapKit

protocol ILoginViewController: AnyObject {
    var alertController: IAlert {set get}
    func showScreen(viewController: RegistrationViewController)
}

class LoginViewController: UIViewController, ILoginViewController {
    let emailField: UITextField = UITextField()
    let passwordField: UITextField = UITextField()
    let authButton: UIButton = UIButton()
    let registerButton: UIButton = UIButton()
    let logoView: UIImageView = UIImageView()
    let presenter: ILoginPresenter
    var authButtonPressed: Bool = false
    var alertController: IAlert = AlertController()
    
    init(presenter: ILoginPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewDidLoad()
        alertController.view = self
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
        self.view.addSubview(emailField)
        emailField.backgroundColor = .white
        emailField.layer.cornerRadius = 25
        emailField.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        emailField.textAlignment = .center
        emailField.textColor = .black
        emailField.attributedPlaceholder = NSAttributedString(string: RootViewController.labels!.emailField, attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])

        emailField.snp.makeConstraints({ (make) in
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
        passwordField.textColor = .black
        passwordField.attributedPlaceholder = NSAttributedString(string: RootViewController.labels!.passwordField, attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        self.view.addSubview(passwordField)
        passwordField.snp.makeConstraints({ (make) in
            make.top.equalTo(emailField.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.height.equalTo(50)
            
        })
    }
    func setupAuthButton() {
        self.view.addSubview(authButton)
        authButton.addTarget(self, action: #selector(authAction), for: .touchUpInside)
        authButton.addTarget(self, action: #selector(toggleAnimationButtonColor(button:)), for: .touchDown)
        authButton.setTitle(RootViewController.labels!.loginButton, for: .normal)
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
            string: RootViewController.labels!.createAccountButton,
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
    
    func showScreen(viewController: RegistrationViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    func setupSwipeDown() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.hideKeyboardOnSwipeDown))
        swipeDown.delegate = self
        swipeDown.direction =  UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
    }
        
    @objc func toggleAnimationButtonColor(button: UIButton) {
        var animator = UIViewPropertyAnimator()
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: { [unowned self] in
            button.backgroundColor = self.authButtonPressed ? .white : UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
            button.layer.borderColor = self.authButtonPressed ? UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1).cgColor : UIColor.white.cgColor
            button.setTitleColor(self.authButtonPressed ? UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1) : UIColor.white, for: .highlighted)
        })
        authButtonPressed = !authButtonPressed
        animator.startAnimation()
    }
    
    @objc func authAction() {
        toggleAnimationButtonColor(button: self.authButton)
        guard let email = emailField.text, let password = passwordField.text else{return}
        presenter.authentificateUser(email: email.lowercased(), password: password)
    }
    
    @objc func hideKeyboardOnSwipeDown() {
        view.endEditing(true)
    }
    
    @objc func registerAction() {
        presenter.registerUser()
    }
}

extension LoginViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


