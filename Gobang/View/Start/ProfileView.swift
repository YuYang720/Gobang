//
//  ProfileView.swift
//  Gobang
//
//  Created by User06 on 2023/5/27.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var showView: ShowViewModel
    var body: some View {
        VStack{
            Text(showView.user.nickname)
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(width: showView.width * 0.3, height: showView.height * 0.1, alignment: .leading)
                .background(Color.black)
                .cornerRadius(5)
                /*.overlay(
                    Button(action: {
                        editor = .nickname
                        showEditView = true
                    }, label: {
                        Image("pencil2")
                            .resizable()
                            .frame(width: 35, height: 35, alignment: .trailing)
                    }).offset(x: showView.width * 0.12)
                )*/
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
