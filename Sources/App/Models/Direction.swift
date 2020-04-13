//
//  directions.swift
//  App
//
//  Created by Jonathan Bennett on 2020-04-13.
//

enum Direction: String, CaseIterable {
    case up
    case down
    case left
    case right
    
    var opposite: Direction {
        switch self {
        case .up:
            return .down
        case .down:
            return .up
        case .left:
            return .right
        case .right:
            return .left
        }
    }
}
