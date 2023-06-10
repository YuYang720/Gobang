//
//  SettingView.swift
//  Gobang
//
//  Created by User06 on 2023/6/10.
//

import SwiftUI
import AVFoundation

struct SettingView: View {
    @EnvironmentObject var showView: ShowViewModel
    @AppStorage("volume") var volume = 0.5
    @AppStorage("isMute") var isMuted: Bool = false
    var body: some View {
        ZStack{
            Color.init(red: 142/255, green: 202/255, blue: 230/255)
            VStack{
                HStack{
                    Text("音樂")
                        .font(Font.system(size: 25))
                    Image(systemName: isMuted ? "square" : "checkmark.square.fill")
                        .frame(width: 25, height: 25)
                        .foregroundColor(isMuted ? Color(UIColor.systemBlue) : Color.secondary)
                        .onTapGesture {
                            self.isMuted.toggle()
                            AVPlayer.queuePlayer.isMuted = self.isMuted
                        }
                    Slider(value: $volume, in: 0...1.0 ){_ in
                        AVPlayer.queuePlayer.volume = Float(volume)
                    }.frame(width: showView.width * 0.5)
                    .disabled(self.isMuted ? true : false)
                }
                
            }
        }
        .frame(width: showView.width * 0.7, height: showView.height * 0.2)
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.init(red: 2/255, green: 48/255, blue: 71/255), lineWidth: 8))
        .overlay(
            Button(action: {
                showView.showSettingView = false
            }, label: {
                Circle()
                    .frame(width: showView.width * 0.05, height: showView.height * 0.05)
                    .foregroundColor(Color.blue)
                    .shadow(radius: 5)
                    .overlay(
                        Text("X")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                    )
            }).offset(x: showView.width * 0.33, y: -showView.height * 0.1)
        )
        //.offset(y: showView.height * -0.35)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
