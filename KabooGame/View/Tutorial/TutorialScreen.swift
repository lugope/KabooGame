//
//  TutorialScreen.swift
//  KabooGame
//
//  Created by Lorenzo Lins Mazzarotto on 15/02/22.
//

import SwiftUI
import SpriteKit

protocol TutorialScreenDelegate {
    func finishStep(_ calledScene: TutorialScene)
    func finishGame(players: [Player])
}

fileprivate var myScene: TutorialScene?

struct TutorialScreen: View, TutorialScreenDelegate {
    
    func finishGame(players: [Player]) {
        finalPlayers = players
        showResults = true
        finishStep(scene)
    }
    
    func finishStep(_ calledScene: TutorialScene) {
        myScene = calledScene
        step = (step + 1) % explanation.count
        showExplanationStep = true
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showTutorial = true
    @State private var showExplanationStep = true
    @State private var explanation = ["Let's start our tutorial! Each player has 4 cards. The goal of the game to get as less points as possible.\n\nAt your turn you can do one of a few things. First of them is to swap a card from a discard pile with one of yours.\n\nFor that tap on a discard pile (faced up card in the center) and then tap on one of current player's (the player with blue badge) cards.",
                                      "Nice job! Second thing you can do is to draw a card from deck.\n\nFor that double tap on the deck (faced down card in the center).",
                                      "Now one of the things you can do with this card - is to swap it with one of yours the same way you did that with discard pile.",
                                      "Another type of move is to draw a card and discard it by double tapping on the discard pile. Try it!",
                                      "Any time any player can try to snap one of his/her cards. For doing that you need to drag and drop a card to a discard pile.\n\nIf it has the same value as the top discard pile card you lose your card which is good. If it's different, then you get a penalty 5 points.",
                                      "And the last option for your turn is to call a Kaboo!\n\nFor doing that press the Kaboo button and this is the last turn for everyone. Kaboooooo!",
                                      "Now everyone else do their last move and this is the end of the game!\n\nThe player with the least points wins. Good luck, have fun :)"]
    @State private var step = 0
    @State private var showResults = false
    @State private var finalPlayers: [Player] = []
    
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }) {
        HStack {
            Image(systemName: "arrow.left")
        }
    }
    }
    
    var scene: TutorialScene {
        let scene = TutorialScene()
        scene.size = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        scene.scaleMode = .fill
        scene.tutorialScreenDelegate = self
        return scene
    }
    
    var body: some View {
        ZStack {
            CustomColor.background
                .ignoresSafeArea()
            
            VStack {
                if showTutorial {
                    if showResults {
                        ResultsScreen(players: finalPlayers, popToRoot: $showResults)
                    } else if showExplanationStep {
                        Picker("Rules or tutorial?", selection: $showTutorial) {
                            Text("Tutorial").tag(true)
                            Text("Rules").tag(false)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        Text(explanation[step])
                            .background(CustomColor.background)
                            .padding(.horizontal, 32)
                            .font(.system(size: SCREEN_HEIGHT <= 736 ? 20 : 25))
                        
                        Spacer()
                        
                        Button(action: {
                            showExplanationStep = false
                        }) {
                            Text("Try")
                                .font(.title2.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.bottom)
                        .padding(.horizontal)
                        .navigationTitle("How to play")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(leading: btnBack)
                    } else {
                        SpriteView(scene: myScene ?? scene)
                            .frame(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                            .ignoresSafeArea()
                    }
                } else {
                    Picker("Rules or tutorial?", selection: $showTutorial) {
                        Text("Tutorial").tag(true)
                        Text("Rules").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    Form {
                        Section {
                            Text("Each player has 4 cards in front of him face down in a form of a square. At the beginning of the game every player looks at two of his cards which are on the bottom. Other cards are in the deck face down. First player should be chosen randomly. After it he opens the top card from the deck and places it next to the deck face up. This is a discard pile. After this players do turns after each other in a clockwise order")
                        } header: {
                            Text("How does Kaboo work?")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        
                        Section {
                            Text("1. Take a top card from a discard pile and swap it with one of your cards (put a card from a discard pile face down). Swapped card goes on the top of discard pile face up, no action applied.")
                            Text("2. Take a card from a deck and take a look at it. Either swap it with one of yours (in a same way as in “1.”) either discard it. If you discard a card from a deck and it has an action you can use it.")
                            Text("3. Say “Kaboo”. After it every other player makes one last move and the game is over. Everyone open their cards and calculate points, but about it later")
                        } header: {
                            Text("What can you do in your turn?")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        
                        Section {
                            Text("Every card in Kaboo has a value here is a full list of cards, their values, actions and count in the deck:")
                            Text(
                                """
                                ⁃ "1”, 2 cards
                                ⁃ “0”, 2 cards
                                ⁃ “1”, 4 cards
                                ⁃ “2”, 4 cards
                                ⁃ “3”, 4 cards
                                ⁃ “4”, 4 cards
                                ⁃ “5”, 4 cards
                                ⁃ “6”, 4 cards
                                ⁃ “7”, 4 cards, magnifying glass
                                ⁃ “8”, 4 cards, magnifying glass
                                ⁃ “9”, 4 cards, binocular
                                ⁃ “10”, 4 cards, binocular
                                ⁃ “11”, 4 cards, arrows
                                ⁃ “12”, 4 cards, arrows
                                ⁃ “13”, 2 cards, binocular with arrows
                                """)
                            Text(
                                """
                                ⁃ “Magnifying glass” - take a look at any of your cards
                                ⁃ “Binocular” - take a look at any of someone’s cards
                                ⁃ “Arrows” - blindly exchange one of your cards with someone else’s card
                                ⁃ “Binocular with arrows” - take a look at someone’s card and, if you want, exchange it with one of your cards
                                """)
                        } header: {
                            Text("What are the types of cards?")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        
                        Section {
                            Text("Any time you can try to snap one or more of his cards with same value as the card on top of discard pile. For this you open one of your cards and put at the top of discard pile. The first person who does it “wins the race” (in case of several people trying to snap) and other people don’t get to snap this time. ")
                            Text("After “winning the race” you can put on top of discard pile other cards with the same value. If you mistaken with value of any card (for example there was a 7 on the top and you’re trying to put 9), you take your cards back and additionally draw cards from the deck and place add them to yours (there can’t be more than 6 six cards for each player).")
                            Text("With snapping there may be a situation where a player got rid of all of his/her cards. In this case the game stops and this person wins. If someone has an action to do (last card snapped during an action or right before it) then this player finishes an action.")
                        } header: {
                            Text("How you can get rid of your cards?")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        
                        Section {
                            Text("If someone got rid of all cards then he/she wins the round. If every player has at least 1 card then wins a player with the least amount of points. If there is a tie then a person called Kaboo doesn’t win. In a tournament mode a winner of the round gets 0 points and other players get an amount of points they have on the table. If a person, who called Kaboo, has more than 5 points, than he gets a penalty of 10 points. The game goes until someone reaches more than a limit of a game. If someone reaches exactly the limit, his points should be decreased to the half of the limit")
                        } header: {
                            Text("Who wins at the end?")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .navigationTitle("How to play")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(leading: btnBack)
                }
            }
            .background(CustomColor.background)
        }
    }
}
