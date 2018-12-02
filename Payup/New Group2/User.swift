//
//  User.swift
//  Payup
//
//  Created by Ammar AlTahhan on 02/12/2018.
//  Copyright © 2018 Ammar AlTahhan. All rights reserved.
//

import Foundation
import Firebase

struct User: FirebaseReferencable {
    var reference: DocumentReference
    var firstname: String
    var lastname: String
    var mobileNumber: String
    
    func getDict() -> [String: Any] {
        let dict: [String: Any] = [
            Keys.User.Firstname: firstname,
            Keys.User.Lastname: lastname,
            Keys.User.MobileNumber: mobileNumber
        ]
        
        return dict
    }
    
//    static func getObject(from document: DocumentReference) -> Transaction {
//        let user = User(reference: document,
//                        firstname: document.data(),
//                        lastname: <#T##String#>,
//                        mobileNumber: <#T##String#>)
//    }
}
