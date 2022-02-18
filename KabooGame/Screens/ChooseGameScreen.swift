//
//  ChooseGameScreen.swift
//  Kaboo
//
//  Created by Aleksei Bochkov on 10/02/22.
//

import SwiftUI

struct ChooseGameScreen: View {
    @State private var isJoinGameActive = false
    @State private var isCreateGameActive = false
    @Binding var isPrevScreenActive: Bool
    
    var body: some View {
        ZStack {
                CustomColor.background
                    .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 0) {
                    
                    HStack(alignment: .center, spacing: 0) {
                        Button(action: {
                            isPrevScreenActive = false
                        }) {
                            Image(systemName: "arrow.left")
                                .frame(width: 40, alignment: .leading)
                                .padding(.top, 14)
                                .padding(.bottom, 10)
                                .padding(.leading, 10)
                        }
                        
                        Spacer()
                        
                        Text("Play")
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                            .padding(.top, 14)
                            .padding(.bottom, 10)
                            .padding(.trailing, 50)
                        Spacer()
                    }
                    .background(Color.white)
                    
                    Spacer()
                    
                    Text("Kaboo")
                        .font(.system(size: 48))
                    
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 92, height: 149)
                        .padding(.bottom, 57)
                    
                    NavigationLink(destination: JoinGameScreen(isPrevScreenActive: $isJoinGameActive), isActive: $isJoinGameActive) {
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
                    .isDetailLink(false)
                    
                    NavigationLink(destination: CreateGameScreen(isPrevScreenActive: $isCreateGameActive), isActive: $isCreateGameActive) {
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
                        .background(CustomColor.darkGrey.opacity(0.9))
                        .cornerRadius(8)
                        .padding(.bottom, 18)
                    }
                    .isDetailLink(false)
                    
                    Spacer()
                }
        }
        .navigationBarHidden(true)
    }
}
