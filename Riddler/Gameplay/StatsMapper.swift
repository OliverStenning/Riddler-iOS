import Foundation

struct StatsMapper {

	// MARK: Internal

	func mapVictoryStats(for player: Player) -> [DisplayStat] {
		var victoryStats: [DisplayStat?] = []
		victoryStats.append(totalTime(for: player))
		victoryStats.append(quickestTime(for: player))
		victoryStats.append(slowestTime(for: player))
		victoryStats.append(totalGuesses(for: player))
		victoryStats.append(correctFirstGuesses(for: player))
		victoryStats.append(mostIncorrectGuesses(for: player))
		victoryStats.append(hintsUsed(for: player))
		victoryStats.append(correctWithoutHints(for: player))
		return victoryStats.compactMap { $0 }
	}

	// MARK: Private

	private func totalTime(for player: Player) -> DisplayStat? {
		guard let formattedTimeTaken = player.formattedTimeTaken else { return nil }
		return DisplayStat(name: "Total time:", value: formattedTimeTaken)
	}

	private func quickestTime(for player: Player) -> DisplayStat {
		let quickestTime = player.riddleStats.max(by: { $0.timeTaken > $1.timeTaken })?.formattedTimeTaken ?? "0 seconds"
		return DisplayStat(name: "Quickest time:", value: quickestTime)
	}

	private func slowestTime(for player: Player) -> DisplayStat {
		let slowestTime = player.riddleStats.max(by: { $0.timeTaken < $1.timeTaken })?.formattedTimeTaken ?? "0 seconds"
		return DisplayStat(name: "Slowest time:", value: slowestTime)
	}

	private func totalGuesses(for player: Player) -> DisplayStat {
		let totalGuesses = player.totalGuesses
		return DisplayStat(name: "Total guesses:", value: String(totalGuesses))
	}

	private func correctFirstGuesses(for player: Player) -> DisplayStat {
		let correctFirstGuesses = player.riddleStats.filter { $0.incorrectGuesses == 0 }.count
		return DisplayStat(name: "Correct first guesses:", value: String(correctFirstGuesses))
	}

	private func mostIncorrectGuesses(for player: Player) -> DisplayStat {
		let mostIncorrectGuesses = player.riddleStats.map(\.incorrectGuesses).max() ?? 0
		return DisplayStat(name: "Most incorrect guesses:", value: String(mostIncorrectGuesses))
	}

	private func hintsUsed(for player: Player) -> DisplayStat {
		let hintsUsed = player.riddleStats.reduce(0) { $0 + $1.hintsUsed }
		return DisplayStat(name: "Hints used:", value: String(hintsUsed))
	}

	private func correctWithoutHints(for player: Player) -> DisplayStat {
		let correctWithoutHints = player.riddleStats.filter { $0.hintsUsed == 0 }.count
		return DisplayStat(name: "Answered without hints:", value: String(correctWithoutHints))
	}

}
