//
//  FoundFlyghtViewController.swift
//  Aviato
//
//  Created by user188734 on 6/15/21.
//

import UIKit
import SnapKit

protocol IFoundFlyghtViewController: AnyObject {
    var alertController: IAlert {get set}
    func closeView()
}

class FoundFlyghtViewController: FavoriteViewController, IFoundFlyghtViewController {
    var alertController: IAlert = AlertController()
    let saveButton: UIButton = UIButton()
    let presenter: IFoundFlyghtPresenter
    var saveButtonPressed: Bool = false
    var aircraftPicture: UIImage?
    
    init(flyghtViewInfo: FlyghtViewModel, presenter: IFoundFlyghtPresenter) {
        self.presenter = presenter
        super.init()
        alertController.view = self
    }
    
    init(flyghtViewInfo: FlyghtViewModel, presenter: IFoundFlyghtPresenter, aircraftPicture: UIImage) {
        self.aircraftPicture = aircraftPicture
        self.presenter = presenter
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        if aircraftPicture != nil {
            aircraftImage.image = aircraftPicture
        }
    }
    
    func setupButton() {
        self.scrollViewContainer.addArrangedSubview(saveButton)
        saveButton.setTitle(RootViewController.labels!.addToFavorite, for: .normal)
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
    
    func closeView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addToFavorite() {
        toggleAnimationButtonColor(button: self.saveButton)
        presenter.addToFavorite(image: aircraftImage.image)
    }
    
    @objc func toggleAnimationButtonColor(button: UIButton) {
        var animator = UIViewPropertyAnimator()
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: { [unowned self] in
            button.backgroundColor = self.saveButtonPressed ? .white : UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
            button.layer.borderColor = self.saveButtonPressed ? UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1).cgColor : UIColor.white.cgColor
            button.setTitleColor(self.saveButtonPressed ? UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1) : UIColor.white, for: .highlighted)
        })
        saveButtonPressed = !saveButtonPressed
        animator.startAnimation()
    }
}


