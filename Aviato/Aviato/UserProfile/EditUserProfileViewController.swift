//
//  EditUserProfileViewController.swift
//  Aviato
//
//  Created by user188734 on 7/21/21.
//

import UIKit

protocol IEditUserProfileViewController {
    
}

class EditUserProfileViewController: UIViewController {
    
    let usernameField: UITextField = UITextField()
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


    init(editPresenter: IEditUserProfilePresenter) {
        self.editProfilePresenter = editPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserImage()
        setupCancelButton()
        setupSaveButton()
        // Do any additional setup after loading the view.
    }
    
    func setupCancelButton() {
        self.view.addSubview(cancelButton)
        cancelButton.setTitle("Отмена", for: .normal)
        
        cancelButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
    }
    
    func setupSaveButton() {
        self.view.addSubview(saveButton)
        saveButton.setTitle("Сохранить", for: .normal)
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
}

extension EditUserProfileViewController: IEditUserProfileViewController {
    
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
//                imageChanged = true
        dismiss(animated: true)
    }
}
