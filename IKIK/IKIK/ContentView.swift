//
//  ContentView.swift
//  IKIK
//
//  Created by 서민주 on 2020/09/20.
//  Copyright © 2020 minjuseo. All rights reserved.
//

import SwiftUI

struct UserData {
    var email: String
    var pw: String
}

struct ContentView: View {
    @State var user: UserData = UserData(email: "", pw: "")
    var body: some View {
//        VStack {
//            Image("logo_transparent")
//                .resizable()
//                .scaledToFill()
//                .frame(height: 200)
//
//                //            Text("WELCOME")
//                .font(.largeTitle)
//            TextField("Email Address", text: $user.email)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//
//            TextField("Password", text: $user.pw)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//
//            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
//                Text("CONTINUE")
//            }
//
//            Spacer()
//
//            HStack {
//                Text("아직 계정이 없으신가요? ")
//                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
//                    Text("회원가입")
//                }
//            }
//
//        }
//        .padding(30)
        CustomController()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CustomController: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CustomController>) -> UIViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "Home")
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CustomController>) {
        
    }
}
