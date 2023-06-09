// 因為程式碼過長，我會分批給你
//  StateControl.swift
//  Gobang
//
//  Created by User06 on 2023/5/27.
//

import SwiftUI

import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class StateControl {
    let db = Firestore.firestore()
    @Published var gameListener: ListenerRegistration? = nil
    @Published var roomListener: ListenerRegistration? = nil
    
    func LogOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
    
    func isLogin(completion: @escaping (Bool,String) -> Void) {
        if let user = Auth.auth().currentUser {
            print("\(user.uid) login")
            completion(true, user.uid)
        } else {
            print("not login")
            completion(false, "")
        }
    }
    
    func getAuthID(completion: @escaping (String,String) -> Void) {
        if let user = Auth.auth().currentUser {
            completion(user.uid, user.email!)
        }
    }
    
    func fetchUser(authId: String, completion: @escaping (Bool, User) -> Void) {
        print("authId: \(authId)")
        db.collection("users").whereField("authId", isEqualTo: authId).getDocuments { document, error in
            guard let snapshot = document else { return }
            let user = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: User.self)
            }
            if user.isEmpty {
                print("user is empty")
                completion(false, User())
            } else {
                print("user is not empty")
                completion(true, user[0])
            }
            
        }
    }
    
    func createUser(user: User, completion: @escaping (User) -> Void) {
        do {
            let documentRef = try db.collection("users").addDocument(from: user)
            documentRef.getDocument(completion: { (document, error) in
                guard let document = document,
                      document.exists,
                      let user = try? document.data(as: User.self)else {
                    return
                }
                completion(user)
            })
        } catch {
            print(error)
        }
    }
    
    func createRoom(room: Room, completion: @escaping (Room) -> Void) {
        do {
            let documentRef = try db.collection("rooms").addDocument(from: room)
            documentRef.getDocument(completion: { (document, error) in
                guard let document = document,
                      document.exists,
                      let room = try? document.data(as: Room.self)else {
                    return
                }
                completion(room)
            })
        } catch {
            print(error)
        }
    }
    
    func isRoomExist(invitationCode: String, completion: @escaping (Bool, Room) -> Void) {
        db.collection("rooms").whereField("invitationCode", isEqualTo: invitationCode).getDocuments {querySnapshot, error in
            if let error = error {
                print("Error getting document: \(error)")
            } else if (querySnapshot?.isEmpty)! {
                completion(false, Room())
            } else {
                guard let snapshot = querySnapshot else { return }
                let room = snapshot.documents.compactMap { snapshot in
                    try? snapshot.data(as: Room.self)
                }
                completion(true, room[0])
            }
        }
    }
    
    func updateRoom(id: String, isPlaying: Bool, gameID: String ) {
        db.collection("rooms").document(id).updateData([
            "isPlaying": isPlaying,
            "GameID": gameID
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func updateRoomUsers(id: String, roomUsersDictionary: [Dictionary<String, Any>]) {
        db.collection("rooms").document(id).updateData([
            "users": roomUsersDictionary
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func deleteRoom(id: String) {
        db.collection("rooms").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func createGame(game: Game, completion: @escaping (Game) -> Void ){
        do {
            let documentRef = try db.collection("games").addDocument(from: game)
            documentRef.getDocument(completion: { (document, error) in
                guard let document = document,
                      document.exists,
                      let game = try? document.data(as: Game.self)else {
                    return
                }
                completion(game)
            })
        } catch {
            print(error)
        }
    }/*possible error*/
    
    func gameDetect(id: String, completion: @escaping (Game) -> Void) {
        print("start game detect")
        if self.gameListener != nil {
            self.gameListener!.remove()
        }
        
        self.gameListener = db.collection("games").document(id).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else { return }
            guard let game = try? snapshot.data(as: Game.self) else { return }
            let source = snapshot.metadata.hasPendingWrites ? "Local" : "Server"
            print(source)
            print("game modified")
            if source == "Server" {
                completion(game)
            }else if game.isGameOver {
                completion(game)
            }
        }
    }
    
    func roomDetect(id: String, completion: @escaping (String,Room) -> Void)  {
        self.roomListener = db.collection("rooms").document(id).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                completion("removed", Room())
                return
            }
            guard let room = try? snapshot.data(as:Room.self) else {
                completion("removed", Room())
                return
            }
            let source = snapshot.metadata.hasPendingWrites ? "Local" : "Server"
            print(source)
            print("room modified")
            completion("modified", room)
        }
    }
    
    func deleteGame(id: String) {
        db.collection("games").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func updateChessboard(id: String, chessboardDictionary: [Dictionary<String, Any>]) {
        db.collection("games").document(id).updateData([
            "chessboard": chessboardDictionary
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func updatePlayers(id: String, playersDictionary: [Dictionary<String, Any>]) {
        db.collection("games").document(id).updateData([
            "players": playersDictionary
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func updateRecords(id: String, recordsToDictionary: [Dictionary<String, Any>]) {
        db.collection("users").document(id).updateData([
            "records": recordsToDictionary
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func updateGame(id: String, flag: Int, isGameOver: Bool, chessboardDictionary: [Dictionary<String, Any>], playersDictionary: [Dictionary<String, Any>]) {
        db.collection("games").document(id).updateData([
            "chessboard": chessboardDictionary,
            "players": playersDictionary,
            "flag": flag,
            "isGameOver": isGameOver
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    

}
