//
//  Documents.swift
//  Payup
//
//  Created by Ammar AlTahhan on 01/12/2018.
//  Copyright © 2018 Ammar AlTahhan. All rights reserved.
//

import Foundation
import Firebase

struct References {
    static let DB = Firestore.firestore()
    static var currentUser: DocumentReference?
    static let Users = DB.collection("users")
    static let Transactions = DB.collection("transactions")
}

struct Keys {
    static let Created = "created"
    static let LastUpdated = "lastUpdated"
    
    struct User {
        static let Fullname = "fullName"
        static let MobileNumber = "mobileNumber"
        static let Transactions = "transactions"
    }
    
    struct Transaction {
        static let Payer = "payer"
        static let Amount = "amount"
        static let Payee = "payee"
        static let IsPaid = "isPaid"
        static let Description = "description"
    }
}
