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
    let userID: UUID
    
    init(userID: UUID) {
        self.userID = userID
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
        self.view.addSubview(flyghtNumberLaber)
        flyghtNumberLaber.text = "1488"
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
        let tempFlyght = FlyghtViewModel(holder: self.userID, flyghtID: UUID(), flyghtNumber: "1488")
        
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
