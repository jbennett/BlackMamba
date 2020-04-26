//
//  AvoidSnakeBodiesStrategy.swift
//  App
//
//  Created by Jonathan Bennett on 2020-04-26.
//

struct AvoidSnakeBodies: Strategy {
    func suggestDirection(_ me: Snake, board: Board) -> DirectionSet {
        var directions = DirectionSet()
        
        let up = me.head.go(.up)
        let down = me.head.go(.down)
        let left = me.head.go(.left)
        let right = me.head.go(.right)
        
        let ignoreEndOfTail = true // TODO: only if not at food…
            
        for enemy in board.snakes {
            if (enemy.covers(up, ignoringLastTail: ignoreEndOfTail)) {
                directions.subtract(Constants.avoidSnakeBodies, .up)
            }
            if (enemy.covers(down, ignoringLastTail: ignoreEndOfTail)) {
                directions.subtract(Constants.avoidSnakeBodies, .down)
            }
            if (enemy.covers(left, ignoringLastTail: ignoreEndOfTail)) {
                directions.subtract(Constants.avoidSnakeBodies, .left)
            }
            if (enemy.covers(right, ignoringLastTail: ignoreEndOfTail)) {
                directions.subtract(Constants.avoidSnakeBodies, .right)
            }
        }
        
        return directions
    }
}
