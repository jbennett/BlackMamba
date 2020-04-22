//
//  Food.swift
//  App
//
//  Created by Jonathan Bennett on 2020-04-13.
//

import Vapor

struct Position: Content, Equatable, Hashable {
    let x: Int
    let y: Int
    
    var adjacentPositions: [Position] {
        return Direction.allCases.map { go($0) }
    }
    
    func go(_ direction: Direction) -> Position {
        switch direction {
        case .up:
            return Position(x: x, y: y - 1)
        case .down:
            return Position(x: x, y: y + 1)
        case .left:
            return Position(x: x - 1, y: y)
        case .right:
            return Position(x: x + 1, y: y)
        
        }
    }
    
    
    
    func distanceSquared(to other: Position) -> Int {
        return (x - other.x) ^ 2 + (y - other.y) ^ 2
    }
    
    func directionsTowards(_ position: Position) -> [Direction] {
        var directions: [Direction] = []
        
        if position.x > x {
            directions.append(.right)
        }
        
        if position.x < x {
            directions.append(.left)
        }
        
        if position.y > y {
            directions.append(.down)
        }
        
        if position.y < y {
            directions.append(.up)
        }
        
        return directions
    }
}
