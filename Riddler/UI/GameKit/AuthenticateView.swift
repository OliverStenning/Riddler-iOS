import SwiftUI
import UIKit
import GameKit

struct AuthenticateView: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = UIViewController()
        
        if !GKLocalPlayer.local.isAuthenticated {
            
            GKLocalPlayer.local.authenticateHandler = { vc, error in
                
                if let vc = vc {
                    viewController.present(vc, animated: true)
                }
                if error != nil {
                    print("GC: Error")
                    print(error?.localizedDescription ?? "")
                    GameKitManager.shared.gameKitEnabled = false
                    isPresented = false
                    print("GC: Authenticted = \(GKLocalPlayer.local.isAuthenticated)")
                }
                if vc == nil && error == nil {
                    GameKitManager.shared.gameKitEnabled = true
                    
                    if TestVariables.RESET_ACHIEVEMENTS {
                        print("GC: Achievements Reset")
                        GKAchievement.resetAchievements()
                    }
                    
                    isPresented = false
                    print("GC: Authenticted = \(GKLocalPlayer.local.isAuthenticated)")
                }
                
            }
        } else {
            GameKitManager.shared.gameKitEnabled = true
            isPresented = false
            print("GC: Authenticted = \(GKLocalPlayer.local.isAuthenticated)")
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
}

struct AuthenticateModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        content
        if isPresented {
            AuthenticateView(isPresented: $isPresented)
        }
    }
}

extension View {
    func presentAuthenticate(isPresented: Binding<Bool>) -> some View {
        modifier(AuthenticateModifier(isPresented: isPresented))
    }
}


