//
//  EditUserProfileViewController.swift
//  Aviato
//
//  Created by user188734 on 7/21/21.
//

import UIKit

protocol IEditUserProfileViewController: AnyObject {
    var alertController: AlertController { get set }
    func showUserInfo(userInfo: UserViewModel)
    func closeView()
}


class EditUserProfileViewController: UIViewController, IEditUserProfileViewController {
    let passwordField: UITextField = UITextField()
    let emailField: UITextField = UITextField()
    let nameField: UITextField = UITextField()
    let birthDateTextField: UITextField = UITextField()
    let datePicker = UIDatePicker()
    let userPhoto: UIImageView = UIImageView()
    let saveButton: UIButton = UIButton()
    let cancelButton: UIButton = UIButton()
    let removeUserButton: UIButton = UIButton()
    let editProfilePresenter: IEditUserProfilePresenter
    var buttonPressed: Bool = false
    var imageChanged: Bool = false
    var alertController = AlertController()
    let textFieldsColor: UIColor = .black
    let textFieldsPlaceholderColor: UIColor = .darkGray
    
    init(editPresenter: IEditUserProfilePresenter) {
        self.editProfilePresenter = editPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object:nil, userInfo: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertController.view = self
        self.view.backgroundColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        setupUserImage()
        setupCancelButton()
        setupSaveButton()
        setupEmailField()
        setupNameField()
        setupDateField()
        setupRemoveUserButton()
        editProfilePresenter.getUser()
    }
    
