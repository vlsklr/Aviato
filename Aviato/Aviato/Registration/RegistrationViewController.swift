//
//  registrationViewController.swift
//  Aviato
//
//  Created by user188734 on 7/5/21.
//

import UIKit
import SnapKit

protocol IRegistrationViewController: UIViewController {
//    var alertController: IAlert { get set }
    func hideScreen()
}


class RegistrationViewController: UIViewController, IRegistrationViewController {
    
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
        static let backgroundColor = UIColor(red: 0, green: 0, blue: 0.4, alpha: 1)
        static let textFieldTextColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        static let rockStarRegularfont = UIFont(name: "RockStar", size: 14.0)
        static let rockStarRegularfont12 = UIFont(name: "RockStar", size: 12.0)
        static let titleLabelFont = UIFont(name: "Wadik", size: 20.0)
    }
    
    // MARK: - Properties
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let passwordField: UITextField = UITextField()
    private let emailField: UITextField = UITextField()
    private let nameField: UITextField = UITextField()
    private let birthDateTextField: UITextField = UITextField()
    private let datePicker = UIDatePicker()
    private let registerButton: AviatoButton
    private let closeButton = UIButton()
    private let authButton = UIButton()
    private var authMethodsTitle: UIStackView
    private let googleAuthButton: UIButton
    private let appleAuthButton: UIButton
    private let facebookAuthButton: UIButton
    private var authMethodsButtons: UIStackView
    private let presenter: IRegistrationPresenter
    private let placeholdersColor: UIColor = .darkGray
    private let textColor: UIColor = .black
    
    // MARK: - Initializers
    
    init(presenter: IRegistrationPresenter) {
        self.presenter = presenter
        authMethodsTitle = UIStackView()
        googleAuthButton = UIButton()
        appleAuthButton = UIButton()
        facebookAuthButton = UIButton()
        registerButton = AviatoButton()
        authMethodsButtons = UIStackView(arrangedSubviews: [googleAuthButton, appleAuthButton, facebookAuthButton])
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = VisualConstants.backgroundColor
        setupCloseButton()
        setupTitleLabel()
        setupSubtitleLabel()
        setupEmailField()
        setupPasswordField()
        setupNameField()
        setupDateField()
        setupRegisterButton()
        setupAuthButton()
        setupAuthMethodsButtons()
    }
}

// MARK: - Public methods

extension RegistrationViewController {
    
    @objc func hideScreen() {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Private methods

extension RegistrationViewController {
        
    private func validateEmail(email: String) -> Bool {
        let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    @objc private func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        self.birthDateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc private func registerUser() {
        guard let password = passwordField.text,
              let name = nameField.text,
              let email = emailField.text?.lowercased() else {
            return
        }
        presenter.registerUser(password: password, birthDate: datePicker.date, email: email, name: name)
    }
    
    @objc private func textFieldsChanged() {
        guard let email = emailField.text,
              nameField.hasText,
              birthDateTextField.hasText else {
            registerButton.isEnabled = false
            return
        }
        registerButton.isEnabled = validateEmail(email: email)
        reloadInputViews()
    }
    
    @objc private func validateEmailField() {
        if validateEmail(email: emailField.text ?? "") {
            emailField.layer.borderWidth = 0
        } else {
            emailField.layer.borderWidth = 3
            emailField.layer.borderColor = UIColor.red.cgColor
        }
    }
}

// MARK: - UIManagment

extension RegistrationViewController {
    
    private func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(hideScreen), for: .allEvents)
        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24.0)
            make.top.equalToSuperview().offset(54)
            make.width.equalTo(55)
            make.height.equalTo(75)
        }
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
    
    private func setupEmailField() {
        self.view.addSubview(emailField)
        emailField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        emailField.addTarget(self, action: #selector(validateEmailField), for: .editingChanged)
        
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
        self.view.addSubview(passwordField)
        passwordField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
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
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(VisualConstants.passwordFieldPadding)
            make.leading.equalToSuperview().offset(VisualConstants.leftPadding)
            make.trailing.equalToSuperview().offset(VisualConstants.rightPadding)
            make.height.equalTo(VisualConstants.fieldHeight)
        }
    }
    
