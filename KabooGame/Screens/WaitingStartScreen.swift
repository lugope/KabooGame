//
//  WaitingStartScreen.swift
//  KabooGame
//
//  Created by Aleksei Bochkov on 18/02/22.
//

import SwiftUI

struct WaitingStartScreen: View {
    @Binding var isPrevScreenActive: Bool
    @State var code: String
    @State var names: [String]
    @State var avatars: [String]
    
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
                    
                    Text("Join")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .padding(.top, 14)
                        .padding(.bottom, 10)
                        .padding(.trailing, 50)
                    
                    Spacer()
                }
                .background(Color.white)
                
                ForEach(names.indices, id: \.self) { index in
                    HStack(alignment: .center, spacing: 0) {
                            Image(avatars[index])
                                .resizable()
                                .frame(width: 42, height: 42, alignment: .center)
                                .clipShape(Circle())
                                .padding(.leading, 10)
                        
                        Text(names[index])
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.trailing, 10)
                            .padding(.leading, 19)
                        
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width - 30, height: 72)
                    .background(CustomColor.darkGrey.opacity(0.25))
                    .cornerRadius(12)
                    .padding(.top, 16)
                }
                
                Spacer()
                
                Text("Share the code:")
                    .font(.system(size: 18))
                    .fontWeight(.light)
                    .padding(.bottom, 8)
                
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    
                    Text(code)
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .padding(.leading, 38)
                    
                    Spacer()
                    
                    Button(action: {
                        let activityVC = UIActivityViewController(activityItems: ["Here is the code for our Kaboo game: \(code)"], applicationActivities: nil)
                        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .frame(width: 28)
                            .padding(.trailing, 10)
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 30, height: 42)
                .background(CustomColor.lightGrey)
                .cornerRadius(8)
                .padding(.bottom, 12)
                
                    Text("Waiting for the host to start the game")
                        .font(.system(size: 12))
                        .fontWeight(.regular)
                        .frame(width: UIScreen.main.bounds.width - 30, height: 42)
                        .background(CustomColor.lightGrey)
                        .cornerRadius(8)
                        .padding(.bottom, 15)
            }
        }
        .navigationBarHidden(true)
    }
}

