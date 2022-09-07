import SwiftUI

struct InOfflineGameView: View {
    @EnvironmentObject var appState: AppState
    @State var highlight = (0...63).map { _ in Color.red.opacity(0.0) }
    @State var currentColor: String
    @State var toggle = false
    @State var toggle2 = false
    
    @State var allMoves: Array<Array<Spot>>? = nil
    @State var fromSpot: Spot? = nil
    @State var toSpot: Spot? = nil
    @State var showPanel = false
    @State var gameOver = false
    @State var gameOverText = ""
    @State var offerDraw = false
    
    let columns = (1...8).map { _ in GridItem() }
    var game: Game
    
    init() {
        let p1 = Player(isWhite: true)
        let p2 = Player(isWhite: false)
        game = Game(player1: p1, player2: p2)
        currentColor = getCurrentColor(game: game)
    }

    var body: some View {
        VStack {
            HStack {
                Button("Resign") {
                    proposal(player: game.getCurrentPlayer(), game: game, input: "r")
                    game.updateStatus()
                    if isGameOver(game: game) {
                        announceGameEnd(game: game, gameOver: &gameOver, gameOverText: &gameOverText)
                    }
                    updateGameState(state: &toggle)
                    updateGameState(state: &toggle2)
                }
                .padding()
                .dynamicTypeSize(.xxxLarge)
                Button("Offer draw") {
                    offerDraw = true
                }
                .dynamicTypeSize(.xxxLarge)
                .padding()
            }
            .disabled(showPanel || gameOver || offerDraw)
            
            Text(currentColor)
                .lineLimit(nil)
                .padding(.horizontal)
                .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xxxLarge/*@END_MENU_TOKEN@*/)
                .onChange(of: toggle, perform: { _ in
                    currentColor = getCurrentColor(game: game)
                })
            
            ZStack {
                Image("chess_board")
                    .resizable()
                    .frame(width: 400.0, height: 400.0)
                
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach((0...63), id: \.self) { i in
                        setLayout(game: game, pos: i)
                            .frame(width: 50.0, height: 50.0)
                            .background(highlight[i])
                            .onTapGesture {
                                let player = game.getCurrentPlayer()
                                let selectedSpot = game.board.board[i/8][i%8]
                                
                                if (player.isWhite == selectedSpot.piece.isWhite) {
                                    fromSpot = selectedSpot
                                    selectSpot(game: game, spot: fromSpot, toSpot: &toSpot, allMoves: &allMoves)
                                    
                                    updateGameState(state: &toggle2)
                                } else {
                                    updateGameState(state: &toggle2)
                                    if (fromSpot != nil && game.isPromotion(fromSpot: fromSpot!)) {
                                        selectSpotToMovePromo(spot: selectedSpot, toSpot: &toSpot, showPanel: &showPanel)
                                    } else {
                                        selectSpotToMove(game: game, player: player, spot: selectedSpot, fromSpot: &fromSpot, toSpot: &toSpot)
                                    }
                                }
                                
                                game.updateStatus()
                                if isGameOver(game: game) {
                                    announceGameEnd(game: game, gameOver: &gameOver, gameOverText: &gameOverText)
                                }
                                updateGameState(state: &toggle)
                            }
                            .onChange(of: toggle2, perform: { _ in
                                if !game.board.board[i/8][i%8].highlighted {
                                    highlight[i] = Color.red.opacity(0.0)
                                } else {
                                    highlight[i] = Color.red.opacity(0.5)
                                }
                            })
                    }
                }
                .padding(.vertical, 4.0)
                .frame(width: 400.0, height: 400.0)
                
                if showPanel {
                    HStack(spacing: 20) {
                        Image("promo_queen")
                            .frame(width: 75.0, height: 75.0)
                            .background(Color.gray)
                            .onTapGesture {
                                promotion(promo: "q", player: game.getCurrentPlayer(), game: game, showPanel: &showPanel, fromSpot: &fromSpot, toSpot: &toSpot)
                                updateGameState(state: &toggle)
                                updateGameState(state: &toggle2)
                            }
                        Image("promo_rook")
                            .frame(width: 75.0, height: 75.0)
                            .background(Color.gray)
                            .onTapGesture {
                                promotion(promo: "r", player: game.getCurrentPlayer(), game: game, showPanel: &showPanel, fromSpot: &fromSpot, toSpot: &toSpot)
                                updateGameState(state: &toggle)
                                updateGameState(state: &toggle2)
                            }
                        Image("promo_bishop")
                            .frame(width: 75.0, height: 75.0)
                            .background(Color.gray)
                            .onTapGesture {
                                promotion(promo: "b", player: game.getCurrentPlayer(), game: game, showPanel: &showPanel, fromSpot: &fromSpot, toSpot: &toSpot)
                                updateGameState(state: &toggle)
                                updateGameState(state: &toggle2)
                            }
                        Image("promo_knight")
                            .frame(width: 75.0, height: 75.0)
                            .background(Color.gray)
                            .onTapGesture {
                                promotion(promo: "n", player: game.getCurrentPlayer(), game: game, showPanel: &showPanel, fromSpot: &fromSpot, toSpot: &toSpot)
                                updateGameState(state: &toggle)
                                updateGameState(state: &toggle2)
                            }
                    }
                    .frame(width: 400, height: 400)
                    .background(Color.blue.opacity(0.01))
                }
                
                if gameOver {
                    VStack(spacing: 30) {
                        Button(action: {
                            appState.inOfflineGameView = false
                        }) {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .frame(width: 30.0, height: 30.0)
                        }
                        
                        Text(gameOverText)
                            .dynamicTypeSize(.accessibility1)
                            .padding(.all, 20)
                    }
                    .frame(width: 400, height: 400)
                    .background(Color.white.opacity(0.9))
                }
                
                if offerDraw {
                    VStack(spacing: 20) {
                        Text("Do you accept DRAW?")
                            .dynamicTypeSize(.xxLarge)
                        
                        HStack(spacing: 40) {
                            Button("YES") {
                                offerDraw = false
                                proposal(player: game.getCurrentPlayer(), game: game, input: "y")
                                game.updateStatus()
                                if isGameOver(game: game) {
                                    announceGameEnd(game: game, gameOver: &gameOver, gameOverText: &gameOverText)
                                }
                                updateGameState(state: &toggle)
                                updateGameState(state: &toggle2)
                            }
                            .padding(.all, 10.0)
                            .dynamicTypeSize(.xxxLarge)
                            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(hue: 1.0, saturation: 0.024, brightness: 0.887)/*@END_MENU_TOKEN@*/)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/)
                            
                            Button("NO") {
                                offerDraw = false
                            }
                            .padding(.all, 10.0)
                            .dynamicTypeSize(.xxxLarge)
                            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(hue: 1.0, saturation: 0.024, brightness: 0.887)/*@END_MENU_TOKEN@*/)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/)
                        }
                    }
                    .frame(width: 400, height: 400)
                    .background(Color.white.opacity(0.9))
                }
            }
        }
    }
}

struct InOfflineGameView_Previews: PreviewProvider {
    static var previews: some View {
        InOfflineGameView()
    }
}
