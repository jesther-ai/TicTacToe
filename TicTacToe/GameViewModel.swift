//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Jesther Silvestre on 5/8/21.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    let columns : [GridItem] = [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible()),]
    @Published var moves:[GameView.Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled:Bool = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position:Int) {
        
        //for Human
        if isSquareOccupied(in: moves, forIndex: position){return}
        moves[position] = GameView.Move(player: .human, boarderIndex: position)
        
        
        if checkWinCondition(for: .human, in: moves){
            alertItem = AlertContent.humanWins
            return
        }
        if checkForDraw(in: moves){
            alertItem = AlertContent.draw
            return
            
        }
        isGameBoardDisabled = true
        
        ///Check for win condition or draw
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = GameView.Move(player:.computer, boarderIndex: computerPosition)
            isGameBoardDisabled = false
            if checkWinCondition(for: .computer, in: moves){
                alertItem = AlertContent.computerWins
                return
                
            }
            if checkForDraw(in: moves){
                alertItem = AlertContent.draw
                return
                
            }
            
        }
        
    }


//checking if its occupied
    func isSquareOccupied(in moves: [GameView.Move?], forIndex index: Int) -> Bool {
    return moves.contains(where: {$0?.boarderIndex == index})
}
//Building the AI
func determineComputerMovePosition(in moves:[GameView.Move?])->Int{
    
    //AI can win, then Win
    let winPatterns:Set<Set<Int>> = [[0,1,2],
                                     [3,4,5],
                                     [6,7,8],
                                     [0,3,6],
                                     [1,4,7],
                                     [2,5,8],
                                     [0,4,8],
                                     [2,4,6]]
    let computerMoves = moves.compactMap{$0}.filter {$0.player == .computer}
    let computerPositions = Set(computerMoves.map{$0.boarderIndex})
    //iteration on winPatterns
    for pattern in winPatterns{
        let winPosition = pattern.subtracting(computerPositions)
        if winPosition.count == 1{
            let isAvailable = !isSquareOccupied(in: moves, forIndex: winPosition.first!)
            if isAvailable { return winPosition.first!}
        }
    }
    
    
    //if AI can't win then block
    let humanMoves = moves.compactMap{$0}.filter {$0.player == .human}
    let humanPosition = Set(humanMoves.map{$0.boarderIndex})
    //iteration on winPatterns
    for pattern in winPatterns{
        let winPosition = pattern.subtracting(humanPosition)
        if winPosition.count == 1{
            let isAvailable = !isSquareOccupied(in: moves, forIndex: winPosition.first!)
            if isAvailable { return winPosition.first!}
        }
    }
    //if AI can't block then take middle position.
    let centerSquare = 4
    if !isSquareOccupied(in: moves, forIndex: centerSquare){
        return centerSquare
    }
    
    //if AI can't take middle position, then take random available square
    var movePosition = Int.random(in: 0..<9)
    while isSquareOccupied(in: moves, forIndex: movePosition){
        movePosition = Int.random(in: 0..<9)
    }
    return movePosition
}
//checkWinCondition
func checkWinCondition(for player:GameView.Player, in moves:[GameView.Move?])->Bool{
    let winPatterns:Set<Set<Int>> = [[0,1,2],
                                     [3,4,5],
                                     [6,7,8],
                                     [0,3,6],
                                     [1,4,7],
                                     [2,5,8],
                                     [0,4,8],
                                     [2,4,6]]
    let playerMoves = moves.compactMap{$0}.filter {$0.player == player}
    let playerPositions = Set(playerMoves.map{$0.boarderIndex})
    
    for pattern in winPatterns where pattern.isSubset(of: playerPositions){return true}
    
    return false
}
func checkForDraw(in moves:[GameView.Move?])->Bool{
    return moves.compactMap{$0}.count == 9
}
func resetGame() {
    moves = Array(repeating: nil, count: 9)
}
}

