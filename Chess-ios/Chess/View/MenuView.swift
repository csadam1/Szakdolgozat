import SwiftUI

struct MenuView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingAlert = false
    @State private var text = ""
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 200) {
            HStack(spacing: 10) {
                Text("john.doe.6")
                    .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xLarge/*@END_MENU_TOKEN@*/)
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 40.0, height: 40.0)
            }
            
            VStack(alignment: .trailing, spacing: 30) {
                Button("New game") {
                    appState.newGameView = true
                }
                .padding(.all, 10.0)
                .dynamicTypeSize(.xxxLarge)
                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(hue: 1.0, saturation: 0.024, brightness: 0.887)/*@END_MENU_TOKEN@*/)
                .foregroundColor(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/)
                
                Button("Previous matches") {
                    showingAlert = true
                    text = "Previous matches has not yet been implemented"
                }
                .padding(.all, 10.0)
                .dynamicTypeSize(.xxxLarge)
                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(hue: 1.0, saturation: 0.024, brightness: 0.887)/*@END_MENU_TOKEN@*/)
                .foregroundColor(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/)
                .alert(text, isPresented: $showingAlert) {
                    Button("OK", role: .cancel) {}
                }
                
                Button("Leaderboard") {
                    showingAlert = true
                    text = "Leaderboard has not yet been implemented"
                }
                .padding(.all, 10.0)
                .dynamicTypeSize(.xxxLarge)
                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(hue: 1.0, saturation: 0.024, brightness: 0.887)/*@END_MENU_TOKEN@*/)
                .foregroundColor(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/)
                .alert(text, isPresented: $showingAlert) {
                    Button("OK", role: .cancel) {}
                }
                
                Button("Friends") {
                    showingAlert = true
                    text = "Friends has not yet been implemented"
                }
                .padding(.all, 10.0)
                .dynamicTypeSize(.xxxLarge)
                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(hue: 1.0, saturation: 0.024, brightness: 0.887)/*@END_MENU_TOKEN@*/)
                .foregroundColor(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/)
                .alert(text, isPresented: $showingAlert) {
                    Button("OK", role: .cancel) {}
                }
            }
        }
        .padding(.leading, 125.0)
        .padding(.bottom, 200.0)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
