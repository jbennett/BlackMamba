//
//  ChaseTailStrategy.swift
//  App
//
//  Created by Jonathan Bennett on 2020-04-26.
//

struct ChaseTail: Strategy {
    func suggestDirection(_ me: Snake, board: Board) -> DirectionSet {
        var directions = DirectionSet()
        guard me.health > 50 else { return directions }
        guard me.length > 10 else { return directions }
        // length should be competative with other snakes? 80% of others?
        
        // target the location of the tail for the next round
        me.head.directionsTowards(me.futureTail).forEach { directions.add(Constants.seekTail, $0) }
        
        return directions
    }
}
