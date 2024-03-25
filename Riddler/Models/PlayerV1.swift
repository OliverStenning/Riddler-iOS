import Combine
import Foundation

// MARK: - PlayerV1

struct PlayerV1 {

	// MARK: Lifecycle

	@available(*, deprecated, message: "Creating new PlayerV1 is no longer supported")
	init() {
		riddle = 0
		hints = 3
		completed = false
		startTime = Date()
		endTime = Date()
		incorrectGuesses = 0
		hintsUsed = 0
		riddleStats = [RiddleStats](repeating: .init(), count: 50)
		achievements = [:]
	}

	// MARK: Internal

	var riddle: Int
	var hints: Int
	var completed: Bool
	var startTime: Date
	var endTime: Date
	var incorrectGuesses: Int
	var hintsUsed: Int
	var riddleStats: [RiddleStats]
	var achievements: [String: Bool]

}

// MARK: PlayerDataConvertible

extension PlayerV1: PlayerDataConvertible {
	func upgraded() -> Player {
		Player(playerV1: self)
	}
}
