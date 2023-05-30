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
    @State var UIColor = Color(red: 119/255, green: 93/255, blue: 43/255)
    
    var body: some View {
        ZStack{
            VStack {
                Text("\(roomAction.game.players[roomAction.playerIdx].nickname) vs    \(roomAction.game.players[1-roomAction.playerIdx].nickname)")
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
                            }
                            Spacer()
                            //右
                            Button {
                                Buttonright()
                            } label: {
                                Image("right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80, alignment: .center)
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
                        }
                    }
                    
                    Button {
                        confirmBtn()
                    } label: {
                        Image("confirm")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100, alignment: .center)
                    }
                }
            }
        }
        .onAppear() {
            roomAction.gameDetect(id: roomAction.room.GameID) { game in
                roomAction.game = game
            }
        }
    }
    
    var boardView: some View {
        VStack{
            ForEach(0..<9) { row in
                    HStack {
                        Group {
                            ForEach(0..<9) { column in
                                VStack{
                                    ZStack{
                                        Image(roomAction.game.chessboard[row*9+column].data)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 27, height: 27, alignment: .center)
                                    }
                                    .frame(width: 32, height: 32, alignment: .center)
                                    .border(((roomAction.game.players[roomAction.playerIdx].currentSelect == row*9+column) ? Color.red : .black), width: 3)
                                }
                                .background(UIColor)
                            }
                        }
                    }
            }
        }.background(UIColor)
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
            showView.alert_msg = "\(roomAction.playerIdx)還沒輪到你\(roomAction.game.flag)"
            showView.show_message(message: showView.alert_msg)
        }
        
        else if ((roomAction.game.players[roomAction.playerIdx].id == 1) && (roomAction.game.flag == 0)) {
            showView.alert_msg = "\(roomAction.playerIdx)還沒輪到你\(roomAction.game.flag)"
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
        roomAction.updateChessboard(id: roomAction.room.GameID, chessboardDictionary: roomAction.chessboardToDictionary())
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
