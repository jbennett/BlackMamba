//
//  EchoMiddleware.swift
//  App
//
//  Created by Jonathan Bennett on 2020-04-13.
//

import Vapor

final class EchoMiddleware: Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        print(request)
        
        return try next.respond(to: request)
    }
}
