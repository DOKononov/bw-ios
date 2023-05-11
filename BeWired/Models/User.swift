//
//  User.swift
//  BeWired
//
//  Created by Dmitry Kononov on 10.05.23.
//

import UIKit

final class User {
    let firstName: String
    let lastName: String
    let id: Int
    let phoneNumber: String
    var profilePhoto: UIImage?
    
    init(firstName: String,
         lastName: String,
         id: Int,
         phoneNumber: String,
         profilePhoto: UIImage?)
    {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.phoneNumber = phoneNumber
        self.profilePhoto = profilePhoto
    }
    
}
