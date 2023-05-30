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
    
    var body: some View {
        Color.init(red: 89/255, green: 165/255, blue: 216/255).edgesIgnoringSafeArea(.all)
        
        VStack {
            UserInfoView
            
            HStack{
                Button {
                    roomAction.createRoomBtn(user: showView.user){
                        showView.view = "WaitRoomView"
                    }
                } label: {
                    Text("創建房間")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .frame(width: showView.width * 0.4, height: showView.height * 0.05)
                        .background(Color.init(red: 239/255, green: 239/255, blue: 208/255))
                        .cornerRadius(10)
                }
            }
            .frame(width: showView.width * 0.7, height: showView.height * 0.1)
            .background(Color.init(red: 26/255, green: 101/255, blue: 158/255))
            .cornerRadius(15)
            .padding()
            
            VStack{
                Text("輸入邀請碼")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                
                TextField("", text: $roomAction.enterCode)
                    .font(.title)
                    .foregroundColor(.black)
                    .frame(width: showView.width * 0.6, height: showView.height * 0.05, alignment: .center)
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
                        .frame(width: showView.width * 0.5, height: showView.height * 0.05)
                        .background(Color.init(red: 239/255, green: 239/255, blue: 208/255))
                        .cornerRadius(10)
                }
            }
            .frame(width: showView.width * 0.7, height: showView.height * 0.2)
            .background(Color.init(red: 26/255, green: 101/255, blue: 158/255))
            .cornerRadius(15)
            .padding()
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
            .offset(x: -showView.width * 0.3, y: -showView.height * 0.2)
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

