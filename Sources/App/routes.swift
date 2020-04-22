import Vapor

var logger: ((String) -> Void) = { print($0) }
/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.get { _ in
        return "Battlesnake"
    }

    router.post("/ping") { _ in
        return "pong\n"
    }

    router.post("/start") { _ -> String in
        let colors = ["#4d9dff", "#dabaff", "#fe806f", "#292a30", "#6e7883", "#ff8170", "#1d2022", "#1c4877", "#007aff"]
        let color = Constants.isMulticolored ? colors.random! : "#f5af10"
        
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
        logger = { print("Turn \(move.turn): \($0)") }
        var directions = DirectionSet()
        
        directions += avoidWalls(snake: move.you, board: move.board)
        directions += avoidSnakeBodies(snake: move.you, board: move.board)
        directions += avoidSnakeHeads(snake: move.you, board: move.board)
        // attack short snakes
        directions += seekFood(snake: move.you, board: move.board)
        directions += avoidDeadEnds(snake: move.you, board: move.board)
        directions += chaseTail(snake: move.you, board: move.board)
        
//        logger("\(move.you.head): \(directions)")
        return """
{
        "move": "\(directions.preferredDirection)"
}
"""
    }

    router.post("/end") { req -> String in
//        print("ended Game\n")
        return "ok\n"
    }
}

func avoidWalls(snake: Snake, board: Board) -> DirectionSet {
    var directions = DirectionSet()
    
    Direction.allCases.forEach { direction in
        if !board.isValid(snake.head.go(direction)) {
            directions.subtract(Constants.avoidWalls, direction)
        }
    }
    
    return directions
}

func avoidSnakeBodies(snake: Snake, board: Board) -> DirectionSet {
    var directions = DirectionSet()
    
    let up = snake.head.go(.up)
    let down = snake.head.go(.down)
    let left = snake.head.go(.left)
    let right = snake.head.go(.right)
    
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

func avoidSnakeHeads(snake: Snake, board: Board) -> DirectionSet {
    var directions = DirectionSet()
    
    let up = snake.head.go(.up)
    let down = snake.head.go(.down)
    let left = snake.head.go(.left)
    let right = snake.head.go(.right)
        
    for enemy in board.snakes {
        if enemy.id == snake.id { continue } // ignore self
        if enemy.length < snake.length { continue } // ignore smaller snakes
        
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

func seekFood(snake: Snake, board: Board) -> DirectionSet {
    var directions = DirectionSet()
    
    // do i need food?
    // how far away should I go for
    // if my health is good i should suggest
    
    let closestFood = board.food.reduce(board.food.first!) { closest, current in
        let closestDistance = closest.distanceSquared(to: snake.head)
        let currentDistance = current.distanceSquared(to: snake.head)
        let winner =  closestDistance < currentDistance ? closest : current
        return winner
    }

    let directionsTowardsFood = snake.head.directionsTowards(closestFood)
    for direction in directionsTowardsFood {
        directions.add(Constants.foodSeeking, direction)
    }


    return directions
}

func avoidDeadEnds(snake: Snake, board: Board) -> DirectionSet {
    var directions = DirectionSet()
//    availableNextMoves(position: snake.head, board: board).forEach { directions.add(Constants.moveBias, $0) }
    
    Direction.allCases.forEach { direction in
        let availablePositions = floodFill(position: snake.head.go(direction), board: board)
//        logger("Fill: \(direction) -> \(availablePositions.count)")
        directions.add(availablePositions.count * Constants.moveBias, direction)
    }
    
    return directions
}

func floodFill(position: Position, board: Board) -> Set<Position> {
    guard board.isAvailable(position) else { return [] }
    let positionsCap = 100
    
    var testedPositions = Set<Position>()
    var positionsToTest = Set<Position>([position])
    var availablePositions = Set<Position>()
    
    while !positionsToTest.isEmpty && availablePositions.count < positionsCap {
        let currentPosition = positionsToTest.removeFirst()
        if board.isAvailable(currentPosition) && !testedPositions.contains(currentPosition) {
            availablePositions.insert(currentPosition)
            
            Direction.allCases.forEach { positionsToTest.insert(currentPosition.go($0)) }
        }
        
        testedPositions.insert(currentPosition)
    }

    return availablePositions
}

func availableNextMoves(position: Position, board: Board, maxDepth: Int = 8, currentDepth: Int = 1) -> [Direction] {
    let availableDirections = Direction.allCases
        .filter { board.isAvailable(position.go($0)) }
    guard currentDepth < maxDepth else {
        return availableDirections
    }
    
    return availableDirections.filter { availableNextMoves(position: position.go($0), board: board, currentDepth: currentDepth + 1).count > 0 }
}

func availableMovesScore(starting: Position, board: Board, currentDepth: Int = 1, maxDepth: Int = 5) -> Int {
    guard currentDepth < maxDepth else {
        return 0
    }
    
    let adjacentPositions = starting.adjacentPositions
    let availablePositions = adjacentPositions.filter { board.isAvailable($0) }
    
    let currentDepthValue = availablePositions.count * Constants.moveBias * currentDepth
    let nextDepthValue = availablePositions.map { availableMovesScore(starting: $0, board: board, currentDepth: currentDepth + 1) }.reduce(0, { $0 + $1 })
    
    return currentDepthValue + nextDepthValue
}

func chaseTail(snake me: Snake, board: Board) -> DirectionSet {
    var directions = DirectionSet()
    guard me.health > 50 else { return directions }
    guard me.length > 10 else { return directions }
    // length should be competative with other snakes? 80% of others?
    
    // target the location of the tail for the next round
    me.head.directionsTowards(me.futureTail).forEach { directions.add(Constants.seekTail, $0) }
    
    return directions
}
