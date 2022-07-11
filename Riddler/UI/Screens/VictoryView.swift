import SwiftUI

struct VictoryView: View {

    // ViewModel
    @EnvironmentObject var game: GameViewModel

    @State var showStats: Bool = false
    @State private var showShareToast: Bool = false
    
    @Binding var mainScreen: String?

    var body: some View {
        ZStack {
            Background(isDark: false)

            LottieView(name: "confetti", loopMode: .loop)
                .opacity(0.2)

            BackButton(pressBack: pressBack)
                .buttonStyle(PrimaryButtonStyle())

            VStack(spacing: 10) {
                
                Spacer()
                
                LottieView(name: "trophy", loopMode: .playOnce)
                    .opacity(1)
                    .frame(width: 320, height: 320)
                
                // Main text
                VStack {
                    Text("You have beaten")
                        .modifier(PrimaryTextStyle(textSize: 36))
                        .modifier(MultilineTextStyle())

                    Text("Riddler")
                        .modifier(PrimaryTextStyle(textSize: 80))
                }
                .padding(.bottom, 12)

                // Stats and share buttons
                HStack(spacing: 12) {
                    TextIconButton(text: "Stats", image: "stats", iconSize: 30, action: pressStats)
                    .buttonStyle(PrimaryButtonStyle())
                    .modifier(ButtonTextStyle(textSize: 30))
                    
                    TextIconButton(text: "Share", image: "share", iconSize: 30, action: pressShare)
                    .buttonStyle(PrimaryButtonStyle())
                    .modifier(ButtonTextStyle(textSize: 30))
                }

            }
            .padding(20)

        }
        .zIndex(2)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        
        .sheet(isPresented: $showStats, content: {
            StatsView(statValues: game.player.victoryStats())
        })
        
        .toast(image: "bubble.left.fill", text: "Copied to clipboard", isShowing: $showShareToast)
    }
    
    func pressStats() { showStats = true }
    
    func pressShare() {
        // Log event to firebase
        copyResultsEvent(player: game.player)
        withAnimation(.easeInOut(duration: 0.2)) {
            showShareToast = true
        }
        
        UIPasteboard.general.string = game.player.playerResults()
    }
    
    func pressBack() { mainScreen = nil }

}

struct VictoryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VictoryView(mainScreen: .constant("Riddle"))
                .environmentObject(GameViewModel())
        }
    }
}
