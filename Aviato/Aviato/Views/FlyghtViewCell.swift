//
//  FlyghtViewCell.swift
//  Aviato
//
//  Created by Vlad on 16.06.2021.
//

import UIKit
import SnapKit

class FlyghtViewCell: UITableViewCell {
    let flyghtNumberLabel: UILabel = UILabel()
    let departireTimeLabel: UILabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell() {
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
            make.width.equalToSuperview()
            make.height.equalTo(80)
        }
    }
}
