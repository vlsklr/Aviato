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
    
    // MARK: - VisualConstants
    
    private enum VisualConstants {
        static let leftPadding: CGFloat = 32.0
        static let rightPadding: CGFloat = -32.0
        static let titleTopPadding: CGFloat = 174.0
        static let titlePadding: CGFloat = 16.0
        static let fieldHeight: CGFloat = 52.0
        static let cornerRadius: CGFloat = 10.0
        static let emailFieldPadding: CGFloat = 40.0
        static let passwordFieldPadding: CGFloat = 24.0
        static let forgetPasswordPadding: CGFloat = 10.0
        static let authButtonPadding: CGFloat = 50.0
        static let authButtonHeight: CGFloat = 44.0
        static let authMethodsPadding: CGFloat = 53.0
        static let authMethodsBottomPadding: CGFloat = -78.0
        static let textFieldBackgroundColor = UIColor(red: 1, green: 0.8, blue: 1, alpha: 0.2)
        static let textFieldTextColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        static let rockStarRegularfont = UIFont(name: "RockStar", size: 14.0)
        static let rockStarRegularfont12 = UIFont(name: "RockStar", size: 12.0)
        static let titleLabelFont = UIFont(name: "Wadik", size: 20.0)
    }
    
    // MARK: - Properties
    
    private let titleLabel: UILabel
    private let subtitleLabel: UILabel
    private let forgetPasswordButton: UIButton
    private var authMethodsTitle: UIStackView
    private let googleAuthButton: UIButton
    private let appleAuthButton: UIButton
    private let facebookAuthButton: UIButton
    private var authMethodsButtons: UIStackView
    private let emailField: UITextField = UITextField()
    private let passwordField: UITextField = UITextField()
    private let authButton: UIButton = UIButton()
    private let registerButton: UIButton = UIButton()
    private let logoView: UIImageView = UIImageView()
    private let presenter: ILoginPresenter
    private var authButtonPressed: Bool = false
    var alertController: IAlert = AlertController()
    
    // MARK: - Initializers
    
    init(presenter: ILoginPresenter) {
        self.presenter = presenter
        titleLabel = UILabel()
        subtitleLabel = UILabel()
        forgetPasswordButton = UIButton()
        authMethodsTitle = UIStackView()
        googleAuthButton = UIButton()
        appleAuthButton = UIButton()
        facebookAuthButton = UIButton()
        authMethodsButtons = UIStackView(arrangedSubviews: [googleAuthButton, appleAuthButton, facebookAuthButton])
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewDidLoad()
        alertController.view = self
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0.4, alpha: 1)
        setupSwipeDown()
        setupUI()
    }
    
}

// MARK: - UIManagment

extension LoginViewController {
    
    private func setupUI() {
        setupTitleLabel()
        setupSubtitleLabel()
        setupUsernameField()
        setupPasswordField()
        setupForgetPasswordButton()
        setupAuthButton()
        setupRegisterButton()
        setupAuthMethodsButtons()
    }
    
