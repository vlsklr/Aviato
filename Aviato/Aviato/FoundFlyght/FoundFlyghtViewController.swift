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
    
    init(flyghtViewInfo: FlyghtViewModel, presenter: IFoundFlyghtPresenter) { //}, presenter: IPresenter) {
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
        saveButton.addTarget(self, action: #selector(animateButtonAction), for: .touchDown)
        saveButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)

        saveButton.snp.makeConstraints { (make) in
            make.top.equalTo(aircraftLabel.snp.bottom).offset(35)
            make.leading.equalToSuperview().offset(43)
            make.height.equalTo(50)
        }
    }
    
    @objc func addToFavorite() {
        var animator = UIViewPropertyAnimator()
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            self.saveButton.backgroundColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
            self.saveButton.layer.borderColor = UIColor.white.cgColor
        })
        animator.startAnimation()
        presenter.addToFavorite(view: self, flyght: self.flyghtViewInfo)
    }
    
    @objc func animateButtonAction() {
        var animator = UIViewPropertyAnimator()
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            self.saveButton.backgroundColor = .white
            self.saveButton.layer.borderColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1).cgColor
            self.saveButton.setTitleColor(UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1), for: .highlighted)
        })
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

extension FoundFlyghtViewController: IFoundFlyghtViewController {
    func dismissFoundView() {
        self.dismiss(animated: true)
    }
    
    
}