//
//  UserRoom.swift
//  Gobang
//
//  Created by User06 on 2023/5/27.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift


struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var nickname: String
    var Account: String
    var password: String
    var authId: String
    //var total_score: Int = 0
    var records: [MyRecord]
    
    init() {
        self.nickname = ""
        self.Account = ""
        self.password = ""
        self.authId = ""
        self.records = []
    }

}

struct UserInRoom: Codable, Identifiable {
    var id: String
    var nickname: String = ""
    var isHost: Bool
    var isReady: Bool = false
    
    init(id: String, nickname: String, isHost: Bool) {
        self.id = id
        self.nickname = nickname
        self.isHost = isHost
    }
    
    var dictionary: [String: Any] {
        return ["id": self.id,
                "nickname": self.nickname,
                "isHost": self.isHost,
                "isReady": self.isReady]
    }
}

struct Room: Codable, Identifiable {
    @DocumentID var id: String?
    var users: [UserInRoom] = []
    var invitationCode: String = ""
    var isPlaying: Bool = false
    var GameID: String = ""
    
    init() {
        self.invitationCode = generateCode()
    }
    
    func generateCode() -> String {
        return String(Int.random(in: 10000..<99999))
    }
}

struct MyRecord: Identifiable, Codable {
    var id: Int
    var result: String
    var score: Int
    var total_score: Int = 0
    
    var dictionary: [String: Any] {
        return ["id": self.id,
                "result": self.result,
                "score": self.score,
                "total_score": self.total_score]
    }
}


/*
 struct UserInfo: Codable {
     var birthday: Date = Date()
     var constellation: String = ""
     var gender: String = ""
     var nickname: String = ""
     
     var dictionary: [String: Any] {
         return ["birthday": self.birthday,
                 "constellation": self.constellation,
                 "gender": self.gender,
                 "nickname": self.nickname]
     }
 }
 */
