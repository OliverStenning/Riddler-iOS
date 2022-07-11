import SwiftUI

struct CorrectView: View {
    
    // ViewModel
    @EnvironmentObject var game: GameViewModel
    
    @Binding var showCorrect: Bool
    @Binding var showAchievementToast: Bool
    
    @State private var showShareToast: Bool = false
    @State private var showSuggestDialog: Bool = false
    
    var body: some View {
        ZStack {
            Background(isDark: false)
            
            VStack {
                Image("check_large")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220)
                    .foregroundColor(Color("PrimaryDark"))
                    .padding(.top, 30)
                
                Spacer()
                Text("Correct")
                    .modifier(PrimaryTextStyle(textSize: 80))
                
                Spacer()
                let textSize: CGFloat = 30
                VStack {
                    HStack {
                        Text("Guesses:")
                        Spacer()
                        Text(String(game.player.riddleStats[game.player.riddle - 1].guesses))
                    }
                    HStack {
                        Text("Time:")
                        Spacer()
                        Text(game.player.riddleStats[game.player.riddle - 1].timeString)
                    }
                }
                .modifier(PrimaryTextStyle(textSize: textSize))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                Spacer()
                HStack(spacing: 12) {
                    TextIconButton(text: "Suggest", image: "feedback", iconSize: 30, action: pressSuggest)
                    .buttonStyle(PrimaryButtonStyle())
                    .modifier(ButtonTextStyle(textSize: 30))
                    
                    TextIconButton(text: "Share", image: "share", iconSize: 30, action: pressShare)
                    .buttonStyle(PrimaryButtonStyle())
                    .modifier(ButtonTextStyle(textSize: 30))
                }

            }
            .padding(20)
            
            if showSuggestDialog {
                BasicDialog(titleText: "Missing answer?", bodyText: "Have an answer you think is also correct?", primaryText: "Suggest", secondaryText: "Close", primaryAction: pressDialogSuggest, secondaryAction: pressDialogClose)
            }
        }
        .toast(image: "bubble.left.fill", text: "Copied to clipboard", isShowing: $showShareToast)
        .toast(image: "trophy", customImage: true, text: "Achievement Unlocked!", isShowing: $showAchievementToast, duration: 5)
    }
    
    func pressSuggest() {
        withAnimation(.easeInOut(duration: 0.2)) {
            showSuggestDialog = true
        }
    }
    
    func pressShare() {
        // Log event to Firebase
        copyResultsEvent(player: game.player)
        
        withAnimation(.easeInOut(duration: 0.2)) {
            showShareToast = true
        }
        UIPasteboard.general.string = game.player.riddleResults()
    }
    
    func pressDialogSuggest() {
        withAnimation(.easeInOut(duration: 0.2)) {
            showSuggestDialog = false
            if let url = URL(string: "mailto:suggest@rddle.me?subject=I%20have%20a%20valid%20answer%20on%20riddle%20%23\(game.player.riddle)") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    func pressDialogClose() {
        withAnimation(.easeInOut(duration: 0.2)) {
            showSuggestDialog = false
        }
    }
    
}

struct CorrectView_Previews: PreviewProvider {
    static var previews: some View {
        CorrectView(showCorrect: .constant(true), showAchievementToast: .constant(false))
            .environmentObject(GameViewModel())
    }
}
