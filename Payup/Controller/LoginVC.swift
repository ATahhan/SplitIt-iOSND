//
//  ViewController.swift
//  Payup
//
//  Created by Ammar AlTahhan on 01/12/2018.
//  Copyright © 2018 Ammar AlTahhan. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var fullNameTextFiled: UITextField!
    @IBOutlet weak var mobileTextFiled: UITextField!
    @IBOutlet weak var singInButton: UIButton!
    @IBOutlet weak var overlayView: UIView!
    
    let segueIdentifier = "SignIn"
    var phoneNumber: String!
    var isVerified: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        showOverlay()
    }
    
    @IBAction func signInTapped(_ sender: UIButton) {
        guard let text = mobileTextFiled.text, !text.isEmpty else { mobileTextFiled.animateFalseEntry(); return }
        self.showProgressHUD()
        if !isVerified {
            phoneNumber = text
            API.authPhoneNumber(withPhoneNumber: text) { (err) in
                self.hideProgressHUD()
                guard err == nil else {
                    self.showMessage(title: "Error", message: "Couldn't verify provided phone number. \(String(describing: err?.localizedDescription))")
                    return
                }
                self.animateVerificationCode()
                self.isVerified = true
            }
        } else {
            guard let name = fullNameTextFiled.text, !text.isEmpty else { fullNameTextFiled.animateFalseEntry(); return }
            API.signIn(withPhoneNumber: phoneNumber, fullName: name, verificationCode: text) { (err) in
                self.hideProgressHUD()
                guard err == nil else {
                    self.showMessage(title: "Error", message: "Couldn't verify provided code. \(err?.localizedDescription ?? "")")
                    return
                }
                self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
            }
        }
    }
    
    private func showOverlay() {
        overlayView.alpha = 1
        API.getCurrentUser { (user) in
            guard user != nil else {
                self.animateOverlayFadeOut()
                return
            }
            currentUser = user!
            self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
        }
    }
    
    private func animateOverlayFadeOut() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
            self.overlayView.alpha = 0
        }) { (_) in
            self.overlayView.isHidden = true
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

