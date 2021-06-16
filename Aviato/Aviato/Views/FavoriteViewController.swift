//
//  FavoriteViewController.swift
//  Aviato
//
//  Created by Vlad on 16.06.2021.
//

import UIKit

class FavoriteViewController: UIViewController {

    let flyghtNumberLabel: UILabel = UILabel()
    let saveButton: UIButton = UIButton()
    var flyghtInfo: FlyghtViewModel?
    
    init(flyghtViewInfo: FlyghtViewModel) {
        self.flyghtInfo = flyghtViewInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
//    let tmpStorage: IStorageManager = StorageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .brown
        setupLabel()

        // Do any additional setup after loading the view.
    }
    
    func setupLabel() {
        self.view.addSubview(flyghtNumberLabel)
        
//        let flyght = tmpStorage.getFlyght(flyghtID: flyghtID)
        
        
        flyghtNumberLabel.text = "\(flyghtInfo!.aircraft) + \(flyghtInfo!.flyghtNumber)"
        flyghtNumberLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(150)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
}
