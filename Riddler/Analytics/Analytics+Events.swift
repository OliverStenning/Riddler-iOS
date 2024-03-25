import Foundation

extension AnalyticsEvent {

	// MARK: - Menu

	static func tapStart() -> Self {
		.init(name: "Tap start")
	}

	static func tapAchievements() -> Self {
		.init(name: "Tap achievements")
	}

	static func tapLeaderboard() -> Self {
		.init(name: "Tap leaderboard")
	}

	static func tapSettings() -> Self {
		.init(name: "Tap settings")
	}

	// MARK: - Settings

	static func tapPrivacyPolicy() -> Self {
		.init(name: "Tap privacy policy")
	}

	static func tapUpdatePrivacy() -> Self {
		.init(name: "Tap update privacy settings")
	}

	static func tapReportBug() -> Self {
		.init(name: "Tap report bug")
	}

	// MARK: - Riddle

	static func tapOpenHints() -> Self {
		.init(name: "Tap open hints")
	}

	static func tapEnterAnswer() -> Self {
		.init(name: "Tap enter answer")
	}

	static func incorrectGuess(_ guess: String, riddleNumber: Int) -> Self {
		.init(name: "Incorrect guess", properties: ["guess": guess, "riddleNumber": riddleNumber])
	}

	static func correctGuess(_ guess: String, riddleNumber: Int) -> Self {
		.init(name: "Correct guess", properties: ["guess": guess, "riddleNumber": riddleNumber])
	}

	// MARK: - Hint

	static func tapUseHint(numberOfHints: Int) -> Self {
		.init(name: "Tap use hint", properties: ["numberOfHints": numberOfHints])
	}

	static func tapGetMoreHints(numberOfHints: Int) -> Self {
		.init(name: "Tap get more hints", properties: ["numberOfHints": numberOfHints])
	}

	// MARK: - Correct

	static func tapOpenSuggestDialog() -> Self {
		.init(name: "Tap open suggest answer dialog")
	}

	static func tapSuggestAnswer() -> Self {
		.init(name: "Tap suggest answer")
	}

	static func tapCloseSuggestDialog() -> Self {
		.init(name: "Tap close suggest answer dialog")
	}

	static func tapShareCorrect() -> Self {
		.init(name: "Tap share correct")
	}

	// MARK: - Victory

	static func tapShareVictory() -> Self {
		.init(name: "Tap share victory")
	}

	static func tapOpenStats() -> Self {
		.init(name: "Tap open stats")
	}

	// MARK: - Stats

	static func stats(_ stats: [DisplayStat]) -> Self {
		let properties = Dictionary(uniqueKeysWithValues: stats.map { ($0.name, $0.value) })
		return .init(name: "Stats", properties: properties)
	}

	// MARK: - Ads

	static func hintsRewarded() -> Self {
		.init(name: "Hints rewarded")
	}

}
