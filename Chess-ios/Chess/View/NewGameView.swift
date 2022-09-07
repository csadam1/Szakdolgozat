import SwiftUI

struct NewGameView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 100) {
            HStack(spacing: 30) {
                Button(action: {
                    appState.newGameView = false
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 30.0, height: 30.0)
                }
                
                Button("Play together offline") {
                    appState.newGameView = false
                    appState.inOfflineGameView = true
                }
                .padding(.all, 10.0)
                .dynamicTypeSize(.xxxLarge)
                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(hue: 1.0, saturation: 0.024, brightness: 0.887)/*@END_MENU_TOKEN@*/)
                .foregroundColor(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/)
            }
            .padding(.trailing, 100.0)
            
            VStack(spacing: 50) {
                Text("Join game:")
                    .dynamicTypeSize(.xxxLarge)
                
                TextField("Code", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .padding()
                    .frame(width: 150.0, height: 30.0)
                    .dynamicTypeSize(.xxxLarge)
                
                Button("Join") {
                    
                }
                .padding(.all, 10.0)
                .dynamicTypeSize(.xxxLarge)
                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(hue: 1.0, saturation: 0.024, brightness: 0.887)/*@END_MENU_TOKEN@*/)
                .foregroundColor(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/)
            }
            
            VStack(spacing: 50) {
                Text("Create new game:")
                    .dynamicTypeSize(.xxxLarge)
                
                Text("#7326")
                    .dynamicTypeSize(.accessibility3)
            }
        }
        .padding(.bottom, 150.0)
    }
}

struct NewGameView_Previews: PreviewProvider {
    static var previews: some View {
        NewGameView()
    }
}
