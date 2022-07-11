import Foundation

class GameKitManager {
    static let shared = GameKitManager()
    private init() {}
    
    var gameKitEnabled: Bool = false
    var gameKitStarted: Bool = false
    
    
}
