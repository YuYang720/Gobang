//
//  ViewController.swift
//  Gobang
//
//  Created by User06 on 2023/5/27.
//

import SwiftUI

struct ViewController: View {
    
    @StateObject var showView = ShowViewModel()
    @StateObject var roomAction = GameControl()
    
    var body: some View {
        ZStack {
            switch showView.view {
            case "LogInSignUpView":
                LogInSignUpView()
                    .environmentObject(showView)
            case "LobbyView":
                LobbyView()
                    .environmentObject(showView)
            case "ProfileView":
                ProfileView()
                    .environmentObject(showView)
            case "AddRoomView":
                AddRoomView()
                    .environmentObject(showView)
                    .environmentObject(roomAction)
            case "WaitRoomView":
                WaitRoomView()
                    .environmentObject(showView)
                    .environmentObject(roomAction)
            case "GameView":
                GameView()
                    .environmentObject(showView)
                    .environmentObject(roomAction)
            default:
                LobbyView()
                    .environmentObject(showView)
            }
            AlertView()
                .environmentObject(showView)
        }.edgesIgnoringSafeArea(.all)
        .onAppear{
            showView.AppInit()
        }
    }
}


/*
struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewController()
    }
}*/
