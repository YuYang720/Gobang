
//  ShowViewModel.swift
//  Gobang
//
//  Created by User06 on 2023/5/27.
//

import SwiftUI
import Foundation

class ShowViewModel: StateControl, ObservableObject {
    @Published var user = User()
    @Published var view = "LogInSignUpView"
    @Published var goSetting: Bool = false
    @Published var alert_msg = ""
    @Published var alert_opacity = 0.0
    
    var width: CGFloat
    var height: CGFloat
    
    override init() {
        self.width = UIScreen.main.bounds.width
        self.height = UIScreen.main.bounds.height
    }
    
    func AppInit() {
        self.view = "LogInSignUpView"
        isLogin() { isLogin, authId in
            if isLogin {
                self.user.authId = authId
                self.fetchUser(authId: authId) { inFireBase, user in
                    self.user = user
                    self.view = "LobbyView"
                }
            }
        }
    }
    
    func show_message(message: String) {
        alert_msg = message
        withAnimation(.easeInOut){
            alert_opacity = 0.95
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.alert_opacity = 0.0
        }
    }
    
    func email_login_success() {
        getAuthID() { [self] uid, email in
            user.authId = uid
            user.Account = email
        }
        fetchUser(authId: self.user.authId) { inFireBase, user in
            self.user = user
        }
        view = "LobbyView"
    }
    
    func recordsToDictionary() -> [Dictionary<String, Any>] {
        var resultDictionary: [Dictionary<String, Any>] = []
        for record in self.user.records {
            resultDictionary.append(record.dictionary)
        }
        return resultDictionary
    }
    
}



