import SwiftUI
import GoogleMobileAds
import StoreKit
import AdSupport
import Firebase

struct RiddleView: View {
    
    // ViewModel
    @EnvironmentObject var game: GameViewModel
    
    // Parent UI State
    @Binding var mainScreen: String?
    
    // UI State
    @State private var showCorrect = false
    @State private var showHints = false
    @State private var showVictory: Bool = false
    @State private var showRating = false
    @State private var showInterstitial = false
    @State private var showAchievementToast = false
    
    @State private var answerString = ""
    @State private var attempts = 0
    
    var body: some View {
        
        ZStack {
            GeometryReader { metrics in
                ZStack {
                    NavigationLink(destination: HintView(showHint: $showHints), isActive: $showHints) { EmptyView() }
                    
                    Background(isDark: true)
                    BackButton(pressBack: pressBack)
                        .buttonStyle(AccentButtonStyle())
                    
                    VStack {
                        // Riddle number
                        Text(game.riddleNumString)
                            .modifier(AccentTextStyle(textSize: 50))
                        Spacer()
                        
                        // Riddle
                        Text(game.riddles[game.player.riddle].question)
                            .modifier(AccentTextStyle(textSize: 30))
                            .modifier(MultilineTextStyle())
                        Spacer()
                        
                        VStack(spacing: 10) {
                            // Hint button
                            HStack {
                                Spacer()
                                Button(action: pressHint) {
                                    Text("Hints: \(game.player.hints)")
                                        .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                                }
                                .buttonStyle(AccentButtonStyle(disabled: false))
                                .modifier(ButtonTextStyle(textSize: 30))
                            }
                            
                            // Answer box
                            HStack {
                                TextField("", text: $answerString)
                                    .placeholder("Answer", when: answerString.isEmpty)
                                    .modifier(AccentTextFieldStyle(textSize: 30))
                                    .modifier(Shake(animatableData: CGFloat(attempts)))
                                
                                IconButton(image: "forward", size: 32, action: pressEnter)
                                    .buttonStyle(AccentButtonStyle())
                            }
                        }
                    }
                    .padding(20)
                    
                    .sheet(isPresented: $showCorrect, content: {
                        CorrectView(showCorrect: $showCorrect, showAchievementToast: $showAchievementToast)
                            .onDisappear(perform: correctDismiss)
                            .environmentObject(game)
                    })
                    
                }
                .presentInterstitialAd(isPresented: $showInterstitial, adUnitId: interstitialId)
                
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
            
                .onTapGesture { hideKeyboard() }
            }
            
            if game.player.completed {
                VictoryView(mainScreen: $mainScreen)
            }
        }
    }
    
    // MARK: - Button actions
    func pressBack() {
        mainScreen = nil
    }
    
    func pressHint() {
        // Log event to firebase
        openHintsEvent(player: game.player)
        showHints = true
    }
    
    func pressEnter() {
        let results = game.checkAnswer(inputAnswer: answerString)
        if results.0 == true {
            if results.1 == true {
                showAchievementToast = true
            }
            
            hideKeyboard()
            showCorrect = true
            answerString = ""
        } else {
            withAnimation(.default) {
                self.attempts += 1
            }
        }
    }
    
    func correctDismiss() {
        
        game.updateRiddleStart()
        
        if game.player.completed {
            withAnimation(.easeIn(duration: 0.25)) {
                showVictory = true
            }
        } else {
            // Either showing rating dialog or ad
            if game.player.askRating() && !TestVariables.DISABLE_RATING_POPUP {
                if let windowScene = UIApplication.shared.windows.first?.windowScene { SKStoreReviewController.requestReview(in: windowScene)
                    game.setRatingAsk()
                }
            } else if !TestVariables.DISABLE_ADS {
//                if game.player.shouldShowAd() {
//                    game.showAd()
                    print("Should show ad")
                    showInterstitial = true
//                }
            }
        }
    }
    
}

// Previews
struct RiddleView_Previews: PreviewProvider {
    static var previews: some View {
        RiddleView(mainScreen: .constant("Riddle"))
            .environmentObject(GameViewModel())
    }
}
