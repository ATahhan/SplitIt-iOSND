//
//  AddTransactionVC.swift
//  Payup
//
//  Created by Ammar AlTahhan on 03/12/2018.
//  Copyright © 2018 Ammar AlTahhan. All rights reserved.
//

import UIKit

class AddTransactionVC: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var paymentTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    static let sbIdentifier = "AddTransactionVC"
    let containerViewTransform = CGAffineTransform(translationX: 0, y: 300)
    let payments: [Payment] = [.forUser, .againstUser]
    
    var onDismiss: ((Bool)->Void)?
    var users: [User] = []
    var currentTextField: UITextField?
    var selecetedUser: Int?
    var pickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getUsers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateViewIn()
    }
    
    static func instatiateFromStoryboard() -> AddTransactionVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: sbIdentifier) as! AddTransactionVC
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let fullName = userTextField.text, !fullName.isEmpty else { userTextField.animateFalseEntry(); return }
        guard let amount = amountTextField.text, !amount.isEmpty, let amountDouble = Double(amount) else { amountTextField.animateFalseEntry(); return }
        guard let payment = paymentTextField.text, !payment.isEmpty else { paymentTextField.animateFalseEntry(); return }
        
        var transaction = Transaction(reference: nil, payer: nil, amount: amountDouble, payee: nil, isPayed: false, description: descriptionTextField.text!)
        switch Payment(rawValue: payment)! {
        case .forUser:
            transaction.payer = users[selecetedUser!]
            transaction.payee = User(reference: References.currentUser, fullName: "", mobileNumber: "")
        case .againstUser:
            transaction.payer = User(reference: References.currentUser, fullName: "", mobileNumber: "")
            transaction.payee = users[selecetedUser!]
        }
        
        self.showProgressHUD()
        API.postTransaction(transaction) { (err) in
            self.hideProgressHUD()
            guard err == nil else { self.showMessage(title: "Error", message: "Couldn't send your request. \(err?.localizedDescription ?? "")"); return }
            self.onDismiss?(true)
            self.animateViewOut()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        containerView.alpha = 0
        containerView.transform = containerViewTransform
        let backView = UIView(frame: view.frame)
        backView.backgroundColor = .clear
        view.addSubview(backView)
        view.sendSubviewToBack(backView)
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissTapped(_:))))
        
        paymentTextField.delegate = self
        userTextField.delegate = self
        amountTextField.delegate = self
        descriptionTextField.delegate = self
        
        pickerView.delegate = self
        pickerView.dataSource = self
        userTextField.inputView = pickerView
        paymentTextField.inputView = pickerView
    }
    
    @objc private func dismissTapped(_ sender: Any) {
        onDismiss?(false)
        animateViewOut { (_) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    private func getUsers() {
        API.getUsers { (users, err) in
            guard err == nil else { self.showMessage(title: "Error", message: "Couldn't retrieve users"); return }
            self.users = users
            for (i, user) in users.enumerated() {
                if user == currentUser! {
                    self.users.remove(at: i)
                }
            }
        }
    }
    
    private func animateViewIn() {
        UIView.animate(withDuration: 0.8) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        }
        UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        })
    }
    
    private func animateViewOut(completion: ((Bool)->Void)? = nil) {
        UIView.animate(withDuration: 0.7, delay: 0.2, options: .curveLinear, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        })
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: .curveLinear, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = self.containerViewTransform
        }) { bool in
            completion?(bool)
        }
    }

}

extension AddTransactionVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        pickerView.reloadAllComponents()
        if textField == paymentTextField {
            textField.text = payments[pickerView.selectedRow(inComponent: 0)].rawValue
        } else if textField == userTextField {
            selecetedUser = pickerView.selectedRow(inComponent: 0)
            textField.text = users[selecetedUser!].fullName
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentTextField = nil
    }
}

extension AddTransactionVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let firstResponder = currentTextField else { return 0 }
        if firstResponder == userTextField {
            return users.count
        } else if firstResponder == paymentTextField {
            return payments.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let firstResponder = currentTextField else { return "" }
        if firstResponder == userTextField {
            return users[row].fullName
        } else if firstResponder == paymentTextField {
            return payments[row].rawValue
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let firstResponder = currentTextField as? UITextField else { return }
        if firstResponder == userTextField {
            firstResponder.text = users[row].fullName
            selecetedUser = row
        } else if firstResponder == paymentTextField {
            firstResponder.text = payments[row].rawValue
        }
        return
    }
}