    private func setupTitleLabel() {
        
        view.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = VisualConstants.titleLabelFont
        titleLabel.text = RootViewController.labels!.loginScreenTitle
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(VisualConstants.leftPadding)
            make.trailing.equalToSuperview().offset(VisualConstants.rightPadding)
            make.top.equalToSuperview().offset(VisualConstants.titleTopPadding)
        }
    }
    
    private func setupSubtitleLabel() {
        view.addSubview(subtitleLabel)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .white
        subtitleLabel.font = VisualConstants.rockStarRegularfont
        subtitleLabel.text = RootViewController.labels!.loginScreenSubtitle
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(VisualConstants.leftPadding)
            make.trailing.equalToSuperview().offset(VisualConstants.rightPadding)
            make.top.equalTo(titleLabel.snp.bottom).offset(VisualConstants.titlePadding)
        }
        
    }
    
    private func setupUsernameField() {
        self.view.addSubview(emailField)
        emailField.backgroundColor = VisualConstants.textFieldBackgroundColor
        emailField.layer.cornerRadius = VisualConstants.cornerRadius
        emailField.textAlignment = .center
        emailField.font = VisualConstants.rockStarRegularfont
        emailField.textColor = VisualConstants.textFieldTextColor
        emailField.attributedPlaceholder = NSAttributedString(string: RootViewController.labels!.emailField,
                                                              attributes:
                                                                [NSAttributedString.Key.foregroundColor:
                                                                    VisualConstants.textFieldTextColor,
                                                                 NSAttributedString.Key.font:
                                                                    VisualConstants.rockStarRegularfont!])

        emailField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(VisualConstants.leftPadding)
            make.trailing.equalToSuperview().offset(VisualConstants.rightPadding)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(VisualConstants.emailFieldPadding)
            make.height.equalTo(VisualConstants.fieldHeight)
        }
    }
    
    private func setupPasswordField() {
        passwordField.backgroundColor = VisualConstants.textFieldBackgroundColor
        passwordField.isSecureTextEntry = true
        passwordField.layer.cornerRadius = VisualConstants.cornerRadius
        passwordField.textAlignment = .center
        passwordField.textColor = VisualConstants.textFieldTextColor
        passwordField.font = VisualConstants.rockStarRegularfont
        passwordField.attributedPlaceholder = NSAttributedString(string: RootViewController.labels!.passwordField,
                                                                 attributes:
                                                                    [NSAttributedString.Key.foregroundColor:
                                                                        VisualConstants.textFieldTextColor,
                                                                     NSAttributedString.Key.font:
                                                                        VisualConstants.rockStarRegularfont!])
        self.view.addSubview(passwordField)
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(VisualConstants.passwordFieldPadding)
            make.leading.equalToSuperview().offset(VisualConstants.leftPadding)
            make.trailing.equalToSuperview().offset(VisualConstants.rightPadding)
            make.height.equalTo(VisualConstants.fieldHeight)
        }
    }
    
    private func setupForgetPasswordButton() {
        view.addSubview(forgetPasswordButton)
        let title = NSAttributedString(string: RootViewController.labels!.forgetPassword,
                                      attributes:
                                       [NSAttributedString.Key.font:
                                           VisualConstants.rockStarRegularfont12!,
                                        NSAttributedString.Key.foregroundColor:
                                            UIColor.white])
        forgetPasswordButton.setAttributedTitle(title, for: .normal)
        forgetPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(VisualConstants.forgetPasswordPadding)
            make.trailing.equalToSuperview().offset(VisualConstants.rightPadding)
        }
    }
    
    private func setupAuthButton() {
        view.addSubview(authButton)
        authButton.addTarget(self, action: #selector(authAction), for: .touchUpInside)
        authButton.addTarget(self, action: #selector(toggleAnimationButtonColor(button:)), for: .touchDown)
        let title = NSAttributedString(string: RootViewController.labels!.loginButton,
                                       attributes:
                                        [NSAttributedString.Key.font:
                                            VisualConstants.rockStarRegularfont!,
                                         NSAttributedString.Key.foregroundColor:
                                            UIColor(red: 0, green: 0, blue: 0.4, alpha: 1)])
        authButton.layer.cornerRadius = VisualConstants.cornerRadius
        authButton.backgroundColor = .white
        authButton.setAttributedTitle(title, for: .normal)
        authButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(VisualConstants.authButtonPadding)
            make.leading.equalToSuperview().offset(VisualConstants.leftPadding)
            make.trailing.equalToSuperview().offset(VisualConstants.rightPadding)
            make.height.equalTo(VisualConstants.authButtonHeight)
        }
    }
    
    private func setupAuthMethods() {
        let authLabel = UILabel()
        let leftView = UIView()
        let rightView = UIView()
        authMethodsTitle = UIStackView(arrangedSubviews: [leftView, authLabel, rightView])
        authMethodsTitle.axis = .horizontal
        authMethodsTitle.distribution = .fill
        authMethodsTitle.spacing = 1.0
        authMethodsTitle.alignment = .center
        view.addSubview(authMethodsTitle)
        
        authLabel.text = RootViewController.labels?.loginMethodsTitle
        authLabel.textColor = VisualConstants.textFieldTextColor
        authLabel.font = VisualConstants.rockStarRegularfont12
        authLabel.textAlignment = .center
        
        leftView.backgroundColor = VisualConstants.textFieldTextColor
        leftView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        rightView.backgroundColor = VisualConstants.textFieldTextColor
        rightView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(leftView.snp.width)
        }
        
        authMethodsTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(VisualConstants.leftPadding)
            make.trailing.equalToSuperview().offset(VisualConstants.rightPadding)
            make.bottom.equalTo(authMethodsButtons.snp.top).offset(-VisualConstants.titlePadding)
        }
    }
    
    private func setupAuthMethodsButtons() {
        setupGoogleButton()
        setupAppleButton()
        setupFacebookButton()
        view.addSubview(authMethodsButtons)
        authMethodsButtons.distribution = .fillEqually
        authMethodsButtons.spacing = 12.0
        authMethodsButtons.snp.makeConstraints { make in
            make.height.equalTo(VisualConstants.fieldHeight)
            make.bottom.equalTo(registerButton.snp.top).offset(-VisualConstants.titlePadding)
            make.leading.equalToSuperview().offset(VisualConstants.leftPadding)
            make.trailing.equalToSuperview().offset(VisualConstants.rightPadding)
        }
        setupAuthMethods()
    }
    
    private func setupGoogleButton() {
        let icon = UIImage(named: "googleIcon")
        googleAuthButton.setImage(icon, for: .normal)
        googleAuthButton.backgroundColor = VisualConstants.textFieldBackgroundColor
        googleAuthButton.layer.cornerRadius = VisualConstants.cornerRadius
    }
    
    
    private func setupAppleButton() {
        let icon = UIImage(named: "appleIcon")
        appleAuthButton.setImage(icon, for: .normal)
        appleAuthButton.backgroundColor = VisualConstants.textFieldBackgroundColor
        appleAuthButton.layer.cornerRadius = VisualConstants.cornerRadius
    }
    
    private func setupFacebookButton() {
        let icon = UIImage(named: "facebookIcon")
        facebookAuthButton.setImage(icon, for: .normal)
        facebookAuthButton.backgroundColor = VisualConstants.textFieldBackgroundColor
        facebookAuthButton.layer.cornerRadius = VisualConstants.cornerRadius
    }
    
    private func setupRegisterButton() {
        self.view.addSubview(registerButton)
        let attributeString = NSMutableAttributedString(string: "")
        if let regStr = RootViewController.labels?.createAccountButtonRegular {
            let regularString = NSAttributedString(string: regStr,
                                                   attributes: [NSAttributedString.Key.foregroundColor:
                                                                    VisualConstants.textFieldTextColor,
                                                                NSAttributedString.Key.font:
                                                                    VisualConstants.rockStarRegularfont12!])
            attributeString.append(regularString)
        }
        
        if let boldStr = RootViewController.labels?.createAccountButtonBold {
            let boldString = NSAttributedString(string: boldStr,
                                                attributes: [NSAttributedString.Key.foregroundColor:
                                                                UIColor.white,
                                                             NSAttributedString.Key.font:
                                                                VisualConstants.rockStarRegularfont12!])
            attributeString.append(boldString)
        }

        registerButton.setAttributedTitle(attributeString, for: .normal)
        registerButton.backgroundColor = .clear
        registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        registerButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(VisualConstants.authMethodsBottomPadding)
            make.leading.equalToSuperview().offset(VisualConstants.authMethodsPadding)
            make.trailing.equalToSuperview().offset(-VisualConstants.authMethodsPadding)
        }
    }
    
}

