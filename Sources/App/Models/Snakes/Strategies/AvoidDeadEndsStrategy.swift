//
//  AvoidDeadEndsStrategy.swift
//  App
//
//  Created by Jonathan Bennett on 2020-04-26.
//

struct AvoidDeadEnds: Strategy {
    func suggestDirection(_ me: Snake, board: Board) -> DirectionSet {
        var directions = DirectionSet()
            
        Direction.allCases.forEach { direction in
            let availablePositions = floodFill(position: me.head.go(direction), board: board)
            directions.add(availablePositions.count * Constants.moveBias, direction)
        }
                
        return directions
    }
    
    private func floodFill(position: Position, board: Board) -> Set<Position> {
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
}
