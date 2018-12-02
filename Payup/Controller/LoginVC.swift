//
//  ViewController.swift
//  Payup
//
//  Created by Ammar AlTahhan on 01/12/2018.
//  Copyright © 2018 Ammar AlTahhan. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var mobileTextFiled: UITextField!
    @IBOutlet weak var singInButton: UIButton!
    
    let segueIdentifier = "SignIn"
    var phoneNumber: String!
    var isVerified: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let id = UserDefaults.standard.string(forKey: "CurrentUserId") as? String {
            self.performSegue(withIdentifier: segueIdentifier, sender: nil)
        }
    }
    
    @IBAction func signInTapped(_ sender: UIButton) {
        guard let text = mobileTextFiled.text, !text.isEmpty else { return }
        if !isVerified {
            phoneNumber = text
            API.authPhoneNumber(withPhoneNumber: text) { (err) in
                guard err == nil else {
                    self.showMessage(title: "Error", message: "Couldn't verify provided phone number. \(String(describing: err?.localizedDescription))")
                    return
                }
                self.animateVerificationCode()
                self.isVerified = true
            }
        } else {
            API.signIn(withPhoneNumber: phoneNumber, verificationCode: text) { (err) in
                guard err == nil else {
                    self.showMessage(title: "Error", message: "Couldn't verify provided code")
                    return
                }
                self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
            }
        }
    }
    
    private func animateVerificationCode() {
        mobileTextFiled.text = ""
        UIView.animate(withDuration: 0.7, animations: {
            self.mobileTextFiled.alpha = 0
        }) { (_) in
            self.mobileTextFiled.placeholder = "Verification Code"
            UIView.animate(withDuration: 0.5, animations: {
                self.mobileTextFiled.alpha = 1
            })
        }
        
        UIView.animate(withDuration: 0.7, animations: {
            self.singInButton.alpha = 0
        }) { (_) in
            self.singInButton.setTitle("Sign in", for: .normal)
            UIView.animate(withDuration: 0.5, animations: {
                self.singInButton.alpha = 1
            })
            
        }
    }


}

