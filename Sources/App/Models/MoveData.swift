//
//  MoveData.swift
//  App
//
//  Created by Jonathan Bennett on 2020-04-13.
//

import Vapor

struct MoveData: Content {
    let game: Game
    let turn: Int
    let board: Board
    let you: Snake
}
