import SwiftUI

struct MenuView: View {
    
    // ViewModel
    @StateObject var game = GameViewModel()
    
    // UI state
    @State private var mainScreen: String? = nil
    
    // GameKit bindings
    @Binding var showGameCenter: Bool
    @Binding var showLeaderboard: Bool
    @Binding var showAchievements: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                // Navigtaion
                NavigationLink(destination: RiddleView(mainScreen: $mainScreen), tag: "Riddle", selection: $mainScreen) { EmptyView() }
                NavigationLink(destination: SettingsView(mainScreen: $mainScreen), tag: "Settings", selection: $mainScreen) { EmptyView() }
                NavigationLink(destination: EmptyView(), label: {})
                
                // Background
                Background(isDark: true)
                
                // Menu
                VStack {
                    Spacer()
                    Text("Riddler")
                        .modifier(AccentTextStyle(textSize: 100))
                    
                    Spacer()
                    VStack(spacing: 10) {
                        
                        Button(action: pressStart) {
                            Text("Start").frame(width: 227, height: 70)
                        }
                            .buttonStyle(AccentButtonStyle())
                            .modifier(ButtonTextStyle(textSize: 60))

                        HStack {
                            IconButton(image: "trophy", size: 50, action: pressAchievements)
                                .buttonStyle(AccentButtonStyle())
                            
                            IconButton(image: "leaderboard", size: 50, action: pressLeaderboards)
                                .buttonStyle(AccentButtonStyle())
                            
                            IconButton(image: "settings", size: 50, action: pressSettings)
                                .buttonStyle(AccentButtonStyle())
                        }
                    }
                    
                    Spacer()
                    HStack {
                        Spacer()
                        Text("v1.02")
                            .modifier(AccentTextStyle(textSize: 20))
                    }
                }
                .padding(20)
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(game)
    }   
    
    // Button actions
    func pressStart() {
        mainScreen = "Riddle"
    }
    
    func pressSettings() {
        mainScreen = "Settings"
    }
    
    func pressAchievements() {
        // Log event to firebase
        openAchievementsEvent(player: game.player)
        showAchievements = true
    }
    
    func pressLeaderboards() {
        // Log event to firebase
        openLeaderboardEvent(player: game.player)
        showLeaderboard = true
    }
    
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(showGameCenter: .constant(false), showLeaderboard: .constant(false), showAchievements: .constant(false))
    }
}
