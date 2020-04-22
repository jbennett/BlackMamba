//
//  Board.swift
//  App
//
//  Created by Jonathan Bennett on 2020-04-13.
//

import Vapor

struct Board: Content {
    let width: Int
    let height: Int
    
    let food: [Position]
    let snakes: [Snake]
    
    func isAvailable(_ position: Position) -> Bool {
        return isValid(position) && isPositionClear(position)
    }
    
    func isPositionClear(_ position: Position) -> Bool {
        for snake in snakes {
            if snake.covers(position) {
                return false
            }
        }
        
        return true
    }
    
    func isValid(_ position: Position) -> Bool {
        return position.x >= 0 &&
        position.x < width &&
        position.y >= 0 &&
        position.y < height
    }
}
