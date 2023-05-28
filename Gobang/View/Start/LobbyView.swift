//
//  LobbyView.swift
//  Gobang
//
//  Created by User06 on 2023/5/27.
//

import SwiftUI

struct LobbyView: View {
    
    @EnvironmentObject var showView: ShowViewModel
    @State private var flag = false
    @State private var showAlert = false
    
    var body: some View {
        
        ZStack{
            Color.yellow
                .edgesIgnoringSafeArea(.all)
            Text("Touch To Start")
                .foregroundColor(Color.black)
                .font(Font.system(size:35))
                .position(x: showView.width * 0.5, y: showView.height * 0.9)
            Button {
                showView.LogOut()
                showView.user = User()
                showView.view = "LogInSignUpView"
            } label: {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: showView.width * 0.16, height: showView.height * 0.04)
                    .foregroundColor(Color.gray)
                    .shadow(radius: 5)
                    .overlay(
                        Text("log out")
                            .font(Font.system(size: 20))
                            .foregroundColor(.white)
                    )
            }.position(x: showView.width * 0.9, y: showView.height * 0.05)
        }
        .onTapGesture {
            showView.view = "AddRoomView"
        }
    }
}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        LobbyView()
    }
}
