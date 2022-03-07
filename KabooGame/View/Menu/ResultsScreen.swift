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
                    HStack {
                        Text(player.userName)
                            .font(.title2.bold())
                        Text("\(String(player.points)) points ")
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
                
                Button(action: {popToRoot = false}) {
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
