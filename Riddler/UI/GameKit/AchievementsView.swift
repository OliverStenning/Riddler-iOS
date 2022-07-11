import SwiftUI
import UIKit
import GameKit

final class AchievementsView: NSObject, UIViewControllerRepresentable, GKGameCenterControllerDelegate {
    
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = GKGameCenterViewController(state: .achievements)
        viewController.gameCenterDelegate = self
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        isPresented = false
    }
    
}

struct AchievementModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        content
        if isPresented {
            AchievementsView(isPresented: $isPresented)
        } 
    }
}

extension View {
    func presentAchievements(isPresented: Binding<Bool>) -> some View {
        modifier(AchievementModifier(isPresented: isPresented))
    }
}
