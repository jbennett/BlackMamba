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
    
    var length: Int {
        body.count
    }
    
    var adjacentPositions: [Position] {
        return head.adjacentPositions
    }
    
    func covers(_ position: Position) -> Bool {
        // don't remove the first position (head of snake) since that position will be a body by the time we take our turn
        return body.contains(position)
    }
    
    func isApproaching(_ position: Position) -> Bool {
        let options = [head.go(.up), head.go(.down), head.go(.left), head.go(.right)]
        return options.contains(position)
    }
}
