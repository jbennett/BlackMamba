//
//  constants.swift
//  App
//
//  Created by Jonathan Bennett on 2020-04-13.
//
import Vapor

enum Constants {
    
    static let foodSeeking = 1000
    static let moveBias = 10
    static let avoidWalls = 100000
    static let avoidSnakeHeads = 500
    static let avoidSnakeBodies = 100000
    
    static var isMulticolored: Bool = {
        return Environment.get("env") != "prod"
    }()
    
}
