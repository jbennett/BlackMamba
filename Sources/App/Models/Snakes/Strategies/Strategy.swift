//
//  BlackMambaStrategy.swift
//  App
//
//  Created by Jonathan Bennett on 2020-04-25.
//

protocol Strategy {
    func suggestDirection(_ me: Snake, board: Board) -> DirectionSet
}
