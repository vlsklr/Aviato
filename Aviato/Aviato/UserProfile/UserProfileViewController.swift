//
//  UserProfileViewController.swift
//  Aviato
//
//  Created by user188734 on 7/6/21.
//

import UIKit
import SnapKit

protocol IUserProfileViewController: AnyObject {
    func showUserInfo(userInfo: UserViewModel)
    func showEditUserProfile(editView: EditUserProfileViewController)
}

class UserProfileViewController: UIViewController, IUserProfileViewController {
    
    let presenter: IUserProfilePresenter
    let userPhoto: UIImageView = UIImageView()
    let emailLabel: UILabel = UILabel()
    let nameLabel: UILabel = UILabel()
    let birthDate: UILabel = UILabel()
    let editProfileButton: UIButton = UIButton()
    let logoutButton: UIButton = UIButton()
    var buttonPressed: Bool = false
    
    let labelsTextColor: UIColor = .black
    
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
        setupEmailLabel()
        setupNameLabel()
        setupBirthDateLabel()
        setupLogoutButton()
        setupEditButton()
        setupData()
        //Для обновления информации во ViewController после редактирования в EditUserProfileViewController
        NotificationCenter.default.addObserver(self, selector: #selector(UserProfileViewController.setupData), name: NSNotification.Name(rawValue: "refresh"), object: nil)

    }
    
    func setupUserImage() {
        self.view.addSubview(userPhoto)
        userPhoto.backgroundColor = .white
        //Скругление угло height/2
        userPhoto.layer.cornerRadius = 125
        userPhoto.clipsToBounds = true
        userPhoto.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(250)
        }
    }
        
    func setupEmailLabel() {
        self.view.addSubview(emailLabel)
        emailLabel.text = ""
        emailLabel.backgroundColor = .white
        emailLabel.textColor = labelsTextColor
        emailLabel.layer.cornerRadius = 25
        emailLabel.clipsToBounds = true
        emailLabel.textAlignment = .center
        emailLabel.numberOfLines = 0
        emailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userPhoto.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }
    
    func setupNameLabel() {
        self.view.addSubview(nameLabel)
        nameLabel.text = ""
        nameLabel.backgroundColor = .white
        nameLabel.textColor = labelsTextColor
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
        birthDate.text = ""
        birthDate.backgroundColor = .white
        birthDate.textColor = labelsTextColor
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
    
    func setupEditButton() {
        self.view.addSubview(editProfileButton)
        editProfileButton.setTitle(RootViewController.labels?.editUserProfileButton, for: .normal)
        editProfileButton.backgroundColor = .clear
        editProfileButton.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        editProfileButton.contentHorizontalAlignment = .left
        editProfileButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(50)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
    }
    
    func setupLogoutButton() {
        self.view.addSubview(logoutButton)
        logoutButton.setTitle(RootViewController.labels!.logoutButton, for: .normal)
        logoutButton.backgroundColor = .clear
        logoutButton.setTitleColor(.red, for: .normal)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        logoutButton.contentHorizontalAlignment = .right
        logoutButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(50)
            make.width.equalTo(75)
            make.height.equalTo(50)
        }
    }
    
    func showUserInfo(userInfo: UserViewModel) {
        emailLabel.text = "\(RootViewController.labels!.emailField): " + userInfo.email
        nameLabel.text = "\(RootViewController.labels!.userNameField): " + userInfo.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        birthDate.text = "\(RootViewController.labels!.birthDateField): " + dateFormatter.string(from: userInfo.birthDate)
        guard let image = presenter.getImage(fileName: userInfo.userID) else {
            return
        }
        userPhoto.image = image
    }
    
    func showEditUserProfile(editView: EditUserProfileViewController) {
        present(editView, animated: true, completion: nil)
    }
    
    @objc func editProfile() {
        presenter.editUser()
        
    }
    
    @objc func logout() {
        presenter.logout()
    }
    
    //Возможно переделаю для других кнопок
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
    
    
    @objc func setupData() {
        presenter.getUser()
    }
    
    
}


