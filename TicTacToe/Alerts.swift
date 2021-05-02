//
//  Alerts.swift
//  TicTacToe
//
//  Created by Jesther Silvestre on 5/2/21.
//

import SwiftUI

struct AlertItem:Identifiable {
    let id = UUID()
    var title : Text
    var message : Text
    var buttonTitle : Text
}

struct AlertContent {
    static let humanWins = AlertItem(title: Text("YOU WIN!"),
                                     message: Text("You beat your own Iphone"),
                                     buttonTitle: Text("Hell Yeah"))
    static let computerWins  = AlertItem(title: Text("YOU LOST!"),
                                         message: Text("Your Iphone Beat your ASS"),
                                         buttonTitle: Text("Rematch"))
    static let draw = AlertItem(title: Text("DRAW!"),
                                message: Text("What a battle of wits"),
                                buttonTitle: Text("Try Again"))
}
