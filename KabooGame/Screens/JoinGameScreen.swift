//
//  JoinGameScreen.swift
//  Kaboo
//
//  Created by Aleksei Bochkov on 10/02/22.
//

import SwiftUI

struct JoinGameScreen: View {
    @Binding var isPrevScreenActive: Bool
    @State var code: String = ""
    
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
                
                Spacer()
                
                Text("ENTER THE CODE")
                    .font(.system(size: 10))
                    .fontWeight(.light)
                    .foregroundColor(CustomColor.darkGrey)
                    .padding(.bottom, 5)
                
                TextField("Code", text: $code)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 30)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.numberPad)
                    .shadow(color: CustomColor.darkGrey.opacity(0.25), radius: 4, x: 0, y: 4)
                    .onSubmit {
                        print("Entered code: \(code)")
                    }
                
                Spacer()
                Spacer()
                
                Button(action: {
                    print("Entered code: \(code)")
                }) {
                    Text("Join")
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
