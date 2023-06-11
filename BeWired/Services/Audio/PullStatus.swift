//
//  PullStatus.swift
//  BeWired
//
//  Created by Dmitry Kononov on 7.06.23.
//

enum PullStatus {
    case inprogress
    case done(_ count: Int)
    case empty
}
