//
//  GobangApp.swift
//  Gobang
//
//  Created by User06 on 2023/5/27.
//

import SwiftUI
import Firebase
import AVFoundation

@main
struct GobangApp: App {
    
    init(){
        FirebaseApp.configure()
        AVPlayer.playFirstQuarter()
        AVPlayer.queuePlayer.play()
    }
    
    var body: some Scene {
        WindowGroup {
            ViewController()
        }
    }
}
