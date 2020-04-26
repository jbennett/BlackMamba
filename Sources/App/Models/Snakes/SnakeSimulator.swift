//
//  SnakeSimulator.swift
//  App
//
//  Created by Jonathan Bennett on 2020-04-25.
//

protocol SnakeSimulator {
    func getMove(_ me: Snake, board: Board) -> (Direction, Board)
}
