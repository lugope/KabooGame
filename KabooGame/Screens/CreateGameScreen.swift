//
//  CreateGameScreen.swift
//  Kaboo
//
//  Created by Aleksei Bochkov on 10/02/22.
//

import SwiftUI

struct CreateGameScreen: View {
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
                    
                    Text("Create")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .padding(.top, 14)
                        .padding(.bottom, 10)
                        .padding(.trailing, 50)
                    
                    Spacer()
                }
                .background(Color.white)
                
                Spacer()
                
                Button(action: {
                    print("Game started")
                }) {
                    Text("Start the game")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .frame(width: UIScreen.main.bounds.width - 30, height: 42)
                        .background(CustomColor.blue)
                        .cornerRadius(8)
                        .padding(.bottom, 15)
                }
            }
        }
        .navigationBarHidden(true)
    }
}
