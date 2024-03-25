import Foundation
import GameKit

// MARK: - GKManager

class GKManager {

	// MARK: Lifecycle

	private init() {}

	// MARK: Internal

	static let shared = GKManager()

	var isAuthenticated: Bool = false

}
