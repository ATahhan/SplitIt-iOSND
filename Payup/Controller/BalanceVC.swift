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
    @IBOutlet weak var forBalanceAmountLabel: UILabel!
    @IBOutlet weak var againstBalanceAmountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pastSplitsLabel: UILabel!
    @IBOutlet weak var expandBalanceButton: UIButton!
    @IBOutlet weak var detailedBalanceStackView: UIStackView!
    @IBOutlet weak var balanceViewHeight: NSLayoutConstraint!
    
    let cellIdentifier = "TransactionCell"
    let expandedBalanceHeight: CGFloat = 220
    let collapsedBalanceHeight: CGFloat = 140
    let expandButtonTitles = ["^", "⌄"]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var transactions: [Transaction] = [] {
        didSet {
            self.updateUI()
        }
    }
    var forTransactions: [Transaction] {
        return transactions.filter({$0.payer.reference == References.currentUser})
    }
    var againstTransactions: [Transaction] {
        return transactions.filter({$0.payee.reference == References.currentUser})
    }
    
    var isBalanceExpanded = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getTransactions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tableView.tableHeaderView = headerView
            }
        }
    }
    
    private func setupUI() {
        expandDetailedBalance(false)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addTapped(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logoutTapped(_:)))
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.whiteContent
        navigationController?.navigationBar.barTintColor = UIColor.whiteContent
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.whiteContent]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @objc private func logoutTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Logging out", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { (action) in
            API.logout(completion: { (err) in
                guard err == nil else { self.showMessage(title: "Error", message: "Couldn't log you out. \(err!.localizedDescription)"); return }
                self.dismiss(animated: true, completion: nil)
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func addTapped(_ sender: Any) {
        let vc = AddTransactionVC.instatiateFromStoryboard()
        vc.modalPresentationStyle = .overCurrentContext
        vc.onDismiss = { shouldRefresh in
            if shouldRefresh {
                self.getTransactions()
            }
        }
        present(vc, animated: false, completion: nil)
    }
    
    private func getTransactions() {
        self.showProgressHUD()
        API.getTransactions { transactions, err  in
            self.hideProgressHUD()
            guard err == nil else {
                self.showMessage(title: "Error", message: "Couldn't retrieve transactions. \(err?.localizedDescription ?? "")")
                return
            }
            self.transactions = transactions
        }
    }
    
    private func updateUI() {
        tableView.reloadData()
        
        let forAmount = forTransactions.map({$0.amount}).reduce(0, +)
        let againstAmount = againstTransactions.map({$0.amount}).reduce(0, +)
        let amount = forAmount - againstAmount
        
        forBalanceAmountLabel.text = "\(forAmount)"
        againstBalanceAmountLabel.text = "\(againstAmount)"
        balanceAmountLabel.text = "\(amount)"
        if amount > 0 {
            balanceTitleLabel.text = "You're owed"
        } else if amount < 0 {
            balanceTitleLabel.text = "You owe others"
        } else {
            balanceTitleLabel.text = "You're all even"
        }
    }
    
    @IBAction private func expandTapped(_ sender: UIButton) {
        let title = sender.title(for: .normal)
        let text = title == expandButtonTitles[0] ? expandButtonTitles[1] : expandButtonTitles[0]
        expandBalanceButton.setTitle(text, for: .normal)
        isBalanceExpanded = !isBalanceExpanded
        expandDetailedBalance(isBalanceExpanded)
    }
    
    private func expandDetailedBalance(_ bool: Bool) {
        if bool {
            self.detailedBalanceStackView.isHidden = false
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.01, options: .curveEaseOut, animations: {
                self.balanceViewHeight.constant = self.expandedBalanceHeight
                self.view.layoutIfNeeded()
            })
            UIView.animate(withDuration: 0.6, delay: 0.7, usingSpringWithDamping: 1, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
                self.detailedBalanceStackView.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
                self.detailedBalanceStackView.alpha = 0
            })
            UIView.animate(withDuration: 0.5, delay: 0.4, usingSpringWithDamping: 1, initialSpringVelocity: 0.4, options: .curveEaseOut, animations: {
                self.balanceViewHeight.constant = self.collapsedBalanceHeight
                self.view.layoutIfNeeded()
                self.detailedBalanceStackView.isHidden = true
            })
        }
    }

}

extension BalanceVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TransactionTVC
        
        let transaction = transactions[indexPath.row]
        if forTransactions.contains(where: {$0 == transaction}) {
            cell.transaction = (transaction, Payment.forUser)
        } else {
            cell.transaction = (transaction, Payment.againstUser)
        }
        
        return cell
    }
}

extension BalanceVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 55 {
            pastSplitsLabel.textColor = .whiteContent
        } else {
            pastSplitsLabel.textColor = .darkMainColor
        }
    }
}
