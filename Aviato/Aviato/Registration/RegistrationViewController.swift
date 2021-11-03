//
//  registrationViewController.swift
//  Aviato
//
//  Created by user188734 on 7/5/21.
//

import UIKit
import SnapKit

protocol IRegistrationViewController: IAlert {
    func dismissView()
    func presentSelf()
}

class RegistrationViewController: UIViewController {
    let passwordField: UITextField = UITextField()
    let emailField: UITextField = UITextField()
    let nameField: UITextField = UITextField()
    let birthDateTextField: UITextField = UITextField()
    let datePicker = UIDatePicker()
    let registerButton: UIButton = UIButton()
    let presenter: IRegistrationPresenter
    var registerButtonPressed: Bool = false
    
    let placeholdersColor: UIColor = .darkGray
    let textColor: UIColor = .black
    
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
        setupEmailField()
        setupPasswordField()
        setupNameField()
        setupDateField()
        setupRegisterButton()
        
    }
    
    func setupEmailField() {
        self.view.addSubview(emailField)
        emailField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        emailField.addTarget(self, action: #selector(validateEmailField), for: .editingChanged)
        emailField.backgroundColor = .white
        emailField.textColor = textColor
        emailField.layer.cornerRadius = 25
        emailField.textAlignment = .center
        emailField.attributedPlaceholder = NSAttributedString(string: RootViewController.labels!.emailField, attributes: [NSAttributedString.Key.foregroundColor : placeholdersColor])
        emailField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.top.equalToSuperview().offset(50)
            make.height.equalTo(50)
        }
    }
    
    func setupPasswordField() {
        self.view.addSubview(passwordField)
        passwordField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        passwordField.layer.cornerRadius = 25
        passwordField.textAlignment = .center
        passwordField.isSecureTextEntry = true
        passwordField.backgroundColor = .white
        passwordField.textColor = textColor
        passwordField.attributedPlaceholder = NSAttributedString(string: RootViewController.labels!.passwordField, attributes: [NSAttributedString.Key.foregroundColor : placeholdersColor])
        passwordField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.top.equalTo(emailField.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
    }
    
    func setupNameField() {
        self.view.addSubview(nameField)
        nameField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        nameField.backgroundColor = .white
        nameField.textColor = textColor
        nameField.layer.cornerRadius = 25
        nameField.textAlignment = .center
        nameField.attributedPlaceholder = NSAttributedString(string: RootViewController.labels!.userNameField, attributes: [NSAttributedString.Key.foregroundColor : placeholdersColor])
        nameField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.top.equalTo(passwordField.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
    }
    
    func setupDateField() {
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
        birthDateTextField.backgroundColor = .white
        birthDateTextField.textColor = textColor
        birthDateTextField.layer.cornerRadius = 25
        birthDateTextField.textAlignment = .center
        birthDateTextField.attributedPlaceholder = NSAttributedString(string: RootViewController.labels!.birthDateField, attributes: [NSAttributedString.Key.foregroundColor : placeholdersColor])
        birthDateTextField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.top.equalTo(nameField.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
        
    }
    
    func setupRegisterButton() {
        self.view.addSubview(registerButton)
        registerButton.isEnabled = false
        registerButton.addTarget(self, action: #selector(registerUser), for: .touchUpInside)
        registerButton.setTitle(RootViewController.labels!.registerButton, for: .normal)
        registerButton.layer.cornerRadius = 25
        registerButton.backgroundColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        registerButton.layer.borderColor = UIColor.gray.cgColor
        registerButton.layer.borderWidth = 3
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.setTitleColor(.gray, for: .disabled)
        registerButton.addTarget(self, action: #selector(toggleAnimationButtonColor(button:)), for: .touchDown)
        registerButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.top.equalTo(birthDateTextField.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
    }
    //Проверка email на валидность
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    @objc func toggleAnimationButtonColor(button: UIButton) {
        var animator = UIViewPropertyAnimator()
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            button.backgroundColor = self.registerButtonPressed ? .white : UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
            button.layer.borderColor = self.registerButtonPressed ? UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1).cgColor : UIColor.white.cgColor
            button.setTitleColor(self.registerButtonPressed ? UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1) : UIColor.white, for: .highlighted)
        })
        registerButtonPressed = !registerButtonPressed
        animator.startAnimation()
    }
    
    @objc func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        self.birthDateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func registerUser() {
        toggleAnimationButtonColor(button: self.registerButton)
        guard let password = passwordField.text, let name = nameField.text, let email = emailField.text?.lowercased() else {
            return
        }
        //При случае спросить нормально ли делать так, что сама View себя закрывает, по результату работы метода презентера или команду на закрытие должен отдать сам презентер
        presenter.registerUser(view: self, password: password, birthDate: datePicker.date, email: email, name: name)
    }
    
    @objc func textFieldsChanged() {
        if passwordField.hasText && nameField.hasText && emailField.hasText && birthDateTextField.hasText {
            if isValidEmail(email: emailField.text!) {
                registerButton.layer.borderColor = UIColor.white.cgColor
                registerButton.isEnabled = true
            } else {
                registerButton.isEnabled = false

            }
            
        } else {
            registerButton.layer.borderColor = UIColor.gray.cgColor
            registerButton.isEnabled = false
        }
    }
    
    @objc func validateEmailField() {
        if isValidEmail(email: emailField.text ?? "") {
            emailField.layer.borderWidth = 0
        } else {
            emailField.layer.borderWidth = 3
            emailField.layer.borderColor = UIColor.red.cgColor
            
        }
    }
}

extension RegistrationViewController: IAlert {
    func showAlert(message: String) {
        let alert = UIAlertController(title: RootViewController.labels!.error, message: message, preferredStyle: .alert)
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
