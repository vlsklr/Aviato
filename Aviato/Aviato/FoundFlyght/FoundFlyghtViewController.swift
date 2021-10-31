//
//  FoundFlyghtViewController.swift
//  Aviato
//
//  Created by user188734 on 6/15/21.
//

import UIKit
import SnapKit

class FoundFlyghtViewController: FavoriteViewController {
    
    let saveButton: UIButton = UIButton()
    let presenter: IFoundFlyghtPresenter
    var saveButtonPressed: Bool = false
    
    init(flyghtViewInfo: FlyghtViewModel, presenter: IFoundFlyghtPresenter) {
        self.presenter = presenter
        super.init(flyghtViewInfo: flyghtViewInfo)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        
    }
    
    func setupButton() {
        self.scrollViewContainer.addArrangedSubview(saveButton)
        saveButton.setTitle("Добавить в избранное", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 25
        saveButton.backgroundColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        saveButton.layer.borderColor = UIColor.white.cgColor
        saveButton.layer.borderWidth = 3
        saveButton.addTarget(self, action: #selector(toggleAnimationButtonColor(button:)), for: .touchDown)
        saveButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        saveButton.snp.makeConstraints { (make) in
            make.top.equalTo(aircraftImage.snp.bottom).offset(35)
            make.leading.equalToSuperview().offset(43)
            make.height.equalTo(50)
        }
    }
    
   
    
    @objc func addToFavorite() {
        toggleAnimationButtonColor(button: self.saveButton)
        presenter.addToFavorite(view: self, flyght: self.flyghtViewInfo, image: aircraftImage.image)
    }
        
    @objc func toggleAnimationButtonColor(button: UIButton) {
        var animator = UIViewPropertyAnimator()
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            button.backgroundColor = self.saveButtonPressed ? .white : UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
            button.layer.borderColor = self.saveButtonPressed ? UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1).cgColor : UIColor.white.cgColor
            button.setTitleColor(self.saveButtonPressed ? UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1) : UIColor.white, for: .highlighted)
        })
        saveButtonPressed = !saveButtonPressed
        animator.startAnimation()
    }
}

extension FoundFlyghtViewController: IAlert {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        self.present(alert, animated: true)
    }
}

protocol IFoundFlyghtViewController: IAlert {
    func dismissFoundView()
    func showImage(imageData: Data)
}

extension FoundFlyghtViewController: IFoundFlyghtViewController {
    func showImage(imageData: Data) {
        guard let image = UIImage(data: imageData) else {
            return
        }
        aircraftImage.image = image
    }
    
    func dismissFoundView() {
        self.dismiss(animated: true)
    }
}
