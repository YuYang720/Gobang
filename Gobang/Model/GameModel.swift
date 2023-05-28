//
//  GameModel.swift
//  Gobang
//
//  Created by User06 on 2023/5/28.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct Game: Codable, Identifiable {
    @DocumentID var id: String?
    var players: [Player]
    var flag: Int
    var winner: Int
    var isGameOver: Bool = false
    var chessboard: [Chessboard]
    
    init(flag: Int, winner:Int) {
        self.flag = flag
        self.winner = winner
        self.chessboard = Game.generateBoard()
        self.players = Game.generatePlayers()
    }
    
    static func generatePlayers() -> [Player] {
            return [Player(id: 0, side: "black"), Player(id: 1, side: "white")]
    }
    
    static func generateBoard() -> [Chessboard] {
            return [Chessboard](repeating: Chessboard(data: "none"), count: 81)
    }
    /*mutating func generateChessboard() {
        for number in 0...<81 {
            self.chessboard.append()_
        }
    }*/
}

struct Player: Codable, Identifiable {
    var id: Int
    var nickname: String = ""
    var side: String // black--player1, white--player2
    var winning: Bool = false
    
    var dictionary: [String: Any] {
        return ["id": self.id,
                "nickname": self.nickname,
                "side": self.side,
                "winning": self.winning]
    }
    
}

struct Chessboard: Codable {
    var data: String // "none" "black" "white"
}


//var boards = [String](repeating: "無", count: 81)

/*error message: 'self' used before all stored properties are initialized :22 lines*/

