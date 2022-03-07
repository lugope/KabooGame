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
                
                ForEach(sortedPlayers.indices) { index in
                    HStack {
                        Image(systemName: "\(index + 1).circle.fill")
                        Text(sortedPlayers[index].userName)
                            .font(.title2.bold())
                        Text("\(String(sortedPlayers[index].points)) points ")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(CustomColor.lightGrey)
                    .cornerRadius(20)
                    .font(.title2.bold())
                    .padding()
                    
                }
                
                Spacer()
                
                Button(action: { popToRoot = false }) {
                    Text("Exit")
                        .font(.title2.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(16)
                }
            }
        }
        .navigationBarTitle("Results")
        .navigationBarBackButtonHidden(true)
    }
}
