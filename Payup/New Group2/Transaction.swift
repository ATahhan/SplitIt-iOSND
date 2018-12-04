//
//  Transaction.swift
//  Payup
//
//  Created by Ammar AlTahhan on 02/12/2018.
//  Copyright © 2018 Ammar AlTahhan. All rights reserved.
//

import Foundation
import Firebase


enum Payment: String {
    case forUser = "I payed for"
    case againstUser = "I owe"
}

struct Transaction: FirebaseReferencable {
    var reference: DocumentReference?
    var payer: User!
    var amount: Double
    var payee: User!
    var isPayed: Bool
    var description: String

    public init(reference: DocumentReference? = nil, payer: User!, amount: Double, payee: User!, isPayed: Bool = false, description: String = "") {
        self.reference = reference
        self.payer = payer
        self.amount = amount
        self.payee = payee
        self.isPayed = isPayed
        self.description = description
    }
    
    func getDict() -> [String: Any] {
        let dict: [String: Any] = [
            Keys.Transaction.Payee: payee.reference!,
            Keys.Transaction.Payer: payer.reference!,
            Keys.Transaction.Amount: amount,
            Keys.Transaction.IsPaid: isPayed,
            Keys.Transaction.Description: description
        ]
        
        return dict
    }
}

extension Transaction {
    init(dict: [String: Any], firebaseReference: DocumentReference) {
        self.amount = dict[Keys.Transaction.Amount] as! Double
        self.isPayed = dict[Keys.Transaction.IsPaid] as! Bool
        self.description = dict[Keys.Transaction.Description] as! String
        self.reference = firebaseReference
    }
}

extension Transaction {
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.reference == rhs.reference
    }
}
