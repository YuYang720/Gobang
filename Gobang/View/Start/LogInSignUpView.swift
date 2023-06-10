//
//  LogInSignUpView.swift
//  Gobang
//
//  Created by User06 on 2023/5/27.
//

// Gobang1-4 已經因為更改程式碼而無法使用

import SwiftUI
import FirebaseAuth
import AVFoundation

struct LogInSignUpView: View {
    
    @EnvironmentObject var showView: ShowViewModel
    @ObservedObject private var keyboard = KeyboardResponder()
    @State private var isRegister = false
    @State private var showLogin: Bool = false
    @State private var email = ""
    @State private var password = ""
    @State private var nickname = ""
    
    var body: some View {
        ZStack {
            Image("Background6")
                .resizable()
                .ignoresSafeArea()
            
            Button(action: {
                withAnimation{
                    showView.showSettingView = true
                }
            }, label: {
                Image("gear")
                    .resizable()
                    .frame(width: showView.height * 0.03, height: showView.height * 0.03)
            }).position(x: showView.width * 0.95, y: showView.height * 0.05)
            
            if showLogin {
                LogInView
            }
            else {
                SignUpView
            }
            AlertView().environmentObject(showView)
        }.edgesIgnoringSafeArea(.all)
        .disabled(showView.showSettingView ? true : false)
        
        if showView.showSettingView {
            SettingView().environmentObject(showView)
        }
    }
    
    var LogInView: some View {
        VStack{
            HStack{
                Text("還沒有帳號")
                    .foregroundColor(Color.red)
                Image(systemName: "arrow.turn.right.down")
                    .foregroundColor(Color.red)
                    .offset(x: -5, y: 5)
            }
            .offset(x: 25, y: 5)
            
            ZStack{
                Button {
                    showLogin = false
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.orange)
                            .frame(width: 150, height: 40)
                        
                        Text(" Sign Up")
                            .foregroundColor(Color.white)
                            .font(.title)
                        
                    }
                    .offset(x: 60, y: 0)
                }
                
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.pink]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                        .frame(width: 150, height: 40)
                    
