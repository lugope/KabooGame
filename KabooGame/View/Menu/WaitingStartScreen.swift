//
//  WaitingStartScreen.swift
//  KabooGame
//
//  Created by Aleksei Bochkov on 18/02/22.
//

import SwiftUI

struct WaitingStartScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }) {
        HStack {
            Image(systemName: "arrow.left")
        }
    }
    }
    
    @State private var code: String = "123"
    @State private var names: [String?] = ["Dude", "Lebowski", nil, nil]
    @State private var avatars: [String?] = ["profile.green", "profile.blue", nil, nil]
    
    var body: some View {
        ZStack {
            CustomColor.background
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {                
                ForEach(names.indices, id: \.self) { index in
                    HStack(alignment: .center, spacing: 0) {
                        Image(avatars[0]!)
                            .resizable()
                            .frame(width: 42, height: 42, alignment: .center)
                            .clipShape(Circle())
                            .padding(.leading, 10)
                        
                        Text(names[0]!)
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
        .navigationTitle("Join")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
}

