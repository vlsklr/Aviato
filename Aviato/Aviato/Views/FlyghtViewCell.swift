//
//  FlyghtViewCell.swift
//  Aviato
//
//  Created by Vlad on 16.06.2021.
//

import UIKit
import SnapKit

class FlyghtViewCell: UITableViewCell {
//    var uid: UUID?
    let flyghtNumberLabel: UILabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell() {
//        self.uid = uid
        contentView.addSubview(flyghtNumberLabel)
        flyghtNumberLabel.snp.makeConstraints { make in
              make.leading.equalToSuperview().offset(15)
              make.top.equalToSuperview().offset(10)
              make.width.equalTo(250)
              make.height.equalTo(20)
          }
          
          self.contentView.snp.makeConstraints { make in
              make.width.equalToSuperview()
              make.height.equalTo(100)
          }
    }

}
