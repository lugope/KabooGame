//
//  TutorialView.swift
//  KabooGame
//
//  Created by Lorenzo Lins Mazzarotto on 15/02/22.
//

import SwiftUI

struct TutorialView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }) {
        HStack {
            Image(systemName: "arrow.left")
        }
    }
    }
    
    var body: some View {
        Form {
            Section {
                Text("Each player has 4 cards in front of him face down in a form of a square. At the beginning of the game every player looks at two of his cards which are on the bottom. Other cards are in the deck face down. First player should be chosen randomly. After it he opens the top card from the deck and places it next to the deck face up. This is a discard pile. After this players do turns after each other in a clockwise order")
            } header: {
                Text("How does Kaboo work?")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .listRowBackground(Color.clear)
            
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
        }
        .navigationTitle("How to play")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
