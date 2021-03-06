//
//  FlyghtViewCell.swift
//  Aviato
//
//  Created by Vlad on 16.06.2021.
//

import UIKit
import SnapKit

protocol IFlyghtViewCell {
    var entityID: String? { get set }
}

class FlyghtViewCell: UITableViewCell, IFlyghtViewCell {
    let flyghtNumberLabel: UILabel = UILabel()
    let departireTimeLabel: UILabel = UILabel()
    var entityID: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(id: String) {
        self.contentView.backgroundColor = .white
        flyghtNumberLabel.textColor = .black
        departireTimeLabel.textColor = .black
        entityID = id
        contentView.addSubview(flyghtNumberLabel)
        flyghtNumberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(20)
            make.width.equalToSuperview().offset(-16)
            make.height.equalTo(20)
        }
        
        contentView.addSubview(departireTimeLabel)
        departireTimeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(flyghtNumberLabel).offset(20)
            make.width.equalToSuperview().offset(-16)
            make.height.equalTo(20)
        }
        
        self.contentView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(1)
            make.trailing.equalToSuperview().offset(-1)
            make.height.equalTo(80)
        }
    }
}
