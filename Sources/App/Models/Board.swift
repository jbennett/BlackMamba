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
    
    func isPositionClear(_ position: Position) -> Bool {
        if position.x < 0 ||
            position.x > width - 1 ||
            position.y < 0 ||
            position.y > height - 1 {
             return false
        }
        
        for snake in snakes {
            if snake.covers(position) {
                return false
            }
        }
        
        return true
    }
}