    private func setupNameField() {
        self.view.addSubview(nameField)
        nameField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        nameField.backgroundColor = VisualConstants.textFieldBackgroundColor
        nameField.textColor = VisualConstants.textFieldTextColor
        nameField.layer.cornerRadius = VisualConstants.cornerRadius
        nameField.textAlignment = .center
        nameField.font = VisualConstants.rockStarRegularfont
        nameField.attributedPlaceholder = NSAttributedString(string: RootViewController.labels!.userNameField,
                                                             attributes:
                                                                [NSAttributedString.Key.foregroundColor:
                                                                    VisualConstants.textFieldTextColor,
                                                                 NSAttributedString.Key.font:
                                                                    VisualConstants.rockStarRegularfont!])
        nameField.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(VisualConstants.passwordFieldPadding)
            make.leading.equalToSuperview().offset(VisualConstants.leftPadding)
            make.trailing.equalToSuperview().offset(VisualConstants.rightPadding)
            make.height.equalTo(VisualConstants.fieldHeight)
        }
    }
    
    private func setupDateField() {
        self.view.addSubview(birthDateTextField)
        birthDateTextField.addTarget(self, action: #selector(textFieldsChanged), for: .allEditingEvents)
        birthDateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: Locale.preferredLanguages.first!)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        birthDateTextField.inputAccessoryView = toolbar
        
        birthDateTextField.backgroundColor = VisualConstants.textFieldBackgroundColor
        birthDateTextField.textColor = VisualConstants.textFieldTextColor
        birthDateTextField.layer.cornerRadius = VisualConstants.cornerRadius
        birthDateTextField.textAlignment = .center
        
        birthDateTextField.attributedPlaceholder = NSAttributedString(string: RootViewController.labels!.birthDateField,
                                                                      attributes:
                                                                        [NSAttributedString.Key.foregroundColor:
                                                                            VisualConstants.textFieldTextColor,
                                                                         NSAttributedString.Key.font:
                                                                            VisualConstants.rockStarRegularfont!])
        
        birthDateTextField.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(VisualConstants.passwordFieldPadding)
            make.leading.equalToSuperview().offset(VisualConstants.leftPadding)
            make.trailing.equalToSuperview().offset(VisualConstants.rightPadding)
            make.height.equalTo(VisualConstants.fieldHeight)
        }
    }
    
    private func setupRegisterButton() {
        view.addSubview(registerButton)
        registerButton.isEnabled = false
        let title = NSAttributedString(string: RootViewController.labels!.registerButton,
                                       attributes:
                                        [NSAttributedString.Key.font:
                                            VisualConstants.rockStarRegularfont!])
        registerButton.setAttributedTitle(title, for: .normal)
        registerButton.buttonAction = { [weak self] in
            self?.registerUser()
        }
        registerButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(VisualConstants.leftPadding)
            make.trailing.equalToSuperview().offset(VisualConstants.rightPadding)
            make.top.equalTo(birthDateTextField.snp.bottom).offset(VisualConstants.passwordFieldPadding)
            make.height.equalTo(VisualConstants.authButtonHeight)
        }
    }
    
    private func setupAuthMethods() {
        let registerLabel = UILabel()
        let leftView = UIView()
        let rightView = UIView()
        authMethodsTitle = UIStackView(arrangedSubviews: [leftView, registerLabel, rightView])
        authMethodsTitle.axis = .horizontal
        authMethodsTitle.distribution = .fill
        authMethodsTitle.spacing = 1.0
        authMethodsTitle.alignment = .center
        view.addSubview(authMethodsTitle)
        
        registerLabel.text = RootViewController.labels?.registerMethodsTitle
        registerLabel.textColor = VisualConstants.textFieldTextColor
        registerLabel.font = VisualConstants.rockStarRegularfont12
        registerLabel.textAlignment = .center
        
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
            make.bottom.equalToSuperview().offset(-110)
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
    
    private func setupAuthButton() {
        self.view.addSubview(authButton)
        let attributeString = NSMutableAttributedString(string: "")
        if let regStr = RootViewController.labels?.loginButtonRegular {
            let regularString = NSAttributedString(string: regStr,
                                                   attributes: [NSAttributedString.Key.foregroundColor:
                                                                    VisualConstants.textFieldTextColor,
                                                                NSAttributedString.Key.font:
                                                                    VisualConstants.rockStarRegularfont12!])
            attributeString.append(regularString)
        }
        
        if let boldStr = RootViewController.labels?.loginButtonBold {
            let boldString = NSAttributedString(string: " \(boldStr)",
                                                attributes: [NSAttributedString.Key.foregroundColor:
                                                                UIColor.white,
                                                             NSAttributedString.Key.font:
                                                                VisualConstants.rockStarRegularfont12!])
            attributeString.append(boldString)
        }

        authButton.setAttributedTitle(attributeString, for: .normal)
        authButton.backgroundColor = .clear
        authButton.addTarget(self, action: #selector(hideScreen), for: .touchUpInside)
        authButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(VisualConstants.authMethodsBottomPadding)
            make.leading.equalToSuperview().offset(VisualConstants.authMethodsPadding)
            make.trailing.equalToSuperview().offset(-VisualConstants.authMethodsPadding)
        }
    }
    
}
