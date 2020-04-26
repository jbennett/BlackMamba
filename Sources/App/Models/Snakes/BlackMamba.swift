//
//  BlackMamba.swift
//  App
//
//  Created by Jonathan Bennett on 2020-04-25.
//

struct BlackMamba: SnakeSimulator {
    
    var strategies: [Strategy] = [
        AvoidWalls(),
        AvoidSnakeBodies(),
        AvoidSnakeHeads(),
        SeekFood(),
        AvoidDeadEnds(),
        ChaseTail(),
        
    ]
    
    func getMove(_ me: Snake, board: Board) -> (Direction, Board) {
        var directions = DirectionSet()
        
        strategies.forEach { strategy in
            directions += strategy.suggestDirection(me, board: board)
        }
        
        return (directions.preferredDirection, board)
    }
}
