//
//  Model.swift
//  Registration
//
//  Created by Александр Басов on 11/9/21.
//

import Firebase
import Foundation

struct User {
    
    // MARK: Lifecycle
    init(user: Firebase.User) {
        self.uid = user.uid
        self.email = user.email ?? ""
    }

    // MARK: Internal
    let uid: String
    let email: String
}


