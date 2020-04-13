import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.get { _ in
        return "Battlesnake"
    }

    router.post("/ping") { _ in
        return "pong\n"
    }

    router.post("/start") { _ -> String in
        let colors = ["#f5af10", "#4d9dff", "#dabaff", "#fe806f", "#292a30", "#6e7883", "#ff8170", "#1d2022", "#1c4877", "#007aff"]
        let color = Constants.isMulticolored ? colors.random! : colors.first!
        
        return """
{
        "color": "\(color)",
    "headType": "silly",
    "tailType": "bolt"
}
"""
    }
    
    router.post(MoveData.self, at: "/move") { req, move -> String in
//        print(move)
        var directions: [Direction: Int] = [.up: 0, .down: 0, .left: 0, .right: 0]
        
        /// avoid walls
        if (move.you.body[0].x == 0) {
            directions[.left]! -= Constants.avoidWalls
        }
        if (move.you.body[0].y == 0) {
            directions[.up]! -= Constants.avoidWalls
        }

        if move.you.body[0].x == move.board.width - 1 {
            directions[.right]! -= Constants.avoidWalls
        }

        if move.you.body[0].y == move.board.height - 1 {
            directions[.down]! -= Constants.avoidWalls
        }

        // avoid snakes
        let up = move.you.body[0].go(.up)
        let down = move.you.body[0].go(.down)
        let left = move.you.body[0].go(.left)
        let right = move.you.body[0].go(.right)
        
        for enemy in move.board.snakes {
            if (enemy.covers(up)) {
                directions[.up]! -= Constants.avoidSnakeBodies
            }
            if (enemy.covers(down)) {
                directions[.down]! -= Constants.avoidSnakeBodies
            }
            if (enemy.covers(left)) {
                directions[.left]! -= Constants.avoidSnakeBodies
            }
            if (enemy.covers(right)) {
                directions[.right]! -= Constants.avoidSnakeBodies
            }
            
            // avoid their next move
            if (enemy.isApproaching(up)) {
                directions[.up]! -= Constants.avoidSnakeHeads
            }
            if (enemy.isApproaching(down)) {
                directions[.down]! -= Constants.avoidSnakeHeads
            }
            if (enemy.isApproaching(left)) {
                directions[.left]! -= Constants.avoidSnakeHeads
            }
            if (enemy.isApproaching(right)) {
                directions[.right]! -= Constants.avoidSnakeHeads
            }
        }
        
        // seek food
        let closestFood = move.board.food.reduce(move.board.food.first!) { closest, current in
            let closestDistance = closest.distanceSquared(to: move.you.head)
            let currentDistance = current.distanceSquared(to: move.you.head)
            return closestDistance < currentDistance ? closest : current
        }
        let directionsTowardsFood = move.you.head.directionsTowards(closestFood)
        for direction in directionsTowardsFood {
            directions[direction]! += Constants.foodSeeking
        }
//        print("\(move.you.head): \(closestFood), \(move.board.food)")
        
        // avoid single dead ends
//        var depth = 0
//        let maxDepth = 3
        move.you.adjacentPositions
            .filter { move.board.isPositionClear($0) }
            .forEach { position in
                let nextDirections = move.you.head.directionsTowards(position)
                nextDirections.forEach { directions[$0]! += Constants.moveBias }
                
                position.adjacentPositions
                    .filter { move.board.isPositionClear($0) }
                    .forEach { position in
                        let nextDirections = move.you.head.directionsTowards(position)
                        nextDirections.forEach { directions[$0]! += Constants.moveBias * 2 }
                        
                        position.adjacentPositions
                            .filter { move.board.isPositionClear($0) }
                            .forEach { position in
                                let nextDirections = move.you.head.directionsTowards(position)
                                nextDirections.forEach { directions[$0]! += Constants.moveBias * 3 }
                                
                                position.adjacentPositions
                                    .filter { move.board.isPositionClear($0) }
                                    .forEach { position in
                                        let nextDirections = move.you.head.directionsTowards(position)
                                        nextDirections.forEach { directions[$0]! += Constants.moveBias * 4 }
                                    }
                            }
                    }
            }
        
        
        
        // avoid self
        // avoid walls
        // cut off other snakes
        // eat shorter adjacent snakes
        // avoid other snakes
        // avoid deadends (A*?)
        // chase tail
        
        // make better future decisions ie dont get stuck in corners
        
        let direction = directions.sorted { a, b in a.value > b.value }.first!.key
//        print("\(move.you.head): \(directions)")
        
        return """
{
    "move": "\(direction)"
}
"""
    }

    router.post("/end") { _ in
        return "ok\n"
    }
}

func availableMovesScore(starting: Position, board: Board, currentDepth: Int = 1, maxDepth: Int = 5) -> Int {
    guard currentDepth < maxDepth else {
        return 0
    }
    
    let adjacentPositions = starting.adjacentPositions
    let availablePositions = adjacentPositions.filter { board.isPositionClear($0) }
    
    let currentDepthValue = availablePositions.count * Constants.moveBias * currentDepth
    let nextDepthValue = availablePositions.map { availableMovesScore(starting: $0, board: board, currentDepth: currentDepth + 1) }.reduce(0, { $0 + $1 })
    
    return currentDepthValue + nextDepthValue
}
