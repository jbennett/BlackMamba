//
//  Snake.swift
//  App
//
//  Created by Jonathan Bennett on 2020-04-13.
//

import Vapor

struct Snake: Content {
    let id: String
    let name: String
    let health: Int
    let body: [Position]
    
    var head: Position {
        body.first!
    }
    
    var tail: Position {
        body.last!
    }
    
    var futureTail: Position {
        return body[body.count - 2]
    }
    
    var length: Int {
        body.count
    }
    
    var adjacentPositions: [Position] {
        return head.adjacentPositions
    }
    
    func covers(_ position: Position, ignoringLastTail: Bool = false) -> Bool {
        // don't remove the first position (head of snake) since that position will be a body by the time we take our turn
        // optionally remove the end of the tail since it will have moved by the time we take a turn
        // TODO: unless they eat food
        let effectiveBody = ignoringLastTail ? body.dropLast() : body
        
        return effectiveBody.contains(position)
    }
    
    func isApproaching(_ position: Position) -> Bool {
        let options = [head.go(.up), head.go(.down), head.go(.left), head.go(.right)]
        return options.contains(position)
    }
}
