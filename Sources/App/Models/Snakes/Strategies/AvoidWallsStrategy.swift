//
//  AvoidWallsStrategy.swift
//  App
//
//  Created by Jonathan Bennett on 2020-04-25.
//

struct AvoidWalls: Strategy {
    func suggestDirection(_ me: Snake, board: Board) -> DirectionSet {
        var directions = DirectionSet()
        
        Direction.allCases.forEach { direction in
            if !board.isValid(me.head.go(direction)) {
                directions.subtract(Constants.avoidWalls, direction)
            }
        }
        
        return directions
    }
}

