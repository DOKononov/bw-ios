//
//  AuthError.swift
//  BeWired
//
//  Created by Dmitry Kononov on 6.05.23.
//

import Foundation

enum AuthError: Error {
    case setPhoneNumberError
    case confirmPhoneNumberError
    case logoutError
    case getCurrentUserError
    case setLogVerbosityLevelError
    case autorizationStateError
}
