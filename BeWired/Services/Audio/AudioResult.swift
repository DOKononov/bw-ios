//
//  AudioResult.swift
//  BeWired
//
//  Created by Dmitry Kononov on 18.05.23.
//

import Foundation

typealias AudioResult<T> = (Result<T, Error>) -> Void

