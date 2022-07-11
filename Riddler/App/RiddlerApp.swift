import SwiftUI
import Firebase
import GameKit

@main
struct RiddlerApp: App {
    
    @State var showGameCenter: Bool = false
    @State var showAchievements: Bool = false
    @State var showLeaderboard: Bool = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                MenuView(showGameCenter: $showGameCenter,
                         showLeaderboard: $showLeaderboard,
                         showAchievements: $showAchievements)
                
                .presentAuthenticate(isPresented: $showGameCenter)
                .presentAchievements(isPresented: $showAchievements)
                .presentLeaderboard(isPresented: $showLeaderboard)
            }
            .onAppear(perform: appStart)
            .preferredColorScheme(.dark)
        }
    }
    
    func appStart() {
        if !ConsentManager.shared.ConsentConfigured {
            if !TestVariables.DISABLE_CONSENT_FORM {
                ConsentManager.shared.startupConsent(completion: startGameCenter)
            }
        }
    }
    
    func startGameCenter() {
        if !TestVariables.DISABLE_GAMECENTER && GameKitManager.shared.gameKitStarted == false {
            print("Start: Game Center")
            GameKitManager.shared.gameKitStarted = true
            showGameCenter = true
        }
    }
    
}
