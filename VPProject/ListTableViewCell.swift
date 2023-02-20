//
//  ListTableViewCell.swift
//  VPProject
//
//  Created by 刘伟 on 2023/2/17.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    var titleString:String? {
        didSet {
            titleLabel.text = titleString
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
