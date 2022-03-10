//
//  ResultsScreen.swift
//  KabooGame
//
//  Created by Aleksei Bochkov on 04/03/22.
//

import SwiftUI

struct ResultsScreen: View {
    var players: [Player]
    
    @Binding var popToRoot: Bool
    
    var body: some View {
        ZStack {
            CustomColor.background
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                let sortedPlayers = players.sorted {
                    $0.points < $1.points
                }
                
                Text("🏆")
                    .font(.system(size: SCREEN_HEIGHT <= 736 ? 100 : 150))
                
                ForEach(sortedPlayers.indices) { index in
                    HStack {
                        Image(systemName: "\(index + 1).circle.fill")
                        Spacer()
                        Text(sortedPlayers[index].userName)
                            .font(.title2.bold())
                        Text("\(sortedPlayers[index].points) points")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(index+1 == 1 ? .yellow : CustomColor.lightGrey)
                    .cornerRadius(20)
                    .font(.title2.bold())
                    .padding(.horizontal, 32)
                    .padding(.vertical, 4)
                }
                
                Spacer()
                
                Button(action: { popToRoot = false }) {
                    Text("Exit")
                        .font(.title2.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(16)
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom)
                .padding(.horizontal)
                //.frame(height: 30)
            }
        }
        .navigationBarTitle("Results")
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}
