//
//  SettingsView.swift
//  KabooGame
//
//  Created by Lorenzo Lins Mazzarotto on 16/02/22.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("username") var savedUsername = "Dude"
    @AppStorage("picture") var savedPicture = "profile.gray"
    @AppStorage("music") var savedMusic = true
    @AppStorage("sfx") var savedSfx = true
    @AppStorage("vibration") var savedVibration = true
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }) {
        HStack {
            Image(systemName: "arrow.left")
        }
    }
    }
    
    @State private var showingProfilePicker: Bool = false
    
    private let profilePictures: [String] = ["profile.blue", "profile.gray", "profile.green", "profile.lightblue", "profile.orange", "profile.pink", "profile.purple", "profile.red", "profile.yellow"]
    
    @FocusState private var isUsernameFocused: Bool
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            CustomColor.background
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
                Button(action: {
                    showingProfilePicker = true
                }) {
                    Image($savedPicture.wrappedValue)
                        .resizable()
                        .frame(width: 150, height: 150, alignment: .center)
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(.white, lineWidth: 4)
                        }
                }
                
                Form {
                    Section {
                        HStack {
                            TextField("Username", text: $savedUsername)
                                .focused($isUsernameFocused)
                                .multilineTextAlignment(.center)
                            Button {
                                isUsernameFocused.toggle()
                            } label: {
                                Image(systemName: "square.and.pencil")
                            }
                        }
                    }
                    
                    Toggle("Music", isOn: $savedMusic).onChange(of: savedMusic) { _savedMusic in
                        print(savedMusic)
                        if !savedMusic {
                            SoundManager.sharedManager.backgroundPlayer?.stop()
                        } else {
                            SoundManager.sharedManager.playBackground()
                        }
                    }
                    Toggle("SFX", isOn: $savedSfx)
                    Toggle("Vibration", isOn: $savedVibration)
                }
                .background(CustomColor.background)
            }
            
            if $showingProfilePicker.wrappedValue {
                VStack(alignment: .center) {
                    ZStack {
                        Text("Select Avatar")
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(CustomColor.darkGrey)
                            .foregroundColor(Color.white)
                        HStack {
                            Spacer()
                            Button {
                                showingProfilePicker = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .padding()
                            }
                        }
                        
                    }
                    .foregroundColor(Color.white)
                    .background(CustomColor.darkGrey)
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(profilePictures, id: \.self) { item in
                            Button(action: {
                                savedPicture = item
                                showingProfilePicker = false
                            }) {
                                if item == savedPicture {
                                    Image(item)
                                        .resizable()
                                        .frame(width: 70, height: 70, alignment: .center)
                                        .clipShape(Circle())
                                        .overlay {
                                            Circle().stroke(.black, lineWidth: 2)
                                        }
                                } else {
                                    Image(item)
                                        .resizable()
                                        .frame(width: 70, height: 70, alignment: .center)
                                        .clipShape(Circle())
                                }
                            }
                        }
                    }
                    .padding()
                }
                .background(Color.white)
                .mask(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 20)
                .padding()
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
