//
//  GameControl.swift
//  Gobang
//
//  Created by User06 on 2023/5/27.
//

import SwiftUI
import AVFoundation

class GameControl: StateControl, ObservableObject {
    @Published var room: Room = Room()
    @Published var game: Game = Game(flag:0, winner: -1)
    @Published var enterCode = ""
    @Published var playerIdx = 0
    var playerID = ""
    
    func createRoomBtn(user: User, completion: @escaping () -> Void) {
        self.room = Room()
        self.playerID = UUID().uuidString
        self.playerIdx = 0
        self.room.users.append(UserInRoom(id: playerID, nickname: user.nickname, isHost: true))
        createRoom(room: self.room) { room in
            self.room = room
            print(self.room.id!)
            completion()
        }
    }
    
    func joinRoomBtn(user: User, completion: @escaping (Bool) -> Void) {
        isRoomExist(invitationCode: self.enterCode) { [self] (result, room) in
            switch result {
            case true:
                self.room = room
                self.playerID = UUID().uuidString
                self.playerIdx = self.room.users.count
                self.room.users.append(UserInRoom(id: self.playerID, nickname: user.nickname, isHost: false))
                updateRoomUsers(id: room.id!, roomUsersDictionary: roomUsersToDictionary())
                completion(true)
            case false:
                completion(false)
            }
        }
    }
    
    func roomUsersToDictionary() -> [Dictionary<String, Any>] {
        var resultDictionary: [Dictionary<String, Any>] = []
        for user in self.room.users {
            resultDictionary.append(user.dictionary)
        }
        return resultDictionary
    }
    
    func deleteUser() {
        room.users.remove(at: self.playerIdx)
        updateRoomUsers(id: self.room.id!, roomUsersDictionary: roomUsersToDictionary())
    }
    
    func ExitRoomBtn() {
        if self.room.users[playerIdx].isHost {
            deleteRoom(id: self.room.id!)
        }
        else {
            deleteUser()
        }
    }
    
    func roomBtn() -> String {
        if self.room.users[playerIdx].isHost {
            return startGameBtn().rawValue
        }
        else {
            self.room.users[playerIdx].isReady.toggle()
            updateRoomUsers(id: self.room.id!, roomUsersDictionary: roomUsersToDictionary())
            return ""
        }
    }
    
    func startGameBtn() -> StartGameSituation {
        if self.room.users.count <= 1 {
            print("人數不足")
            return .underRepresented
        }
        
        for user in self.room.users {
            if !user.isHost {
                if user.isReady == false {
                    return .notAllReady
                }
            }
        }
        print("遊戲開始")
        createGame(game: self.game) { [self] game in
            room.GameID = game.id!
            room.isPlaying = true
            updateRoom(id: room.id!, isPlaying: room.isPlaying, gameID: room.GameID)
        }
        return .gameStart
    }
    
    func playersToDictionary() -> [Dictionary<String, Any>] {
        var resultDictionary: [Dictionary<String, Any>] = []
        for player in self.game.players {
            resultDictionary.append(player.dictionary)
        }
        return resultDictionary
    }
    
    
}

enum StartGameSituation: String {
    case notAllReady = "有玩家尚未準備"
    case underRepresented = "遊玩人數需2人"
    case gameStart = "遊戲即將開始"
    
}
