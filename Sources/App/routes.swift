import Vapor

var logger: ((String) -> Void) = { print($0) }
/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.get { req -> Future<View> in
        return try req.view().render("home.leaf", ["name": "Jonathan"])
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
//        logger = { print("Turn \(move.turn): \($0)") }
        let simulator = BlackMamba()
//        logger("\(move.you.head): \(simulator.getMove(move.you, board: move.board))")
        return """
        { "move": "\(simulator.getMove(move.you, board: move.board).0)" }
"""
    }

    router.post("/end") { req -> String in
        return "ok\n"
    }
}
