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
    let flyghtID: UUID
    
    init(flyghtID: UUID) {
        self.flyghtID = flyghtID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    let tmpStorage: IStorageManager = StorageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .brown
        setupButton()
        setupLabel()

        // Do any additional setup after loading the view.
    }
    
    func setupLabel() {
        self.view.addSubview(flyghtNumberLabel)
        let flyght = tmpStorage.getFlyght(flyghtID: flyghtID)
        flyghtNumberLabel.text = "\(flyght?.flyghtID) + \(flyght?.flyghtNumber)"
        flyghtNumberLabel.snp.makeConstraints { (make) in
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
        let tempFlyght = FlyghtViewModel(holder: self.flyghtID, flyghtID: UUID(), flyghtNumber: "1488")
        
//        let temp:[FlyghtViewModel]? = tmpStorage.getFlyghts(userID: userID)
        
//        tmpStorage.removeFlyght(flyghtID: temp![0].flyghtID)
        
//        tmpStorage.getFlyghts(userID: userID)
        
       tmpStorage.AddFlyght(flyght: tempFlyght)
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
