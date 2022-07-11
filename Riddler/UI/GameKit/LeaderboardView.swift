import SwiftUI
import UIKit
import GameKit

final class LeaderboardView: NSObject, UIViewControllerRepresentable, GKGameCenterControllerDelegate {
    
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = GKGameCenterViewController(leaderboardID: "riddle_progress", playerScope: .friendsOnly, timeScope: .allTime)
        viewController.gameCenterDelegate = self
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        isPresented = false
    }
    
}

struct LeaderboardModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        content
        if isPresented {
            LeaderboardView(isPresented: $isPresented)
        }
    }
}

extension View {
    func presentLeaderboard(isPresented: Binding<Bool>) -> some View {
        modifier(LeaderboardModifier(isPresented: isPresented))
    }
}
