//
//  User.swift
//  BeWired
//
//  Created by Dmitry Kononov on 10.05.23.
//

import Foundation

final class User {
    let firstName: String
    let lastName: String
    let id: Int
    let phoneNumber: String
    var profilePhotoData: Data?
    
    init(firstName: String,
         lastName: String,
         id: Int,
         phoneNumber: String,
         profilePhotoData: Data? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.phoneNumber = phoneNumber
        self.profilePhotoData = profilePhotoData
    }
    
}
