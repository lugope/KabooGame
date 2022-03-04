////
////  JoinGameScreen.swift
////  Kaboo
////
////  Created by Aleksei Bochkov on 10/02/22.
////
//
//import SwiftUI
//
//struct JoinGameScreen: View {
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//
//    var btnBack : some View { Button(action: {
//        self.presentationMode.wrappedValue.dismiss()
//    }) {
//        HStack {
//            Image(systemName: "arrow.left")
//        }
//    }
//    }
//
//    @State private var code: String = "123"
//
//    var body: some View {
//        ZStack {
//            CustomColor.background
//                .ignoresSafeArea()
//
//            VStack {
//                Spacer()
//                Text("Enter the code")
//                    .font(.subheadline.weight(.semibold))
//                    .foregroundColor(.secondary)
//                VStack {
//                    TextField("Enter the code", text: $code)
//                        .font(.title2.bold())
//                        .padding()
//                        .foregroundColor(.black)
//                }
//                .background(.white)
//                .cornerRadius(10)
//                .keyboardType(.numberPad)
//                .multilineTextAlignment(.center)
//
//                Spacer()
//
//                NavigationLink(destination: WaitingStartScreen()) {
//                    Text("Join")
//                        .font(.title2.weight(.semibold))
//                        .frame(maxWidth: .infinity)
//                        .padding(8)
//                }
//                .buttonStyle(.borderedProminent)
//            }
//            .padding(32)
//        }
//        .navigationTitle("Join")
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: btnBack)
//    }
//}
//
//struct JoinGameScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            NavigationView {
//                JoinGameScreen()
//            }
////            .preferredColorScheme(.dark)
//        }
//    }
//}
