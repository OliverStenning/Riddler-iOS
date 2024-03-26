import Foundation

typealias Player = PlayerV2

// MARK: - PlayerV2

struct PlayerV2: Codable {

	// MARK: Lifecycle

	init() {
		currentRiddleIndex = 0
		currentRiddleStartTime = Date()
		currentRiddleHintsUsed = 0
		currentRiddleIncorrectGuesses = 0
		hintsAvailable = 3
		riddleStats = [RiddleStats]()
		achievements = [String: Double]()
	}

	init(playerV1: PlayerV1) {
		currentRiddleIndex = playerV1.riddle
		hintsAvailable = playerV1.hints

		var editedRiddleStats = playerV1.riddleStats.map { RiddleStats(legacyRiddleStats: $0) }.compactMap { $0 }
		if let lastRiddleStat = editedRiddleStats.popLast() {
			currentRiddleStartTime = lastRiddleStat.startTime
			currentRiddleHintsUsed = lastRiddleStat.hintsUsed
			currentRiddleIncorrectGuesses = lastRiddleStat.incorrectGuesses
		} else {
			currentRiddleStartTime = Date()
			currentRiddleHintsUsed = 0
			currentRiddleIncorrectGuesses = 0
		}

		riddleStats = editedRiddleStats
		achievements = playerV1.achievements.mapValues { isAchieved in
			isAchieved ? 100.0 : 0.0
		}
		
		let brokenAchievementKey = "riddles_first"
		let correctAchievementKey = "riddle_first"
		
		achievements[correctAchievementKey] = achievements[brokenAchievementKey]
		achievements.removeValue(forKey: brokenAchievementKey)
	}

	// MARK: Internal

	var currentRiddleIndex: Int
	var currentRiddleStartTime: Date
	var currentRiddleHintsUsed: Int
	var currentRiddleIncorrectGuesses: Int
	var hintsAvailable: Int
	var riddleStats: [RiddleStats]
	var achievements: [String: Double]

	var totalGuesses: Int {
		riddleStats.reduce(0) { $0 + $1.totalGuesses }
	}

	var formattedTimeTaken: String? {
		guard let startTime = riddleStats.first?.startTime, let endTime = riddleStats.last?.endTime else { return nil }
		return TimeFormatter.timeDifference(from: startTime, to: endTime)
	}

	var victoryShareString: String {
		var shareString = "Riddler - Defeated\n"
		if let formattedTimeTaken {
			shareString += "\(formattedTimeTaken)\n"
		}
		shareString += "\(totalGuesses) guesses\n"
		shareString += "rddle.me/this"
		return shareString
	}

	var correctShareString: String {
		var shareString = "Riddler #\(currentRiddleIndex)\n"
		if let lastRiddleStats = riddleStats.last {
			shareString += "\(lastRiddleStats.formattedTimeTaken)\n"
			shareString += "\(lastRiddleStats.totalGuesses) guess\(lastRiddleStats.totalGuesses == 1 ? "" : "es")\n" // TODO: Localise
		}
		shareString += "rddle.me/this"
		return shareString
	}

}

// MARK: PlayerDataConvertible

extension PlayerV2: PlayerDataConvertible {
	func upgraded() -> Player {
		self
	}
}
