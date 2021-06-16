//
//  FoundFlyghtViewController.swift
//  Aviato
//
//  Created by user188734 on 6/15/21.
//

import UIKit
import SnapKit
class FoundFlyghtViewController: UIViewController {
    let flyghtNumberLaber: UILabel = UILabel()
    let saveButton: UIButton = UIButton()
    let flyghtViewInfo: FlyghtViewModel
    let presenter: IPresenter
    
    init(flyghtViewInfo: FlyghtViewModel, presenter: IPresenter) {
        self.presenter = presenter
        self.flyghtViewInfo = flyghtViewInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    let tmpStorage: IStorageManager = StorageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .brown
        setupButton()
        setupLabel()

        // Do any additional setup after loading the view.
    }
    
    func setupLabel() {
        self.view.addSubview(flyghtNumberLaber)
        flyghtNumberLaber.text = flyghtViewInfo.flyghtNumber
        flyghtNumberLaber.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(150)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    
    func setupButton() {
        self.view.addSubview(saveButton)
        saveButton.setTitle("Добавить в избранное", for: .normal)
        saveButton.backgroundColor = .yellow
        saveButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        saveButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
    }
    
    @objc func addToFavorite() {
        presenter.addToFavorite(flyght: self.flyghtViewInfo)
        self.dismiss(animated: true, completion: nil)
    }

    

}

//extension FoundFlyghtViewController: IFoundFlyghtViewController {
//    func showFoundFlyght(flyghtViewInfo: FlyghtViewModel) {
//        let popViewController = FoundFlyghtViewController(flyghtViewInfo: flyghtViewInfo)
//        self.present(popViewController, animated: true, completion: nil)
//    }
//
//
//}
