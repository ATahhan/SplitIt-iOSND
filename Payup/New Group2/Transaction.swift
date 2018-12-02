//
//  Transaction.swift
//  Payup
//
//  Created by Ammar AlTahhan on 02/12/2018.
//  Copyright © 2018 Ammar AlTahhan. All rights reserved.
//

import Foundation
import Firebase

struct Transaction: FirebaseReferencable {
    var reference: DocumentReference
    var payer: User
    var amount: Double
    var payee: User
    var isPayed: Bool
    var description: String
    
    func getDict() -> [String: Any] {
        let dict: [String: Any] = [
            Keys.Transaction.Payee: payee.reference,
            Keys.Transaction.Payer: payer.reference,
            Keys.Transaction.Amount: amount,
            Keys.Transaction.IsPaid: isPayed,
            Keys.Transaction.Description: description
        ]
        
        return dict
    }
    
//    static func getObject(from dict: [String: Any]) -> Transaction {
//        let transaction = Transaction(reference: <#T##DocumentReference#>,
//                                      payer: dict[Keys.Transaction.Payer],
//                                      amount: <#T##Double#>,
//                                      payee: <#T##User#>,
//                                      isPayed: <#T##Bool#>,
//                                      description: <#T##String#>)
//    }
}
