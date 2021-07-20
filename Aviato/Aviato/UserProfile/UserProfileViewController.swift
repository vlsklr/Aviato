//
//  UserProfileViewController.swift
//  Aviato
//
//  Created by user188734 on 7/6/21.
//

import UIKit
import SnapKit

protocol IUserProfileViewController {
    func showUserInfo(userInfo: UserViewModel)
    
}

class UserProfileViewController: UIViewController, IUserProfileViewController {
    
    let presenter: IUserProfilePresenter
    let userPhoto: UIImageView = UIImageView()
    let usernameLabel: UILabel = UILabel()
    let emailLabel: UILabel = UILabel()
    let nameLabel: UILabel = UILabel()
    let birthDate: UILabel = UILabel()
    let logoutButton: UIButton = UIButton()
    let removeUserButton: UIButton = UIButton()
    var buttonPressed: Bool = false
    
    init(presenter: IUserProfilePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupUserImage()
        setupUsernameLabel()
        setupEmailLabel()
        setupNameLabel()
        setupBirthDateLabel()
        setupLogoutButton()
        setupRemoveUserButton()
        setupData()
    }
    
    func setupUserImage() {
        self.view.addSubview(userPhoto)
        userPhoto.backgroundColor = .white
        //Скругление угло height/2
        userPhoto.layer.cornerRadius = 125
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
    
    func setupUsernameLabel() {
        self.view.addSubview(usernameLabel)
        usernameLabel.text = "123456"
        usernameLabel.backgroundColor = .white
        usernameLabel.layer.cornerRadius = 25
        usernameLabel.clipsToBounds = true
        usernameLabel.textAlignment = .center
        usernameLabel.numberOfLines = 0
        usernameLabel.snp.makeConstraints { (make) in
            //            make.top.equalToSuperview().offset(100)
            make.top.equalTo(userPhoto.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }
    
    func setupEmailLabel() {
        self.view.addSubview(emailLabel)
        emailLabel.text = "123456"
        emailLabel.backgroundColor = .white
        emailLabel.layer.cornerRadius = 25
        emailLabel.clipsToBounds = true
        emailLabel.textAlignment = .center
        emailLabel.numberOfLines = 0
        emailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(usernameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }
    
    func setupNameLabel() {
        self.view.addSubview(nameLabel)
        nameLabel.text = "123456"
        nameLabel.backgroundColor = .white
        nameLabel.layer.cornerRadius = 25
        nameLabel.clipsToBounds = true
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }
    
    func setupBirthDateLabel() {
        self.view.addSubview(birthDate)
        birthDate.text = "123456"
        birthDate.backgroundColor = .white
        birthDate.layer.cornerRadius = 25
        birthDate.clipsToBounds = true
        birthDate.textAlignment = .center
        birthDate.numberOfLines = 0
        birthDate.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }
    
    
    
    func setupLogoutButton() {
        self.view.addSubview(logoutButton)
        logoutButton.setTitle("Выйти", for: .normal)
        logoutButton.backgroundColor = .clear
        logoutButton.setTitleColor(.red, for: .normal)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        logoutButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(50)
            make.width.equalTo(75)
            make.height.equalTo(50)
        }
    }
    
    func setupRemoveUserButton() {
        self.view.addSubview(removeUserButton)
        removeUserButton.setTitle("Удалить пользователя", for: .normal)
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
    
    @objc func removeUser() {
        toggleAnimationButtonColor(button: self.removeUserButton)
        presenter.removeUser()
    }
    
    @objc func logout() {
        presenter.logout()
    }
    
    @objc func toggleAnimationButtonColor(button: UIButton) {
        var animator = UIViewPropertyAnimator()
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            button.backgroundColor = self.buttonPressed ? .white : .red
            button.layer.borderColor = self.buttonPressed ? UIColor.red.cgColor : UIColor.white.cgColor
            button.setTitleColor(self.buttonPressed ? UIColor.red : UIColor.white, for: .highlighted)
        })
        buttonPressed = !buttonPressed
        animator.startAnimation()
    }
    
    @objc func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.chooseImagePicker(source: .camera)
        }
        let photo = UIAlertAction(title: "Photo", style: .default) { (_) in
            self.chooseImagePicker(source: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        present(actionSheet,animated: true)
        
    }
    
    func setupData() {
        presenter.getUser(userViewController: self)
    }
    
    func showUserInfo(userInfo: UserViewModel) {
        usernameLabel.text = "Имя пользователя: " + userInfo.username
        emailLabel.text = "Email: " + userInfo.email
        nameLabel.text = "Имя: " + userInfo.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        birthDate.text = "Дата рождения: " + dateFormatter.string(from: userInfo.birthDate)
        
    }
    
}



extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
//                imageChanged = true
        dismiss(animated: true)
    }
}
