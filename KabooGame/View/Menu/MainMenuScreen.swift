//
//  MainMenuScreen.swift
//  Kaboo
//
//  Created by Aleksei Bochkov on 10/02/22.
//

import SwiftUI

struct MainMenuScreen: View {
    
    @State var popToRoot: Bool = false

    var body: some View {
        NavigationView {
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
                        NavigationLink(destination: GameScreen(popToRoot: $popToRoot), isActive: $popToRoot) {
                            Text("Play")
                                .font(.title2.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(16)
                        }
                        .isDetailLink(false)
                        .buttonStyle(.borderedProminent)
                        
                        NavigationLink(destination: TutorialView()) {
                            Text("How to play")
                                .font(.title2.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(16)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(CustomColor.darkGrey)
                        
                        NavigationLink(destination: SettingsView()) {
                            Text("Settings")
                                .font(.title2.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(16)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(CustomColor.darkGrey)
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                }
                .navigationBarHidden(true)
            }
        }
    }
}

struct MainMenuScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuScreen()
            .preferredColorScheme(.dark)
    }
}