// MARK: - Transitions

extension LoginViewController {
    
    func showScreen(viewController: RegistrationViewController) {
        let navVC = UINavigationController(rootViewController: viewController)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
    
}

// MARK: - Actions

extension LoginViewController {
    
    func setupSwipeDown() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.hideKeyboardOnSwipeDown))
        swipeDown.delegate = self
        swipeDown.direction =  UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
    }
        
    @objc func toggleAnimationButtonColor(button: UIButton) {
        let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: { [unowned self] in
            button.backgroundColor = self.authButtonPressed ? .white : VisualConstants.textFieldBackgroundColor
            button.setTitleColor(self.authButtonPressed ? VisualConstants.textFieldBackgroundColor : UIColor.white, for: .highlighted)
        })
        animator.startAnimation()
        authButtonPressed = !authButtonPressed
    }
    
    @objc func authAction() {
        toggleAnimationButtonColor(button: authButton)
        guard let email = emailField.text, let password = passwordField.text else { return }
        presenter.authentificateUser(email: email.lowercased(), password: password)
    }
    
    @objc func hideKeyboardOnSwipeDown() {
        view.endEditing(true)
    }
    
    @objc func registerAction() {
        presenter.registerUser()
    }
    
}

// MARK: - UIGestureRecognizerDelegate

extension LoginViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}


