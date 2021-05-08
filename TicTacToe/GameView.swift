//
//  GameView.swift
//  TicTacToe
//
//  Created by Jesther Silvestre on 5/2/21.
//

import SwiftUI



struct GameView: View {
    //array of GridItems
    @StateObject private var viewModel = GameViewModel()
    
    
    //View
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9){ i in
                        ZStack{
                            Circle()
                                .foregroundColor(.blue).opacity(0.9)
                                .frame(width: geometry.size.width/3 - 15,
                                       height: geometry.size.width/3 - 15)
                            
                            Image(systemName: viewModel.moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.black)
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                            
                        }
                    }
                    Spacer()
                }
                .disabled(viewModel.isGameBoardDisabled)
                .padding()
                .alert(item: $viewModel.alertItem, content: {alertItem in
                    Alert(title: alertItem.title ,
                          message: alertItem.message,
                          dismissButton: .default(alertItem.buttonTitle, action: {viewModel.resetGame()}))
                })
              Spacer()
            }
        }
        
    }
    
    
    //Player Object
    enum Player{
        case human, computer
    }
    
    //MOVE OBJECT
    struct Move {
        let player:Player
        let boarderIndex:Int
        
        var indicator: String{
            return player == .human ? "xmark" : "circle"
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            GameView()
        }
    }
}
