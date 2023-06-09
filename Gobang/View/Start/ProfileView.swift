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
        ZStack{
            Text("暱稱： \(showView.user.nickname)")
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(width: showView.width * 0.7, height: showView.height * 0.05, alignment: .leading)
                .background(Color.black)
                .cornerRadius(5)
                .position(x: showView.width * 0.5, y: showView.height * 0.1)
            
            /*Text("總分: \(showView.user.total_score)")
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(width: showView.width * 0.7, height: showView.height * 0.05, alignment: .leading)
                .background(Color.black)
                .cornerRadius(5)
                .position(x: showView.width * 0.5, y: showView.height * 0.25)*/
            RecordView
                .position(x: showView.width * 0.5, y: showView.height * 0.45)
            
            Button(action: {
                showView.view = "AddRoomView"
            }, label: {
                Circle()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color.blue)
                    .shadow(radius: 5)
                    .overlay(
                        Text("X")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                    )
            }).position(x: showView.width * 0.95, y: showView.height * 0.05)
        }
    }
    
    var RecordView: some View {
        ZStack{
            VStack(spacing: 0){
                Text("我的戰績")
                    .font(.title)
                    .foregroundColor(.black)
                    .frame(width: showView.width * 0.8, height: showView.height * 0.08)
                HStack{
                    Spacer()
                    Text("結果")
                        .foregroundColor(.white)
                        .frame(width: showView.width * 0.2, height: showView.height * 0.05)
                    Spacer()
                    Text("得分")
                        .foregroundColor(.white)
                        .frame(width: showView.width * 0.2, height: showView.height * 0.05)
                    Spacer()
                    Text("累計得分")
                        .foregroundColor(.white)
                        .frame(width: showView.width * 0.2, height: showView.height * 0.05)
                    Spacer()
                }
                .frame(width: showView.width * 0.8, height: showView.height * 0.05)
                .background(Color.init(red: 38/255, green: 97/255, blue: 156/255))
                ScrollView {
                    VStack{
                        ForEach(showView.user.records, id:  \.id){ (record) in
                            RecordRowView(record: record)
                        }
                    }
                }.background(Color.init(red: 152/255, green: 210/255, blue: 231/255))
                
            }
            
            
        }
        .frame(width: showView.width * 0.8, height: showView.height * 0.4)
        .background(Color.init(red: 152/255, green: 210/255, blue: 231/255))
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.init(red: 38/255, green: 97/255, blue: 156/255), lineWidth: 1)
        )
        .cornerRadius(25)
    }
    
}

struct RecordRowView: View {
    var record: MyRecord
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text("\(record.result)")
                    .foregroundColor(Color.init(red: 32/255, green: 32/255, blue: 32/255))
                    .bold()
                    .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.05)
                Spacer()
                Text("\(record.score)")
                    .foregroundColor(Color.init(red: 51/255, green: 53/255, blue: 51/255))
                    .bold()
                    .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.05)
                Spacer()
                Text("\(record.total_score)")
                    .foregroundColor(Color.init(red: 51/255, green: 53/255, blue: 51/255))
                    .bold()
                    .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.05)
                Spacer()
            }.offset(y: 10)
            Rectangle()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: 1)
                .foregroundColor(Color.init(red: 38/255, green: 97/255, blue: 156/255))
        }.frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.05)
        
    }
}
