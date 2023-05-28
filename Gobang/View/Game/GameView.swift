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
    @State private var UIColor = Color(red: 238/255, green: 186/255, blue: 85/255)
    @State private var Currentselected: Int = 0
    
    var body: some View {
        ZStack{
            VStack {
                Text("\(roomAction.game.players[roomAction.playerIdx].nickname) vs    \(roomAction.game.players[roomAction.playerIdx].nickname)")
                    .font(.largeTitle)
                boardView
                HStack{
                    VStack{
                        //上
                        Button {
                            Buttonup()
                        } label: {
                            Image(systemName: "arrowtraingle.up.fill")
                                .foregroundColor(Color.blue)
                                .scaledToFit()
                                .border(Color.black, width: 1)
                        }
                        HStack{
                            //左
                            Button(action: {
                                Buttonleft()
                            }, label: {
                                Image("left")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80, alignment: .center)
                                    .border(Color.black, width: 1)
                            })
                            Spacer()
                            //右
                            Button(action: {
                                Buttonright()
                            }, label: {
                                Image("right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80, alignment: .center)
                                    .border(Color.black, width: 1)
                            })
                        }
                        //下
                        Button(action: {
                            Buttondown()
                        }, label: {
                            Image("down")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80, alignment: .center)
                                .border(Color.black, width: 1)
                        })
                    }
                }
                
            }
        }
    }
    
    var boardView: some View {
        VStack{
            HStack{
                ForEach(0..<10) { number in
                    VStack {
                        ZStack {
                            Image("\(number)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25, alignment: .center)
                        }
                        .frame(width: 30, height: 30, alignment: .center)
                    }
                }
            }
            ForEach(0..<9) { row in
                    HStack {
                        VStack {
                            ZStack {
                                Image("\(row + 1)")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25, alignment: .center)
                            }
                            .frame(width: 30, height: 30, alignment: .center)
                        }
                        Group {
                            ForEach(0..<9) { column in
                                VStack{
                                    ZStack{
                                        Image(roomAction.game.chessboard[row*9+column].data)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25, alignment: .center)
                                    }
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .border(Color.black, width: 2)
                                }
                                .background(UIColor)
                                .onAppear(){
                                    ///
                                }
                            }
                        }
                    }
                }.background(UIColor)
        }
    }
    
    func checkisblank(xy: Int) -> Bool {
        if roomAction.game.chessboard[xy].data == "none"{
            return true
        }
        else { //黑或白
            showView.alert_msg = "已經有棋子了，請改位置"
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
        if Currentselected >= 9 {
            Currentselected -= 9
        }
    }
    func Buttondown() ->  Void{
        if Currentselected <= 71 {
            Currentselected += 9
        }
    }
    func Buttonleft() ->  Void{
        if Currentselected%9 != 0 {
            Currentselected -= 1
        }
    }
    func Buttonright() ->  Void{
        if Currentselected%9 != 8 {
            Currentselected += 1
        }
    }
    
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
