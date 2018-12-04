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
    
    static func getCurrentUser(completion: @escaping (User?)->Void) {
        guard let firebaseUser = Auth.auth().currentUser else { completion(nil); return }
        API.getUser(byUid: firebaseUser.uid) { (user, err) in
            guard err == nil else { completion(nil); return }
            completion(user!)
        }
    }
    
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
        Auth.auth().signInAndRetrieveData(with: credintials) { (authData, error) in
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
        References.currentUser = References.Users.document(Auth.auth().currentUser!.uid)
        References.currentUser!.setData([
            Keys.Created: FieldValue.serverTimestamp(),
            Keys.LastUpdated: FieldValue.serverTimestamp(),
            Keys.User.Fullname: "",
            Keys.User.MobileNumber: phoneNumber
        ], completion: { (err) in
            if let err = err {
                completion(err)
            } else {
                UserDefaults.standard.set(References.currentUser?.documentID, forKey: "CurrentUserID")
                completion(nil)
            }
        })
    }
    
    static func signOut() throws {
        try? Auth.auth().signOut()
    }
    
    /// Post a transaction object to the Firestore
    ///
    /// - Parameters:
    ///   - transaction: transaction object
    ///   - completion: completion block that returns Error, if any
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
    
    /// Gets all users in the system
    ///
    /// - Parameter completion: array of users, and error if any.
    static func getUsers(completion: @escaping ([User], Error?)->Void) {
        References.Users.getDocuments { (snapshot, err) in
            guard err == nil else { completion([], err); return }
            var users: [User] = []
            for userDoc in snapshot!.documents {
                users.append(User(dict: userDoc.data(), firebaseReference: userDoc.reference))
            }
            completion(users, nil)
        }
    }
    
    /// Get a user by its UID
    ///
    /// - Parameters:
    ///   - ref: UID String
    ///   - completion: return User object, or error if any
    static func getUser(byUid uid: String,completion: @escaping (User?, Error?)->Void) {
        References.Users.document(uid).getDocument { (snapshot, err) in
            guard err == nil else { completion(nil, err); return }
            let user = User(dict: snapshot!.data()!, firebaseReference: snapshot!.reference)
            completion(user, nil)
        }
    }
    
    /// Gets all transactions for current user
    ///
    /// - Parameter completion: array of transactions, and error if any.
    static func getTransactions(completion: @escaping ([Transaction], Error?)->Void) {
        if References.currentUser == nil {
            let vId = Auth.auth().currentUser?.uid
            References.currentUser = References.Users.document(vId!)
        }
        var transactions: [Transaction] = []
        var isDone = (false, false)
        References.Users.getDocuments { (usersData, err) in
            guard err == nil else { completion([], err); return }
            let users = usersData!.documents
            References.Transactions.whereField(Keys.Transaction.Payee, isEqualTo: References.currentUser!).getDocuments { (data, err) in
                guard err == nil else { completion([], err); return }
                
                for document in data!.documents {
                    var transaction = Transaction(dict: document.data(), firebaseReference: document.reference)
                    let payerPayeeTuple = joinTransactionUsers(transaction: document, users: users)
                    transaction.payer = payerPayeeTuple.payer
                    transaction.payee = payerPayeeTuple.payee
                    transactions.append(transaction)
                }
                isDone.0 = true
                if isDone.0, isDone.1 {
                    completion(transactions, nil)
                }
            }
            References.Transactions.whereField(Keys.Transaction.Payer, isEqualTo: References.currentUser!).getDocuments { (data, err) in
                guard err == nil else { completion([], err); return }
                
                for document in data!.documents {
                    var transaction = Transaction(dict: document.data(), firebaseReference: document.reference)
                    let payerPayeeTuple = joinTransactionUsers(transaction: document, users: users)
                    transaction.payer = payerPayeeTuple.payer
                    transaction.payee = payerPayeeTuple.payee
                    transactions.append(transaction)
                }
                isDone.1 = true
                if isDone.0, isDone.1 {
                    completion(transactions, nil)
                }
            }
        }
        
    }
    
    /// Given a transactions and a list of users, this function extracts the appropriate user objects and returns them
    ///
    /// - Parameters:
    ///   - transaction: QueryDocumentSnapshot to extract (payer, payee) references from
    ///   - users: [QueryDocumentSnapshot] to retrieve appropriate user objects
    /// - Returns: Two user objects, payer and payee
    private static func joinTransactionUsers(transaction: QueryDocumentSnapshot,
                                             users: [QueryDocumentSnapshot]) -> (payer: User, payee: User) {
        let payerSnapshot = users.first(where: {$0.reference == transaction.data()[Keys.Transaction.Payer] as! DocumentReference})!
        let payeeSnapshot = users.first(where: {$0.reference == transaction.data()[Keys.Transaction.Payee] as! DocumentReference})!
        let payer = User(dict: payerSnapshot.data(), firebaseReference: payerSnapshot.reference)
        let payee = User(dict: payeeSnapshot.data(), firebaseReference: payeeSnapshot.reference)
        
        return (payer, payee)
    }
    
    /// Description
    ///
    /// - Parameter completion: completion description
    static func getTransactionsForAndAgainst(completion: @escaping ([Transaction], [Transaction], Error?)->Void) {
        if References.currentUser == nil {
            let vId = Auth.auth().currentUser?.uid
            References.currentUser = References.Users.document(vId!)
        }
        References.Transactions.whereField(Keys.Transaction.Payer, isEqualTo: References.currentUser!).getDocuments { (data, err) in
            guard err == nil else { completion([], [], err); return }
            var transactionsFor: [Transaction] = []
            for document in data!.documents {
                transactionsFor.append(Transaction(dict: document.data(), firebaseReference: document.reference))
            }
            References.Transactions.whereField(Keys.Transaction.Payee, isEqualTo: References.currentUser!).getDocuments(completion: { (data, err) in
                guard err == nil else { completion(transactionsFor, [], err); return }
                var transactionsAgainst: [Transaction] = []
                for document in data!.documents {
                    transactionsAgainst.append(Transaction(dict: document.data(), firebaseReference: document.reference))
                }
            })
        }
    }
    
    
    
}
