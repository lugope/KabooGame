//
//  ChooseGameScreen.swift
//  Kaboo
//
//  Created by Aleksei Bochkov on 10/02/22.
//

import SwiftUI

struct ChooseGameScreen: View {
    var body: some View {
        ZStack {
            
            CustomColor.background
                .edgesIgnoringSafeArea([.bottom])
            
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                
                Text("Kaboo")
                    .font(.system(size: 48))
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 92, height: 149)
                    .padding(.bottom, 57)
                
                Button(action: {
                    print("Join a game")
                }) {
                    VStack(alignment: .center, spacing: 0) {
                        Text("JOIN")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .padding(.bottom, 21)
                        
                        Text("Use a code to join a friend's game")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                    }
                    .frame(width: 256, height: 128)
                    .background(CustomColor.blue)
                    .cornerRadius(8)
                    .padding(.bottom, 18)
                }
                
                Button(action: {
                    print("Create a game")
                }) {
                    VStack(alignment: .center, spacing: 0) {
                        Text("CREATE")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .padding(.bottom, 21)
                        
                        Text("Create a game and invite your friends")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                    }
                    .frame(width: 256, height: 128)
                    .background(CustomColor.darkGrey)
                    .cornerRadius(8)
                    .padding(.bottom, 18)
                }
                
                Spacer()
            }
        }
        .navigationTitle("Play")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChooseGameScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChooseGameScreen()
    }
}