                    Text("Log In")
                        .foregroundColor(Color.white)
                        .font(.title)
                    
                }
                .offset(x: -60, y: 0)
            }
            Divider()
                .frame(width: 320)
                .padding(5)
            
            HStack{
                Image(systemName: "envelope")
                    .foregroundColor(Color.orange)
                    .font(.title)
                    .background(RoundedRectangle(cornerRadius: 0)
                                    .stroke(Color.orange, lineWidth: 3)
                                    .frame(width: 45, height: 45)
                    )
                
                TextField("Email@mail...", text: $email)
                    .foregroundColor(Color.purple)
                    .padding()
                    .frame(width: 220, height: 47)
                    .background(Color.orange)
            }
            .padding(1)
            
            HStack{
                Image(systemName: "lock")
                    .foregroundColor(Color.orange)
                    .font(.title)
                    .background(RoundedRectangle(cornerRadius: 0)
                                    .stroke(Color.orange, lineWidth: 3)
                                    .frame(width: 45, height: 45)
                    )
                
                SecureField("Password", text: $password) {
                    // on Submit
                }
                .foregroundColor(Color.purple)
                .padding()
                .frame(width: 220, height: 47)
                .background(Color.orange)
                .offset(x: 6)
            }
            
            Button(action: {
                email_login()
            }, label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.red]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                        .frame(width: 150, height: 40)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.yellow, lineWidth: 5)
                        .frame(width: 150, height: 40)
                    
                    Text("LOG IN")
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 35))
                    
                }
                .padding()
            })
        }
    }
    
    var SignUpView: some View {
        VStack{
            HStack{
                Image(systemName: "arrow.turn.left.down")
                    .foregroundColor(Color.red)
                    .offset(x: 5, y: 5)
                
                Text("已經有帳號了")
                    .foregroundColor(Color.red)
            }
            .offset(x: -25, y: 5)
            
            ZStack{
                Button(action: {
                    showLogin = true
                }, label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.orange)
                            .frame(width: 150, height: 40)
                        
                        Text("Log In")
                            .foregroundColor(Color.white)
                            .font((.custom("PinclloDemo", size: 30)))
                        
                    }
                    .offset(x: -60, y: 0)
                })
                
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.pink]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                        .frame(width: 150, height: 40)
                    
                    Text("Sign Up")
                        .foregroundColor(Color.white)
                        .font((.custom("PinclloDemo", size: 30)))
                    
                }
                .offset(x: 60, y: 0)
            }
            Divider()
                .frame(width: 320)
                .padding(5)
            HStack{
                Image(systemName: "person")
                    .foregroundColor(Color.orange)
                    .font(.title)
                    .background(RoundedRectangle(cornerRadius: 0)
                                    .stroke(Color.orange, lineWidth: 3)
                                    .frame(width: 45, height: 45)
                    )
                
                TextField("Your nickname", text: $nickname)
                    .foregroundColor(Color.white)
                    .padding()
                    .frame(width: 220, height: 47)
                    .background(Color.orange)
                    .offset(x: 3)
            }
            HStack{
                Image(systemName: "envelope")
                    .foregroundColor(Color.orange)
                    .font(.title)
                    .background(RoundedRectangle(cornerRadius: 0)
                                    .stroke(Color.orange, lineWidth: 3)
                                    .frame(width: 45, height: 45)
                    )
                
                TextField("Email@mail...", text: $email)
                    .foregroundColor(Color.purple)
                    .padding()
                    .frame(width: 220, height: 47)
                    .background(Color.orange)
            }
            .padding(1)
            
            HStack{
                Image(systemName: "lock")
                    .foregroundColor(Color.orange)
                    .font(.title)
                    .background(RoundedRectangle(cornerRadius: 0)
                                    .stroke(Color.orange, lineWidth: 3)
                                    .frame(width: 45, height: 45)
                    )
                
                SecureField("Password", text: $password) {
                    // on Submit
                }
                .foregroundColor(Color.purple)
                .padding()
                .frame(width: 220, height: 47)
                .background(Color.orange)
                .offset(x: 6)
            }
            
            Button(action: {
                email_registered()
            }, label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.red]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                        .frame(width: 150, height: 40)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.yellow, lineWidth: 5)
                        .frame(width: 150, height: 40)
                    
                    Text("SIGN UP")
                        .foregroundColor(Color.white)
                        .font(.title)
                    
                }
                .padding()
            })
        }
    }
    
    func email_registered() {
        Auth.auth().createUser(withEmail: self.email, password: self.password) { result, error in
            guard let user = result?.user,
                  error == nil else {
                print(error?.localizedDescription as Any)
                errorAnalysis(error: error!.localizedDescription)
                return
            }
            //print(user.email as Any, user.uid)
            setUser(uid: user.uid)
            showView.createUser(user: showView.user) { user in
                showView.user = user
            }
            showView.view = "EditPersonalView"
        }
    }
    
    func setUser(uid: String) {
        showView.user.authId = uid
        showView.user.nickname = nickname
        showView.user.Account = email
        showView.user.password = password
    }
    
    func email_login() {
        if email == "" {
            showView.alert_msg = "請輸入電子信箱"
            showView.show_message(message: showView.alert_msg)
        }
        else if password == "" {
            showView.alert_msg = "請輸入密碼"
            showView.show_message(message: showView.alert_msg)
        }
        else {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                guard error == nil else {
                    print(error!.localizedDescription as String)
                    errorAnalysis(error: error!.localizedDescription)
                    return
                }
                // sign success
                showView.email_login_success()
            }
        }
    }
    
    func errorAnalysis(error: String) {
        if error == "The password is invalid or the user does not have a password." {
            showView.alert_msg = "密碼錯誤"
        }
        else if error == "The email address is badly formatted." {
            showView.alert_msg = "請輸入有效電子信箱"
        }
        else if error == "There is no user record corresponding to this identifier. The user may have been deleted." {
            showView.alert_msg = "此信箱尚未註冊"
        }
        else if error == "The email address is already in use by another account." {
            showView.alert_msg = "此信箱已被註冊"
        }
        showView.show_message(message: showView.alert_msg)
    }
    
    
}

struct LogInSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        LogInSignUpView()
    }
}
