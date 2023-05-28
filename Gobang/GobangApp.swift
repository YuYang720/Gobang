//
//  GobangApp.swift
//  Gobang
//
//  Created by User06 on 2023/5/27.
//

import SwiftUI
import Firebase

@main
struct GobangApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ViewController()
        }
    }
}