    func setupCancelButton() {
        self.view.addSubview(cancelButton)
        cancelButton.setTitle(RootViewController.labels!.calncelButton, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        cancelButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
    }
    
    func setupSaveButton() {
        self.view.addSubview(saveButton)
        saveButton.isEnabled = false
        saveButton.setTitleColor(.gray, for: .normal)
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        saveButton.setTitle(RootViewController.labels!.saveButton, for: .normal)
        saveButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
    }
    
    func setupUserImage() {
        self.view.addSubview(userPhoto)
        userPhoto.backgroundColor = .white
        //Скругление угло height/2
        userPhoto.layer.cornerRadius = 125
        userPhoto.clipsToBounds = true
        let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(showActionSheet))
        userPhoto.addGestureRecognizer(tapOnImage)
        userPhoto.isUserInteractionEnabled = true
        userPhoto.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(250)
        }
    }
    
    func setupEmailField() {
        self.view.addSubview(emailField)
        emailField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        emailField.addTarget(self, action: #selector(validateEmailField), for: .editingChanged)
        emailField.inputAccessoryView = setupDoneToolbar(tag: 0)
        emailField.backgroundColor = .white
        emailField.textColor = textFieldsColor
        emailField.layer.cornerRadius = 25
        emailField.attributedPlaceholder = NSAttributedString(string: RootViewController.labels!.emailField, attributes: [NSAttributedString.Key.foregroundColor : textFieldsPlaceholderColor])
        emailField.textAlignment = .center
        emailField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.top.equalTo(userPhoto.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
    }
    
    func setupNameField() {
        self.view.addSubview(nameField)
        nameField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        nameField.backgroundColor = .white
        nameField.textColor = textFieldsColor
        nameField.layer.cornerRadius = 25
        nameField.textAlignment = .center
        nameField.attributedPlaceholder = NSAttributedString(string: RootViewController.labels!.userNameField, attributes: [NSAttributedString.Key.foregroundColor : textFieldsPlaceholderColor])
        nameField.inputAccessoryView = setupDoneToolbar(tag: 0)
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
        birthDateTextField.inputAccessoryView = setupDoneToolbar(tag: 1)
        birthDateTextField.backgroundColor = .white
        birthDateTextField.layer.cornerRadius = 25
        birthDateTextField.textColor = textFieldsColor
        birthDateTextField.textAlignment = .center
        birthDateTextField.attributedPlaceholder = NSAttributedString(string: RootViewController.labels!.birthDateField, attributes: [NSAttributedString.Key.foregroundColor : textFieldsPlaceholderColor])
        birthDateTextField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.top.equalTo(nameField.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
    }
    
    func setupRemoveUserButton() {
        self.view.addSubview(removeUserButton)
        removeUserButton.setTitle(RootViewController.labels!.deleteUserButton, for: .normal)
        removeUserButton.layer.cornerRadius = 25
        removeUserButton.backgroundColor = .red
        removeUserButton.layer.borderColor = UIColor.white.cgColor
        removeUserButton.layer.borderWidth = 3
        removeUserButton.addTarget(self, action: #selector(toggleAnimationButtonColor(button: )), for: .touchDown)
        removeUserButton.addTarget(self, action: #selector(removeUser), for: .touchUpInside)
        removeUserButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.bottom.equalToSuperview().offset(-100)
            make.height.equalTo(50)
        }
    }
    
    func setupDoneToolbar(tag: Int) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed(sender: )))
        doneButton.tag = 1
        toolbar.setItems([doneButton], animated: true)
        return toolbar
    }
    
    //Проверка email на валидность
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func closeView() {
        dismiss(animated: true, completion: nil)
    }
    
    func showUserInfo(userInfo: UserViewModel) {
        nameField.text = userInfo.name
        emailField.text = userInfo.email
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        birthDateTextField.text = dateFormatter.string(from: userInfo.birthDate)
        datePicker.date = userInfo.birthDate
        guard let image = editProfilePresenter.getImage(fileName: userInfo.userID) else {
            return
        }
        userPhoto.image = image
    }
    
    @objc func removeUser() {
        toggleAnimationButtonColor(button: self.removeUserButton)
        editProfilePresenter.removeUser()
    }
    
    @objc func toggleAnimationButtonColor(button: UIButton) {
        var animator = UIViewPropertyAnimator()
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            [unowned self] in
            button.backgroundColor = self.buttonPressed ? .white : .red
            button.layer.borderColor = self.buttonPressed ? UIColor.red.cgColor : UIColor.white.cgColor
            button.setTitleColor(self.buttonPressed ? UIColor.red : UIColor.white, for: .highlighted)
        })
        buttonPressed = !buttonPressed
        animator.startAnimation()
    }
    
    @objc func donePressed(sender: UIButton) {
        if sender.tag == 1 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            self.birthDateTextField.text = dateFormatter.string(from: datePicker.date)
        }
        self.view.endEditing(true)
    }
    
    @objc func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: RootViewController.labels!.camera, style: .default) { [unowned self] _ in
            self.chooseImagePicker(source: .camera)
        }
        let photo = UIAlertAction(title: RootViewController.labels!.gallery, style: .default) { [unowned self] _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        let cancel = UIAlertAction(title: RootViewController.labels!.calncelButton, style: .cancel)
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        present(actionSheet,animated: true)
        
    }
    
    @objc func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveAction() {
        guard let email = emailField.text, let name = nameField.text else {
            return
        }
        let userInfo: UserViewModel = UserViewModel(userID: "", password: "String", birthDate: datePicker.date, email: email, name: name)
        editProfilePresenter.updateUserInfo(userInfo: userInfo, userAvatar: userPhoto.image)
    }
    
    @objc func textFieldsChanged() {
        if emailField.hasText && (passwordField.hasText || nameField.hasText || birthDateTextField.hasText || imageChanged) {
            if isValidEmail(email: emailField.text!) {
                saveButton.setTitleColor(.white, for: .normal)
                saveButton.isEnabled = true
            } else {
                saveButton.isEnabled = false
                
            }
            
        } else {
            saveButton.setTitleColor(.gray, for: .normal)
            saveButton.isEnabled = false
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

extension EditUserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        userPhoto.image = info[.editedImage] as? UIImage
        userPhoto.contentMode = .scaleAspectFill
        userPhoto.clipsToBounds = true
        imageChanged = true
        textFieldsChanged()
        dismiss(animated: true)
    }
}
