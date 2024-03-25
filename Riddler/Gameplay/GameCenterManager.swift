import Foundation
import GameKit
import OSLog

struct GameCenterManager {

	// MARK: Internal

	func updateLeaderboard(newScore: Int) {
		guard GKManager.shared.isAuthenticated else { return }
		GKLeaderboard.submitScore(newScore, context: -1, player: GKLocalPlayer.local, leaderboardIDs: ["riddle_progress"]) { error in
			if let error {
				Logger.gameCenter.error("Failed to submit score with error: \(error)")
				return
			}
			Logger.gameCenter.info("Submitted new score of \(newScore) to Leaderboard")
		}
	}

	func handleAchiementUpdates(currentAchievements: [String: Double], currentRiddleIndex: Int, lastRiddleStats: RiddleStats) -> [String: Double] {
		var updatedAchievements = [String: Double]()

		let totalRiddlesForAchievement: [AchievementKey: Int] = [
			.riddles50: 50,
			.riddles40: 40,
			.riddles30: 30,
			.riddles20: 20,
			.riddles10: 10,
			.riddles5: 5,
			.riddlesFirst: 1
		]

		// Update riddle-related achievements based on progress
		for (achievement, totalRiddlesRequired) in totalRiddlesForAchievement {
			let progress = (Double(currentRiddleIndex) / Double(totalRiddlesRequired)) * 100.0
			updatedAchievements[achievement.rawValue] = min(progress, 100.0)
		}

		// For achievements based on no help or incorrect guesses, set to 100 if criteria met, else 0
		updatedAchievements[AchievementKey.under5Minutes.rawValue] = lastRiddleStats.timeTaken < 300 ? 100.0 : 0.0
		updatedAchievements[AchievementKey.noHelp.rawValue] = lastRiddleStats.hintsUsed == 0 ? 100.0 : 0.0
		updatedAchievements[AchievementKey.noHelp.rawValue] = lastRiddleStats.incorrectGuesses == 0 ? 100.0 : 0.0

		handleNewAchievements(currentAchievements: currentAchievements, updatedAchievements: updatedAchievements)
		reportAchievements(updatedAchievements)
		return updatedAchievements
	}

	func setCurrentAchievements(_ currentAchievements: [String: Double]) {
		reportAchievements(currentAchievements)
	}

	// MARK: Private

	private enum AchievementKey: String {
		case riddles50 = "riddles_50"
		case riddles40 = "riddles_40"
		case riddles30 = "riddles_30"
		case riddles20 = "riddles_20"
		case riddles10 = "riddles_10"
		case riddles5 = "riddles_5"
		case riddlesFirst = "riddles_first"
		case under5Minutes = "under_5_minutes"
		case noHelp = "no_help"
		case firstTry = "first_try"
	}

	private func handleNewAchievements(currentAchievements: [String: Double], updatedAchievements: [String: Double]) {
		var newlyCompletedAchievements: [String] = []
		for (achievementId, newProgress) in updatedAchievements {
			let oldProgress = currentAchievements[achievementId] ?? 0.0
			if newProgress == 100.0, oldProgress < 100.0 {
				newlyCompletedAchievements.append(achievementId)
			}
		}

		guard !newlyCompletedAchievements.isEmpty else { return }
		Logger.gameplay.info("New achievements unlocked: \(newlyCompletedAchievements)")
	}

	private func reportAchievements(_ storedAchievements: [String: Double]) {
		guard GKManager.shared.isAuthenticated else { return }
		GKAchievement.loadAchievements { remoteAchievements, error in
			if let error {
				Logger.gameCenter.error("Failed to fetch remote achievements with error: \(error)")
				return
			}

			guard let remoteAchievements else { return }
			let remoteAchievementsDict = Dictionary(uniqueKeysWithValues: remoteAchievements.map { ($0.identifier, $0.percentComplete) })

			let achievementsToReport = storedAchievements.compactMap { achievementId, percentComplete -> GKAchievement? in
				guard percentComplete != 0 else { return nil }

				// Only create a GKAchievement object if the local and remote achievements don't match
				if let remotePercentComplete = remoteAchievementsDict[achievementId], remotePercentComplete == percentComplete {
					return nil // This achievement matches the remote one; no need to report it
				}

				let achievementToUpdate = GKAchievement(identifier: achievementId)
				achievementToUpdate.percentComplete = percentComplete
				Logger.gameCenter.info("Reporting \(achievementId) with \(percentComplete)% completion")
				return achievementToUpdate
			}

			guard !achievementsToReport.isEmpty else { return }
			GKAchievement.report(achievementsToReport) { error in
				if let error {
					Logger.gameCenter.error("Failed to report achievements with error: \(error)")
				} else {
					Logger.gameCenter.info("Successfully reported achievements.")
				}
			}
		}
	}

}
