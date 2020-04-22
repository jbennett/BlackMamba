//
//  DirectionSet.swift
//  App
//
//  Created by Jonathan Bennett on 2020-04-14.
//


struct DirectionSet {
    
    var up = 0
    var down = 0
    var left = 0
    var right = 0
    
    var preferredDirection: Direction {
        if up >= down && up >= left && up >= right {
            return .up
        } else if down >= left && down >= right {
            return .down
        } else if left >= right {
            return .left
        } else {
            return .right
        }
        
    }
    
    mutating func add(_ amount: Int, _ direction: Direction) {
        switch direction {
        case .up:
            up += amount
        case .down:
            down += amount
        case .left:
            left += amount
        case .right:
            right += amount
        }
    }
    
    mutating func subtract(_ amount: Int, _ direction: Direction) {
        switch direction {
        case .up:
            up -= amount
        case .down:
            down -= amount
        case .left:
            left -= amount
        case .right:
            right -= amount
        }
    }
}

extension DirectionSet {
    static func +=(lhs: inout DirectionSet, rhs: DirectionSet) {
        lhs.up += rhs.up
        lhs.down += rhs.down
        lhs.left += rhs.left
        lhs.right += rhs.right
    }
    
    static func -=(lhs: inout DirectionSet, rhs: DirectionSet) {
        lhs.up -= rhs.up
        lhs.down -= rhs.down
        lhs.left -= rhs.left
        lhs.right -= rhs.right
    }
}
