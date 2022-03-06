////
////  CreateGameScreen.swift
////  Kaboo
////
////  Created by Aleksei Bochkov on 10/02/22.
////
//
//import SwiftUI
//
//struct CreateGameScreen: View {
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
//    @State private var names: [String?] = ["Dude", "Lebowski", nil, nil]
//    @State private var avatars: [String?] = ["profile.green", "profile.blue", nil, nil]
//    
//    func addOpponent(avatar: String, name: String) {
//        guard names.filter({$0 != nil}).count < 4, let index = names.firstIndex(of: nil) else { return }
//        names[index] = name
//        avatars[index] = avatar
//    }
//    
//    func deleteOpponent(index: Int) {
//        names[index] = nil
//        avatars[index] = nil
//    }
//    
//    var body: some View {
//        ZStack {
//            CustomColor.background
//                .ignoresSafeArea()
//            
//            VStack(alignment: .center, spacing: 0) {
//                ForEach(names.indices, id: \.self) {index in
//                    HStack(alignment: .center, spacing: 0) {
//                        if let avatar = avatars[index] {
//                            Image(avatar)
//                                .resizable()
//                                .frame(width: 42, height: 42, alignment: .center)
//                                .clipShape(Circle())
//                                .padding(.leading, 10)
//                        } else {
//                            Circle()
//                                .frame(width: 42, height: 42)
//                                .foregroundColor(.white)
//                                .padding(.leading, 10)
//                        }
//                        
//                        Text(names[index] ?? "Joining...")
//                            .font(.system(size: 24))
//                            .fontWeight(.bold)
//                            .foregroundColor(.white)
//                            .padding(.trailing, 10)
//                            .padding(.leading, 19)
//                        
//                        Spacer()
//                        
//                        if index != 0, avatars[index] != nil, names[index] != nil {
//                            Button(action: {
//                                if index == 1 {
//                                    addOpponent(avatar: "profile.red", name: "Danil")
//                                } else {
//                                    deleteOpponent(index: index)
//                                }
//                            }) {
//                                Image(systemName: "xmark")
//                                    .frame(width: 24, height: 24)
//                                    .padding(.trailing, 10)
//                                    .foregroundColor(.white)
//                            }
//                        }
//                    }
//                    .frame(width: UIScreen.main.bounds.width - 30, height: 72)
//                    .background(CustomColor.darkGrey.opacity(0.25))
//                    .cornerRadius(12)
//                    .padding(.top, 16)
//                }
//                
//                Spacer()
//                
//                Text("Share the code:")
//                    .font(.system(size: 18))
//                    .fontWeight(.light)
//                    .padding(.bottom, 8)
//                
//                HStack(alignment: .center, spacing: 0) {
//                    Spacer()
//                    
//                    Text(code)
//                        .font(.system(size: 24))
//                        .fontWeight(.bold)
//                        .padding(.leading, 38)
//                    
//                    Spacer()
//                    
//                    Button(action: {
//                        let activityVC = UIActivityViewController(activityItems: ["Here is the code for our Kaboo game: \(code)"], applicationActivities: nil)
//                        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
//                    }) {
//                        Image(systemName: "square.and.arrow.up")
//                            .frame(width: 28)
//                            .padding(.trailing, 10)
//                    }
//                }
//                .frame(width: UIScreen.main.bounds.width - 30, height: 42)
//                .background(CustomColor.lightGrey)
//                .cornerRadius(8)
//                .padding(.bottom, 12)
//                
//                NavigationLink(destination: ContentView()) {
//                    Text("Start the game")
//                        .foregroundColor(.white)
//                        .font(.system(size: 14))
//                        .fontWeight(.semibold)
//                        .frame(width: UIScreen.main.bounds.width - 30, height: 42)
//                        .background(CustomColor.blue)
//                        .cornerRadius(8)
//                        .padding(.bottom, 15)
//                }
//            }
//        }
//        .navigationTitle("Create a game")
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: btnBack)
//    }
//}
