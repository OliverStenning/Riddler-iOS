import Foundation

struct RiddleStats: Codable {

	// MARK: Lifecycle

	@available(*, deprecated, message: "This initializer is no longer used during player creation")
	init() {
		startTime = Date()
		endTime = Date()
		incorrectGuesses = 0
		hintsUsed = 0
	}

	init(startTime: Date, endTime: Date = Date(), incorrectGuesses: Int, hintsUsed: Int) {
		self.startTime = startTime
		self.endTime = endTime
		self.incorrectGuesses = incorrectGuesses
		self.hintsUsed = hintsUsed
	}

	init?(legacyRiddleStats: RiddleStats) {
		let timeDiff = legacyRiddleStats.endTime.timeIntervalSinceReferenceDate - legacyRiddleStats.startTime.timeIntervalSinceReferenceDate
		guard timeDiff.magnitude > 1 else { return nil }
		startTime = legacyRiddleStats.startTime
		endTime = legacyRiddleStats.endTime
		incorrectGuesses = legacyRiddleStats.incorrectGuesses
		hintsUsed = legacyRiddleStats.hintsUsed
	}

	// MARK: Internal

	let startTime: Date
	let endTime: Date
	let incorrectGuesses: Int
	let hintsUsed: Int

	var timeTaken: Double {
		endTime.timeIntervalSince(startTime)
	}

	var formattedTimeTaken: String {
		TimeFormatter.timeDifference(from: startTime, to: endTime)
	}

	var totalGuesses: Int {
		incorrectGuesses + 1
	}

}
