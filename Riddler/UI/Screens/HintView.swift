import SwiftUI

struct HintView: View {
    
    // ViewModel
    @EnvironmentObject var game: GameViewModel
    
    // UI State
    @Binding var showHint: Bool
    
    @State private var showAdDialog: Bool = false
    @State private var showAdFailedDialog: Bool = false
    @State private var showAdError: Bool = false
    @State private var showRewardedVideo: Bool = false
    @State private var showHintToast: Bool = false
    
    var body: some View {
        ZStack {
            Background(isDark: true)
            BackButton(pressBack: pressBack)
                .buttonStyle(AccentButtonStyle())
            
            // Main UI
            VStack {
                Text("\(game.player.riddleStats[game.player.riddle].hintsUsed)/\(game.riddles[game.player.riddle].hints.count)")
                    .modifier(AccentTextStyle(textSize: 50))
                
                Spacer()
                Text(game.hintString())
                    .modifier(AccentTextStyle(textSize: 30))
                    .modifier(MultilineTextStyle())

                Spacer()
                HStack {
                    Button(action: pressHint) {
                        Text(buttonString)
                            //.padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                            .frame(width: 250, height: 50)
                    }
                        .modifier(ButtonTextStyle(textSize: 30))
                        .buttonStyle(AccentButtonStyle(disabled: buttonDisabled))
                        .disabled(buttonDisabled)
                        
                    IconButton(image: "add", size: 30, action: pressAdd)
                        .buttonStyle(AccentButtonStyle())
                    
                }
                
            }
            .padding(20)
            
            // Ad Dialog
            if showAdDialog {
                BasicDialog(titleText: "Need some help?", bodyText: "Watch an ad to unlock 3 more hints", primaryText: "Watch", secondaryText: "Close", primaryAction: pressWatch, secondaryAction: pressAdClose)
            }
            
            // Ad failed to load dialog
            if showAdFailedDialog {
                AdFailedDialog(privacyAction: pressUpdatePrivacy, closeAction: pressAdFailedClose)
            }

            
        }
        .toast(image: "exclamationmark.triangle.fill", text: "Failed to show ad", isShowing: $showAdError, isError: true)
        .toast(image: "", text: "Riddle has no more hints!", isShowing: $showHintToast)
        
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        
        .presentRewardedAd(isPresented: $showRewardedVideo, isErrorShowing: $showAdError, adUnitId: rewardedId, rewardFunc: hintReward, game: game)
        
    }
    
    var buttonString: String {
        return game.player.hints == 0 ? "Out of hints" : "Use hint: \(game.player.hints) remaining"
    }
    
    var buttonHidden: Bool {
        return game.player.riddleStats[game.player.riddle].hintsUsed == 2 ? true : false
    }
    
    var buttonDisabled: Bool {
        return game.player.hints == 0 ? true : false
    }
    
    func hintReward() {
        game.hintReward()
    }
    
    // MARK: - Button actions
    func pressBack() {
        showHint = false
    }
    
    func pressAdClose() {
        withAnimation(.easeOut(duration: 0.15)) {
            showAdDialog = false
        }
    }
    
    func pressAdFailedClose() {
        withAnimation(.easeIn(duration: 0.15)) {
            showAdFailedDialog = false
        }
    }
    
    func pressHint() {
        if game.hintUsable() {
            game.useHint()
        } else {
            showHintToast = true
        }
    }
    
    func pressAdd() {
        withAnimation(.easeIn(duration: 0.15)) {
            showAdDialog = true
        }
    }
    
    func pressWatch() {
        showAdDialog = false
        
        // Check to see if ad is loaded
        if RewardedAd.shared.rewardedAd != nil {
            showRewardedVideo = true
        } else {
            withAnimation(.easeIn(duration: 0.15)) {
                showAdFailedDialog = true
            }
        }
    }
    
    func pressUpdatePrivacy() {
        showAdFailedDialog = false
        
        ConsentManager.shared.displayConsentForm(forceDisplay: true)
    }
}

struct HintView_Previews: PreviewProvider {
    static var previews: some View {
        HintView(showHint: .constant(true))
            .environmentObject(GameViewModel())
    }
}
