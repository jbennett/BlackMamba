//
//  SeekFoodStrategy.swift
//  App
//
//  Created by Jonathan Bennett on 2020-04-26.
//

struct SeekFood: Strategy {
    
    func suggestDirection(_ me: Snake, board: Board) -> DirectionSet {
        var directions = DirectionSet()
        
        // do i need food?
        // how far away should I go for
        // if my health is good i should suggest
        
        let closestFood = board.food.reduce(board.food.first!) { closest, current in
            let closestDistance = closest.distanceSquared(to: me.head)
            let currentDistance = current.distanceSquared(to: me.head)
            let winner =  closestDistance < currentDistance ? closest : current
            return winner
        }

        let directionsTowardsFood = me.head.directionsTowards(closestFood)
        for direction in directionsTowardsFood {
            directions.add(Constants.foodSeeking, direction)
        }


        return directions
    }
}
