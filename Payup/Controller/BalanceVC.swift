//
//  BalanceVC.swift
//  Payup
//
//  Created by Ammar AlTahhan on 02/12/2018.
//  Copyright © 2018 Ammar AlTahhan. All rights reserved.
//

import UIKit

class BalanceVC: UIViewController {
    
    @IBOutlet weak var balanceTitleLabel: UILabel!
    @IBOutlet weak var balanceAmountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var balanceViewHeight: NSLayoutConstraint!
    
    let cellIdentifier = "TransactionCell"
    var transactions: [Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getTransactions()
    }
    
    func setupUI() {
        
    }
    
    func getTransactions() {
        API.getTransactions { transactions, err  in
            guard err == nil else {
                self.showMessage(title: "Error", message: "Couldn't retrieve transactions. \(err?.localizedDescription ?? "")")
                return
            }
            self.transactions = transactions
            self.tableView.reloadData()
        }
    }

}

extension BalanceVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TransactionTVC
        
        cell.transaction = transactions[indexPath.row]
        
        return cell
    }
}
