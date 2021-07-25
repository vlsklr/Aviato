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
    let emailField: UITextField = UITextField()
    let nameField: UITextField = UITextField()
    let birthDateTextField: UITextField = UITextField()
    let datePicker = UIDatePicker()
    let registerButton: UIButton = UIButton()
    let presenter: IRegistrationPresenter
    var registerButtonPressed: Bool = false
    
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
        setupEmailField()
        setupNameField()
        setupDateField()
        setupRegisterButton()
        
    }
    
    func setupUsernameField() {
        self.view.addSubview(usernameField)
        usernameField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
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
        passwordField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
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
    
    func setupEmailField() {
        self.view.addSubview(emailField)
        emailField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        emailField.addTarget(self, action: #selector(validateEmailField), for: .editingChanged)
        emailField.backgroundColor = .white
        emailField.layer.cornerRadius = 25
        emailField.placeholder = "Email"
        emailField.textAlignment = .center
        emailField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.top.equalTo(passwordField.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
    }
    
    func setupNameField() {
        self.view.addSubview(nameField)
        nameField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        nameField.backgroundColor = .white
        nameField.layer.cornerRadius = 25
        nameField.placeholder = "Имя"
        nameField.textAlignment = .center
        nameField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.top.equalTo(emailField.snp.bottom).offset(10)
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
        } else {
            // Fallback on earlier versions
        }
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        birthDateTextField.inputAccessoryView = toolbar
        birthDateTextField.backgroundColor = .white
        birthDateTextField.layer.cornerRadius = 25
        birthDateTextField.placeholder = "Дата рождения"
        birthDateTextField.textAlignment = .center
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
        registerButton.setTitle("Зарегистрироваться", for: .normal)
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
        guard let username = usernameField.text, let password = passwordField.text, let name = nameField.text, let email = emailField.text else {
            return
        }
        //При случае спросить нормально ли делать так, что сама View себя закрывает, по результату работы метода презентера или команду на закрытие должен отдать сам презентер
        presenter.registerUser(view: self, username: username, password: password, birthDate: datePicker.date, email: email, name: name)
    }
    
    @objc func textFieldsChanged() {
        if usernameField.hasText && passwordField.hasText && nameField.hasText && emailField.hasText && birthDateTextField.hasText {
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
