//
//  Firebase.swift
//  Payup
//
//  Created by Ammar AlTahhan on 02/12/2018.
//  Copyright © 2018 Ammar AlTahhan. All rights reserved.
//

import Foundation
import Firebase

protocol FirebaseReferencable {
    var reference: DocumentReference { get set }
}
