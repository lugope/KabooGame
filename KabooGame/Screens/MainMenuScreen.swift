//
//  MainMenuScreen.swift
//  Kaboo
//
//  Created by Aleksei Bochkov on 10/02/22.
//

import SwiftUI

struct MainMenuScreen: View {
    @State private var isActive = false
    
//    init() {
//        UINavigationBar.appearance().isTranslucent = false
//        UINavigationBar.appearance().backItem?.backBarButtonItem?.title = ""
//    }
    
    var body: some View {
        NavigationView {
            ZStack {
                
                CustomColor.background
                    .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 0) {
                    Text("Kaboo")
                        .font(.system(size: 48))
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 92, height: 149)
                        .padding(.bottom, 88)
                    
                    NavigationLink(destination: ChooseGameScreen(isPrevScreenActive: $isActive), isActive: $isActive) {
                        Text("PLAY")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .frame(width: 256, height: 64)
                            .background(CustomColor.blue)
                            .cornerRadius(12)
                            .padding(.bottom, 24)
                    }
                    .isDetailLink(false)
                    
                    Button(action: {
                        print("Learn how to play")
                    }) {
                        Text("HOW TO PLAY")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .frame(width: 256, height: 64)
                            .background(CustomColor.darkGrey.opacity(0.9))
                            .cornerRadius(12)
                            .padding(.bottom, 24)
                    }
                    
                    Button(action: {
                        print("Change settings")
                    }) {
                        Text("SETTINGS")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .frame(width: 256, height: 64)
                            .background(CustomColor.darkGrey.opacity(0.9))
                            .cornerRadius(12)
                    }
                }
            }
        }
    }
}

struct MainMenuScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuScreen()
    }
}
