//
//  TransactionTVC.swift
//  Payup
//
//  Created by Ammar AlTahhan on 02/12/2018.
//  Copyright © 2018 Ammar AlTahhan. All rights reserved.
//

import UIKit

class TransactionTVC: UITableViewCell {
    
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var amountTitleLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    
    var transaction: Transaction! {
        didSet {
            
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
