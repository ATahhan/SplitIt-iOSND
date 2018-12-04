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
    var reference: DocumentReference?
    var fullName: String
    var mobileNumber: String

    public init(reference: DocumentReference?, fullName: String, mobileNumber: String) {
        self.reference = reference
        self.fullName = fullName
        self.mobileNumber = mobileNumber
    }
    
    func getDict() -> [String: Any] {
        let dict: [String: Any] = [
            Keys.User.Fullname: fullName,
            Keys.User.MobileNumber: mobileNumber
        ]
        
        return dict
    }
}

extension User {
    init(dict: [String: Any], firebaseReference: DocumentReference) {
        self.fullName = dict[Keys.User.Fullname] as? String ?? ""
        self.mobileNumber = dict[Keys.User.MobileNumber] as? String ?? ""
        self.reference = firebaseReference
    }
}

extension User {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.reference == rhs.reference
    }
}

var currentUser: User?
