//
//  WaitRoomView.swift
//  Gobang
//
//  Created by User06 on 2023/5/27.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import AVFoundation

struct WaitRoomView: View {
    
    @EnvironmentObject var showView: ShowViewModel
    @EnvironmentObject var roomAction: GameControl
    let exitNotificaiton = NotificationCenter.default.publisher(for: Notification.Name("Host exit"))
    let startNotificaiton = NotificationCenter.default.publisher(for: Notification.Name("game start"))
    
    var body: some View {
        ZStack {
            Image("Board_img3")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            Text("房號: \(roomAction.room.invitationCode)")
                .font(.title)
                .position(x: showView.width * 0.5, y: showView.height * 0.1)
                .foregroundColor(.black)
            
            Button(action: {
                withAnimation{
                    showView.showSettingView = true
                }
            }, label: {
                Image("gear")
                    .resizable()
                    .frame(width: showView.height * 0.03, height: showView.height * 0.03)
            }).position(x: showView.width * 0.95, y: showView.height * 0.05)
            
            Button {
                showView.view = "AddRoomView"
                roomAction.roomListener!.remove()
            } label: {
                Image(systemName: "arrowshape.turn.up.left.fill")
                    .resizable()
                    .frame(width: 35, height: 35)
            }.position(x: showView.width * 0.06, y: showView.height * 0.07)
            
            Button {
                showView.show_message(message: roomAction.roomBtn())
                
            } label: {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: showView.width * 0.4, height: showView.height * 0.05)
                    .foregroundColor(.yellow)
                    .overlay(
                        Text(roomAction.room.users[roomAction.playerIdx].isHost ? "進 入 遊 戲" : roomAction.room.users[roomAction.playerIdx].isReady ? "取消準備" : "準    備")
                            .foregroundColor(.black)
                            .font(.title)
                    )
            } .position(x: showView.width * 0.5, y: showView.height * 0.9)
            
            VStack(spacing: 20){
                ForEach(0..<2) { index in
                    RoomUserView(index: index).environmentObject(showView).environmentObject(roomAction)
                }
            }
            .frame(width: showView.width * 1, height: showView.height * 0.7)
            .position(x: showView.width * 0.5, y: showView.height * 0.5)
        }.edgesIgnoringSafeArea(.all)
        .onAppear{
            roomAction.roomDetect(id: roomAction.room.id!){ changetype, room in
                print(changetype)
                if changetype == "modified"{
                    roomAction.room = room
                    roomAction.playerIdx = room.users.firstIndex(where: { $0.id == roomAction.playerID })!
                    if room.isPlaying {
                        print("game starting")
                        NotificationCenter.default.post(name: Notification.Name("game start"), object: nil)
                    }
                } else {
                    print("removed")
                    if !roomAction.room.users[roomAction.playerIdx].isHost {
                        NotificationCenter.default.post(name: Notification.Name("Host exit"), object: nil)
                    }
                }
            }
        }
        .onReceive(exitNotificaiton, perform: { _ in
            print("Host Exit")
            roomAction.roomListener!.remove()
            showView.view = "AddRoomView"
        })
        .onReceive(startNotificaiton, perform: { _ in
            print("Start")
            print(roomAction.room.GameID)
            roomAction.roomListener!.remove()
            showView.show_message(message: "遊戲開始")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                showView.view = "GameView"
            }
        })
        .disabled(showView.showSettingView ? true : false)
        
        if showView.showSettingView {
            SettingView().environmentObject(showView)
        }
    }
}

struct  RoomUserView: View {
    @EnvironmentObject var showView: ShowViewModel
    @EnvironmentObject var roomAction: GameControl
    var index: Int = 0
    
    var body: some View {
        VStack(spacing: 5){
            ZStack{
                VStack(spacing: 0){
                    VStack{
                        if index < roomAction.room.users.count {
                            Image(systemName: "person")
                                .resizable()
                                .frame(width: showView.width * 0.2, height: showView.width * 0.2)
                                .clipShape(Circle())
                                .padding(.leading, 5)
                            Text(roomAction.room.users[index].nickname)
                                .font(.title)
                                .foregroundColor(.black)
                            Spacer()
                        }
                    }.frame(width: showView.width * 0.3, height: showView.width * 0.3)
                    //Spacer()
                    if index < roomAction.room.users.count {
                        ZStack{
                            Text(roomAction.room.users[index].isHost ? "房      長": "準      備")
                                .foregroundColor(roomAction.room.users[index].isReady ? .black : .white)
                        }
                        .frame(width: showView.width * 0.4, height: showView.height * 0.05)
                        .background(roomAction.room.users[index].isReady ? Color.yellow : Color.init(red: 31/255, green: 72/255, blue: 126/255))
                        .cornerRadius(5)
                    }else {
                        ZStack{
                            Text("準      備")
                                .foregroundColor(.white)
                        }
                        .frame(width: showView.width * 0.4, height: showView.height * 0.05)
                        .background(Color.init(red: 31/255, green: 72/255, blue: 126/255))
                        .cornerRadius(5)
                    }
                }
                .frame(width: showView.width * 0.6, height: showView.width * 0.6)
                //.background(Color.init(red: 89/255, green: 165/255, blue: 216/255))
                .cornerRadius(15)
            }
        }
    }
}

struct WaitRoomView_Previews: PreviewProvider {
    static var previews: some View {
        WaitRoomView()
    }
}
