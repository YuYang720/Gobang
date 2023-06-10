//
//  AddRoomView.swift
//  Gobang
//
//  Created by User06 on 2023/5/27.
//

import SwiftUI
import AVFoundation

struct AddRoomView: View {
    
    @EnvironmentObject var showView: ShowViewModel
    @EnvironmentObject var roomAction: GameControl
    @State var UIColor = Color(red: 238/255, green: 186/255, blue: 83/255)
    
    var body: some View {
        
        Image("Board_img3")
            .resizable()
            .edgesIgnoringSafeArea(.all)
        
        UserInfoView
        Button(action: {
            withAnimation{
                showView.showSettingView = true
            }
        }, label: {
            Image("gear")
                .resizable()
                .frame(width: showView.height * 0.03, height: showView.height * 0.03)
        }).position(x: showView.width * 0.95, y: showView.height * 0.05)
        
        VStack {
            
            
            ZStack{
                Image("Background1")
                    .resizable()
                    .frame(width: showView.width * 0.4, height: showView.height * 0.05)
                    .cornerRadius(10)
                Button {
                    roomAction.createRoomBtn(user: showView.user){
                        showView.view = "WaitRoomView"
                    }
                } label: {
                    Text("創建房間")
                        .font(.largeTitle)
                        .foregroundColor(.yellow)
                }
            }
            .padding()
            .position(x: showView.width * 0.5, y: showView.height * 0.3)
            
            VStack{
                Text("輸入房號")
                    .font(.largeTitle)
                    .foregroundColor(Color.init(red:238/255, green: 186/255, blue: 83/255))
                
                TextField("", text: $roomAction.enterCode)
                    .font(.title)
                    .foregroundColor(.black)
                    .frame(width: showView.width * 0.4, height: showView.height * 0.05, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(5)
                
                Button {
                    roomAction.joinRoomBtn(user: showView.user) { (result) in
                        switch result {
                        case true:
                            print("join room success")
                            showView.view = "WaitRoomView"
                        case false:
                            print("join room fail")
                            showView.show_message(message: "此房間不存在")
                        }
                    }
                } label: {
                    Text("加入房間")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .frame(width: showView.width * 0.4, height: showView.height * 0.05)
                        .background(Color.init(red:238/255, green: 186/255, blue: 83/255))
                        .cornerRadius(10)
                }
            }
            //.position(x: showView.width * 0.5, y: showView.height * 0.6)
            .frame(width: showView.width * 0.7, height: showView.height * 0.2)
            .background(
                Image("Background1")
                    .cornerRadius(15)
                    .padding()
            )
            .offset(x: 0, y: -showView.height * 0.2)
            //.position(x: showView.width * 0.5, y: showView.height * 0.6)
            //.padding()
        }
        .disabled(showView.showSettingView ? true : false)
        
        if showView.showSettingView {
            SettingView().environmentObject(showView)
        }
        

    }
    
    var UserInfoView: some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(Color.black)
            .frame(width: showView.width * 0.4, height: showView.height * 0.05)
            .overlay(
                Text(showView.user.nickname)
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: showView.width * 0.3, height: showView.height * 0.03, alignment: .leading)
                    .padding(.leading, 5)
                
            )
            .offset(x: -showView.width * 0.3, y: -showView.height * 0.3)
            .onTapGesture {
                showView.view = "ProfileView"
            }
    }
}


struct AddRoomView_Previews: PreviewProvider {
    static var previews: some View {
        AddRoomView()
    }
}

