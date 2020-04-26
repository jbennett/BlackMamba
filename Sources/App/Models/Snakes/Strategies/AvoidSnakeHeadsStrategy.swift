//
//  AvoidSnakeHeadsStrategy.swift
//  App
//
//  Created by Jonathan Bennett on 2020-04-26.
//

struct AvoidSnakeHeads: Strategy {
    func suggestDirection(_ me: Snake, board: Board) -> DirectionSet {
        var directions = DirectionSet()
        
        let up = me.head.go(.up)
        let down = me.head.go(.down)
        let left = me.head.go(.left)
        let right = me.head.go(.right)
            
        for enemy in board.snakes {
            if enemy.id == me.id { continue } // ignore self
            if enemy.length < me.length { continue } // ignore smaller snakes
            
            if (enemy.isApproaching(up)) {
                directions.subtract(Constants.avoidSnakeHeads, .up)
            }
            if (enemy.isApproaching(down)) {
                directions.subtract(Constants.avoidSnakeHeads, .down)
            }
            if (enemy.isApproaching(left)) {
                directions.subtract(Constants.avoidSnakeHeads, .left)
            }
            if (enemy.isApproaching(right)) {
                directions.subtract(Constants.avoidSnakeHeads, .right)
            }
        }
        
        return directions
    }
}
