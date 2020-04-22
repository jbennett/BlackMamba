//
//  constants.swift
//  App
//
//  Created by Jonathan Bennett on 2020-04-13.
//
import Vapor

enum Constants {

    static let avoidWalls = 100000
    static let avoidSnakeBodies = 100000
    static let avoidSnakeHeads = 500
    static let moveBias = 20 // 5 moves trumps a food?
    static let foodSeeking = 100
    
    
    static var isMulticolored: Bool = {
        return Environment.get("env") != "prod"
    }()
    
}
