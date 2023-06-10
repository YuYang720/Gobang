//
//  GameView.swift
//  Gobang
//
//  Created by User06 on 2023/5/28.
//

import SwiftUI

struct GameView: View {
    
    @EnvironmentObject var showView: ShowViewModel
    @EnvironmentObject var roomAction: GameControl
    //@State private var currRoomData = Game(flag: 0, winner: -1, chessboard: boards)
    @State var UIColor = Color(red: 250/255, green: 216/255, blue: 100/255)
    @State private var isGameOver = false
    // @State private var cal_score = 0
    
    let gameOverNotificaiton = NotificationCenter.default.publisher(for: Notification.Name("Game Over"))
    
    var body: some View {
        ZStack{
            Image("Background6")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("\(roomAction.room.users[roomAction.playerIdx].nickname)  vs    \(roomAction.room.users[1-roomAction.playerIdx].nickname)")
                    .font(.largeTitle)
                boardView
                HStack{
                    VStack{
                        //上
                        Button {
                            Buttonup()
                        } label: {
                            Image("up")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80, alignment: .center)
                                .offset(y: 20)
                        }
                        HStack{
                            //左
                            Button {
                                Buttonleft()
                            } label: {
                                Image("left")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80, alignment: .center)
                                    .offset(x: -10)
                            }
                            //右
                            Button {
                                Buttonright()
                            } label: {
                                Image("right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80, alignment: .center)
                                    .offset(x: 10)
                            }
                        }
                        //下
                        Button {
                            Buttondown()
                        } label: {
                            Image("down")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80, alignment: .center)
                                .offset(y: -20)
                        }
                    }
                    .offset(x: -15)
                    .padding()
                    
                    
                    Button {
                        confirmBtn()
                    } label: {
                        Image("confirm")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100, alignment: .center)
                            .padding()
                    }
                    
                }
            }
            if isGameOver {
                GameOverView
                //print("gameover")
            }
        }
        .onAppear() {
            roomAction.gameDetect(id: roomAction.room.GameID) { game in
                roomAction.game = game
                if game.isGameOver {
                    NotificationCenter.default.post(name: Notification.Name("Game Over"), object: nil)
                }
            }
            //roomAction.game.isGameOver == true 判斷會失敗
        }
        .onReceive(gameOverNotificaiton, perform: { _ in
            print("Game Over")
            self.isGameOver = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3 ) {
                showView.view = "LobbyView"
                if roomAction.room.users[roomAction.playerIdx].isHost {
                    roomAction.deleteGame(id: roomAction.room.GameID)
                    roomAction.deleteRoom(id: roomAction.room.id!)
                }
            }
        })
    }
    
    var boardView: some View {
        VStack(alignment: .center, spacing:0){
            ForEach(0..<9) { row in
                    HStack(alignment: .center, spacing:0){
                        Group {
                            ForEach(0..<9) { column in
                                VStack{
                                    ZStack{
                                        if roomAction.game.chessboard[row*9+column].data != "none" {
                                            Image(roomAction.game.chessboard[row*9+column].data)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 27, height: 27, alignment: .center)
                                        }
                                    }
                                    .frame(width: 34, height: 34, alignment: .center)
                                    .border(((roomAction.game.players[roomAction.playerIdx].currentSelect == row*9+column) ? Color.red : .black), width: 3)
                                }
                            }
                        }
                    }
            }
        }
    }
    
    var GameOverView: some View {
        ZStack{
            Color.init(red: 142/255, green: 202/255, blue: 230/255)
            if roomAction.game.players[roomAction.playerIdx].winning {
                Text("勝    利")
                    .font(Font.system(size: 70))
                    .foregroundColor(.yellow)
                    .onAppear{
                        //AVPlayer.winPlayer.playFromStart()
                    }
            }else {
                Text("失    敗")
                    .font(Font.system(size: 70))
                    .foregroundColor(.black)
                    .onAppear{
                        //AVPlayer.losePlayer.playFromStart()
                    }
            }
        }
        .frame(width: showView.width * 0.7, height: showView.height * 0.2)
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.init(red: 2/255, green: 48/255, blue: 71/255), lineWidth: 8))
        .onAppear{
            var result = ""
            var score = 1
            if roomAction.game.players[roomAction.playerIdx].winning {
                result = "win"
                score = 4
            }
            else {
                result = "lose"
                score = 1
            }
            // 取得前一筆記錄的total_score，如果沒有記錄則預設為0
            let previousTotalScore = showView.user.records.last?.total_score ?? 0
            let newTotalScore = previousTotalScore + score
            
            showView.user.records.append(MyRecord(id: showView.user.records.count, result: result, score: score, total_score: newTotalScore))
            showView.updateRecords(id: showView.user.id!, recordsToDictionary: showView.recordsToDictionary())
            
            showView.user.total_score += score
            showView.updateTotalScore(id: showView.user.id!, totalScore: showView.user.total_score)
        }
    }
    
    func checkisblank(xy: Int) -> Bool {
        if roomAction.game.chessboard[xy].data == "none"{
            return true
        }
        else { //黑或白
            showView.alert_msg = "已經有棋子了，請改位置"
            showView.show_message(message: showView.alert_msg)
            return false
        }
    }
    
    func RowWin(xy: Int, flag: Int, suit: String) -> Void {
        var Connect = 1
        //判斷直五子
        for i in 1...4{
            //上
            if xy-i*9 < 0{ break }
            if(roomAction.game.chessboard[xy-i*9].data == suit){
                Connect += 1
            }
            else { break }
        }
        for i in 1...4{
            //下
            if xy-i*9 > 80{ break }
            if(roomAction.game.chessboard[xy+i*9].data == suit){
                Connect += 1
            }
            else { break }
        }
        if Connect >= 5{
            roomAction.game.winner = flag
            roomAction.game.players[flag].winning = true
            roomAction.game.isGameOver = true
        }
    }
    
    func ColWin(xy: Int, flag: Int, suit: String) -> Void {
        var Connect = 1
        //判斷橫五子
        for i in 1...4{
            //左
            if (xy-i) % 9 == 8 || (xy-i) < 0{ break }
            if(roomAction.game.chessboard[xy-i].data == suit){
                Connect += 1
            }
            else { break }
        }
        for i in 1...4{
            //右
            if (xy+i) % 9 == 0 || (xy-i) > 80{ break }
            if(roomAction.game.chessboard[xy+i].data == suit){
                Connect += 1
            }else { break }
        }
        if Connect >= 5{
            roomAction.game.winner = flag
            roomAction.game.players[flag].winning = true
            roomAction.game.isGameOver = true
        }
    }
    
    func ObliWin1(xy: Int, flag: Int, suit: String) -> Void {
        var Connect = 1
        //判斷左上 右下
        for i in 1...4{
            //左上
            if (xy-i*10) % 9 == 8 || (xy-i*10) < 0{ break }
            if(roomAction.game.chessboard[xy-i*10].data == suit){
                Connect += 1
            }else { break }
        }
        for i in 1...4{
            //右下
            if (xy+i*10) % 9 == 0 || (xy+i*10) > 80{ break }
            if(roomAction.game.chessboard[xy+i*10].data == suit){
                Connect += 1
            }else { break }
        }
        if Connect >= 5{
            roomAction.game.winner = flag
            roomAction.game.players[flag].winning = true
            roomAction.game.isGameOver = true
        }
    }
    
    func ObliWin2(xy: Int, flag: Int, suit: String) -> Void {
        var Connect = 1
        //判斷右上 左下
        for i in 1...4{
            //右上
            if (xy-8*i) % 9 == 0 || (xy-8*i) < 0 { break }
            if(roomAction.game.chessboard[xy-8*i].data == suit){
                Connect += 1
            }else { break }
        }
        for i in 1...4{
            //左下
            if (xy+8*i) % 9 == 8 || (xy+8*i) > 80 { break }
            if(roomAction.game.chessboard[xy+8*i].data == suit){
                Connect += 1
            }else { break }
        }
        if Connect >= 5{
            roomAction.game.winner = flag
            roomAction.game.players[flag].winning = true
            roomAction.game.isGameOver = true
        }
    }
    
    func checkWin(xy: Int, flag: Int, suit: String) -> Void {
        //判斷直五子
        RowWin(xy: xy, flag: flag, suit: suit)
        //判斷橫五子
        ColWin(xy: xy, flag: flag, suit: suit)
        //判斷左上 右下
        ObliWin1(xy: xy, flag: flag, suit: suit)
        //判斷右上 左下
        ObliWin2(xy: xy, flag: flag, suit: suit)
    }
    
    func Buttonup() ->  Void{
        if roomAction.game.players[roomAction.playerIdx].currentSelect >= 9 {
            roomAction.game.players[roomAction.playerIdx].currentSelect -= 9
            roomAction.updatePlayers(id: roomAction.room.GameID, playersDictionary: roomAction.playersToDictionary())
        }
    }
    func Buttondown() ->  Void{
        if roomAction.game.players[roomAction.playerIdx].currentSelect <= 71 {
            roomAction.game.players[roomAction.playerIdx].currentSelect += 9
            roomAction.updatePlayers(id: roomAction.room.GameID, playersDictionary: roomAction.playersToDictionary())
        }
    }
    func Buttonleft() ->  Void{
        if roomAction.game.players[roomAction.playerIdx].currentSelect % 9 != 0 {
            roomAction.game.players[roomAction.playerIdx].currentSelect -= 1
            roomAction.updatePlayers(id: roomAction.room.GameID, playersDictionary: roomAction.playersToDictionary())
        }
    }
    func Buttonright() ->  Void{
        if roomAction.game.players[roomAction.playerIdx].currentSelect % 9 != 8 {
            roomAction.game.players[roomAction.playerIdx].currentSelect += 1
            roomAction.updatePlayers(id: roomAction.room.GameID, playersDictionary: roomAction.playersToDictionary())
        }
    }
    
    func confirmBtn() {
        let xy = roomAction.game.players[roomAction.playerIdx].currentSelect
        
        
        //roomAction.room.user[roomAction.playerIdx].....
        if ((roomAction.game.players[roomAction.playerIdx].id == 0) && (roomAction.game.flag == 1)) {
            showView.alert_msg = "還沒輪到你"
            showView.show_message(message: showView.alert_msg)
        }
        
        else if ((roomAction.game.players[roomAction.playerIdx].id == 1) && (roomAction.game.flag == 0)) {
            showView.alert_msg = "還沒輪到你"
            showView.show_message(message: showView.alert_msg)
        }
        
        else if ((roomAction.game.players[roomAction.playerIdx].id == 0) && (roomAction.game.flag == 0)) {
            if checkisblank(xy: xy) {
                roomAction.game.chessboard[xy].data = "black"
                checkWin(xy: xy, flag: 0, suit: "black")
                roomAction.game.flag = 1
            }
        }
        else if ((roomAction.game.players[roomAction.playerIdx].id == 1) && (roomAction.game.flag == 1)) {
            if checkisblank(xy: xy) {
                roomAction.game.chessboard[xy].data = "white"
                checkWin(xy: xy, flag: 1, suit: "white")
                roomAction.game.flag = 0
            }
        }
        
        //roomAction.game.chessboard[xy].data = "black"
        roomAction.updateGame(id: roomAction.room.GameID, flag: roomAction.game.flag, isGameOver: roomAction.game.isGameOver, chessboardDictionary: roomAction.chessboardToDictionary(), playersDictionary: roomAction.playersToDictionary())
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
