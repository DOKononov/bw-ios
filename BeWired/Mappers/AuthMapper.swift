//
//  AuthMapper.swift
//  BeWired
//
//  Created by Dmitry Kononov on 10.05.23.
//

import Foundation
import TDLibKit

protocol AuthMapperProtocol {
    func map(user: TDLibKit.User) -> User
}

final class AuthMapper: AuthMapperProtocol {
    
    func map(user: TDLibKit.User) -> User {
        return User(firstName: user.firstName,
                    lastName: user.lastName,
                    id: Int(user.id),
                    phoneNumber: user.phoneNumber)
    }
}
