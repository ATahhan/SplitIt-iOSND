//
//  API.swift
//  Payup
//
//  Created by Ammar AlTahhan on 01/12/2018.
//  Copyright © 2018 Ammar AlTahhan. All rights reserved.
//

import Foundation
import Firebase

class API {
    
    /// Authenticate phone number and saves verification ID
    ///
    /// - Parameters:
    ///   - number: phone number from user
    ///   - completion: Error - Auth error
    static func authPhoneNumber(withPhoneNumber number: String, completion: @escaping (Error?)->Void) {
        
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                completion(error)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "verificationID")
            completion(nil)
        }
        
    }
    
    /// Sign in using previously retrieved verification ID and verification code sent to the user
    ///
    /// - Parameters:
    ///   - withPhoneNumber: phone number used to sign in
    ///   - code: verification code sent to the user
    ///   - completion: Error - Sign in error
    static func signIn(withPhoneNumber number: String, verificationCode code: String, completion: @escaping (Error?)->Void) {
        let verificationID = UserDefaults.standard.string(forKey: "verificationID")!
        let credintials = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: code)
        Auth.auth().signInAndRetrieveData(with: credintials) { (result, error) in
            if let error = error {
                completion(error)
                return
            }
            saveUser(phoneNumber: number, completion: { (err) in
                guard err == nil else { completion(err!); return }
                completion(nil)
            })
        }
        
    }
    
    /// Description
    ///
    /// - Parameters:
    ///   - phoneNumber: phoneNumber description
    ///   - completion: completion description
    private static func saveUser(phoneNumber: String, completion: @escaping (Error?)->Void) {
        References.currentUser = References.Users.addDocument(data:[
            Keys.Created: FieldValue.serverTimestamp(),
            Keys.LastUpdated: FieldValue.serverTimestamp(),
            Keys.User.Firstname: "",
            Keys.User.Lastname: "",
            Keys.User.MobileNumber: phoneNumber
        ]) { err in
            if let err = err {
                completion(err)
            } else {
                UserDefaults.standard.set(References.currentUser?.documentID, forKey: "CurrentUserID")
                completion(nil)
            }
        }
    }
    
    /// Description
    ///
    /// - Parameters:
    ///   - transaction: transaction description
    ///   - completion: completion description
    static func postTransaction(_ transaction: Transaction, completion: @escaping (Error?)->Void) {
        var data: [String: Any] = [
            Keys.Created: FieldValue.serverTimestamp(),
            Keys.LastUpdated: FieldValue.serverTimestamp()
        ]
        data.append(other: transaction.getDict())
        References.Transactions.addDocument(data: data) { err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        }
    }
    
    /// Description
    ///
    /// - Parameter completion: completion description
    static func getTransactions(completion: @escaping ([Transaction], Error?)->Void) {
        References.currentUser?.getDocument(completion: { (document, err) in
            guard err == nil else { completion([], err); return }
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        })
    }
    
}
