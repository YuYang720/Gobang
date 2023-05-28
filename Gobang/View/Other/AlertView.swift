//
//  AlertView.swift
//  Gobang
//
//  Created by User06 on 2023/5/27.
//

import SwiftUI

struct AlertView: View {
    @EnvironmentObject var showView: ShowViewModel
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(.gray)
            .overlay(Text(showView.alert_msg).foregroundColor(.white).font(Font.system(size: 20)))
            .frame(width: 230, height: 80)
            .opacity(showView.alert_opacity)
            .position(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.45)
    }
}
