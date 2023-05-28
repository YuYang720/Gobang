//
//  GridView.swift
//  Gobang
//
//  Created by User06 on 2023/5/28.
//

import SwiftUI

struct GridView: View {
    var x: Int
    var y: Int
    
    @EnvironmentObject var showView: ShowViewModel
    @EnvironmentObject var roomAction: GameControl
    @State private var UIColor = Color(red: 238/255, green: 186/255, blue: 85/255)
//    @State private var currRoomData = Game(flag: 0, winner: -1, chessboard: boards)
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView(x:1, y:1)
    }
}
