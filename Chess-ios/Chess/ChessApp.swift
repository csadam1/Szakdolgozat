import SwiftUI

class AppState: ObservableObject {
    @Published var newGameView: Bool
    @Published var inOfflineGameView: Bool
    
    init() {
        self.newGameView = false
        self.inOfflineGameView = false
    }
}

@main
struct ChessApp: App {
    @ObservedObject var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if appState.newGameView {
                NewGameView()
                    .environmentObject(appState)
            } else if appState.inOfflineGameView {
                InOfflineGameView()
                    .environmentObject(appState)
            } else {
                MenuView()
                    .environmentObject(appState)
            }
        }
    }
}
