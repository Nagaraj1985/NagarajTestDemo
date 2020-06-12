//
//  ContactList.swift
//  NagarajTest
//
//  Created by Nagaraj Panni on 09/06/20.
//  Copyright © 2020 Nagaraj Panni. All rights reserved.
//

import Foundation

// MARK: - ContactList
class ContactList {
    let success: Int
    let msg: String
    let data: [DataContacts]
    
    init(success: Int, msg: String, data: [DataContacts]) {
        self.success = success
        self.msg = msg
        self.data = data
    }
}

// MARK: - Datum
class DataContacts {
    let firstName, lastName: String
    let mobileNumber: Int
    let emailID: String
    let profileImage: String?
    
    init(firstName: String, lastName: String, mobileNumber: Int, emailID: String, profileImage: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.mobileNumber = mobileNumber
        self.emailID = emailID
        self.profileImage = profileImage
    }
}
