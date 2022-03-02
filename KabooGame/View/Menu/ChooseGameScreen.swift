//
//  ChooseGameScreen.swift
//  Kaboo
//
//  Created by Aleksei Bochkov on 10/02/22.
//

import SwiftUI

struct ChooseGameScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }) {
        HStack {
            Image(systemName: "arrow.left")
        }
    }
    }
    
    var body: some View {
        ZStack {
            CustomColor.background
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                VStack {
                    Image("logo")
                    Text("Kaboo")
                        .font(.title.weight(.semibold))
                }
                
                Spacer()
                
                VStack(spacing: 24) {
                    VStack {
                        NavigationLink(destination: JoinGameScreen()) {
                            VStack(spacing: 20) {
                                Text("Join")
                                    .font(.title2.weight(.semibold))
                                    .frame(maxWidth: .infinity)
                                Text("Use a code to join a friend’s game")
                                    .font(.subheadline)
                            }
                            .padding()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.horizontal, 40)
                    
                    VStack(spacing: 24) {
                        NavigationLink(destination: CreateGameScreen()) {
                            VStack(spacing: 20) {
                                Text("Create")
                                    .font(.title2.weight(.semibold))
                                    .frame(maxWidth: .infinity)
                                Text("Create a game and invite friends")
                                    .font(.subheadline)
                            }
                            .padding()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(CustomColor.darkGrey)
                    }
                    .padding(.horizontal, 40)
                }
                Spacer()
            }
            .navigationTitle("Play")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
        }
    }
}

struct ChooseGameScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChooseGameScreen()
        }
        .preferredColorScheme(.dark)
    }
}
