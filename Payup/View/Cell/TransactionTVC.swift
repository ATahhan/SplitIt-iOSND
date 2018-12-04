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
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    var transaction: (Transaction, Payment)! {
        didSet {
            amountLabel.text = String(transaction.0.amount)
            descriptionLabel.text = transaction.0.description
            switch transaction.1 {
            case .forUser:
                amountTitleLabel.text = "You're owed"
                amountTitleLabel.textColor = UIColor.correctGreen
                usernameLabel.text = transaction.0.payee.fullName
            case .againstUser:
                amountTitleLabel.text = "You owe"
                amountTitleLabel.textColor = UIColor.wrongRed
                usernameLabel.text = transaction.0.payer.fullName
            }
            
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
