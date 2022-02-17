//
//  SettingsView.swift
//  KabooGame
//
//  Created by Lorenzo Lins Mazzarotto on 16/02/22.
//

import SwiftUI

struct SettingsView: View {
    @State private var username: String = "Dude"
    @State private var isMusicOn: Bool = true
    @State private var isSFXOn: Bool = true
    @State private var isVibrationOn: Bool = true
    @State private var showingProfilePicker: Bool = false
    @State private var currentProfilePicture: String = "profile.gray"
    @State private var selectedProfilePicture: String = "profile.gray"
    
    init() {
        username = "Dude"
        isMusicOn = true
        isSFXOn = false
        isVibrationOn = true
        showingProfilePicker = false
    }
    private var profilePictures: [String] = ["profile.blue", "profile.gray", "profile.green", "profile.lightblue", "profile.orange", "profile.pink", "profile.purple", "profile.red", "profile.yellow"]
    
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
                    self.showingProfilePicker = true
                }) {
                    Image(currentProfilePicture)
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
                            TextField("Username", text: $username)
                                .focused($isUsernameFocused)
                                .multilineTextAlignment(.center)
                            Button {
                                isUsernameFocused.toggle()
                            } label: {
                                Image(systemName: "square.and.pencil")
                            }
                        }
                    }
                    
                    Toggle(isOn: $isMusicOn) {
                        Text("Music")
                    }
                    Toggle(isOn: $isSFXOn) {
                        Text("SFX")
                    }
                    Toggle(isOn: $isVibrationOn) {
                        Text("Vibration")
                    }
                }
            }
            
            if $showingProfilePicker.wrappedValue {
                VStack(alignment: .center) {
                    ZStack {
                        Text("Select Avatar")
                            .bold().padding()
                            .frame(maxWidth: .infinity)
                            .background(CustomColor.darkGrey)
                            .foregroundColor(Color.white)
                        HStack {
                            Spacer()
                            Button {
                                self.showingProfilePicker = false
                                selectedProfilePicture = currentProfilePicture
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
                                self.selectedProfilePicture = item
                            }) {
                                if item == selectedProfilePicture {
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
                    
                    HStack {
                        Button {
                            self.showingProfilePicker = false
                            self.currentProfilePicture = selectedProfilePicture
                        } label: {
                            Text("Save Changes")
                                .bold()
                                .padding(6)
                                .foregroundColor(Color.white)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(CustomColor.darkGrey)
                    
                    
                }
                .background(Color.white)
                .mask(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 20)
                .padding()
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
