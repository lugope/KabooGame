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
                
                ForEach(players, id:\.id) { player in
                    Text(player.userName + " " + String(player.points))
                }
                
                Spacer()
                
                Button(action: {popToRoot = false}) {
                    Text("Exit")
                        .font(.title2.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(16)
                }
            }
            .navigationBarHidden(true)
        }
    }
}
