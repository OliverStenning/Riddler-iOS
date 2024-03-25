import Combine
import Foundation
import GameKit
import OSLog
import SwiftUI

// MARK: - NavigationRoute

enum NavigationRoute {
	case riddle
	case hint
	case victory
	case settings
}

// MARK: - GameplayManager

final class GameplayManager: ObservableObject {

	// MARK: Lifecycle

	init(
		storageManager: StorageManaging = StorageManager(),
		gameCenterManager: GameCenterManager = GameCenterManager(),
		statsMapper: StatsMapper = StatsMapper()
	) {
		self.storageManager = storageManager
		self.gameCenterManager = gameCenterManager
		self.statsMapper = statsMapper
		player = storageManager.loadPlayer()
	}

	// MARK: Internal

	let riddles: [Riddle] = Bundle.main.decode("riddles.json")

	@Published var navigationPath = NavigationPath()
	@Published var player: Player

	@Published var showCorrect = false
	@Published var showVictoryStats = false

	@Published var showAchievementToast = false
	@Published var showNoMoreHintsToast = false
	@Published var showShareCorrectToast = false
	@Published var showShareVictoryToast = false

	@Published var showInterstitialAd = false
	@Published var showRewardedAd = false

	@Published var showWatchAdDialog = false
	@Published var showPrivacySettingsDialog = false
	@Published var showHintsRewardedToast = false

	@Published var showAdPrivacyForm = false
	@Published var showAdPrivacyFormError = false

	@Published var showAppStoreReviewPrompt = false

	@Published var answerString = ""

	var currentRiddle: Riddle? {
		riddles[safeIndex: player.currentRiddleIndex]
	}

	var riddleNumberString: String {
		"\(player.currentRiddleIndex + 1)/\(riddles.count)"
	}

	var hintString: String {
		let hintsToShow = riddles[player.currentRiddleIndex].hints[0 ..< player.currentRiddleHintsUsed]
		guard !hintsToShow.isEmpty else { return "No hints used." }
		return hintsToShow.joined(separator: "\n\n")
	}

	var canRequestMoreHints: Bool {
		AdsManager.shared.hasConsented
	}

	var victoryStats: [DisplayStat] {
		let stats = statsMapper.mapVictoryStats(for: player)
		Analytics.shared.event(.stats(stats))
		return stats
	}

	// MARK: - Menu

	func startTapped() {
		if player.currentRiddleIndex >= riddles.count {
			navigationPath.append(NavigationRoute.victory)
		} else {
			navigationPath.append(NavigationRoute.riddle)
		}
	}

	func handleGameCenterAuthenticated() {
		gameCenterManager.setCurrentAchievements(player.achievements)
		gameCenterManager.updateLeaderboard(newScore: player.currentRiddleIndex + 1)
	}

	// MARK: - Riddle

	func checkAnswer() {
		Analytics.shared.event(.tapEnterAnswer())
		let answer = answerString.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
		let isCorrectAnswer = riddles[player.currentRiddleIndex].answers.contains(answer)
		Logger.gameplay.info("Entered: \(answer), Is correct: \(isCorrectAnswer)")
		isCorrectAnswer ? handleCorrectGuess(answer) : handleIncorrectGuess(answer)
		storageManager.savePlayer(player)
	}

	func correctAppeared() {
		answerString = ""

		player.riddleStats.append(.init(
			startTime: player.currentRiddleStartTime,
			incorrectGuesses: player.currentRiddleIncorrectGuesses,
			hintsUsed: player.currentRiddleHintsUsed
		))

		withAnimation(.easeInOut(duration: 1.0)) {
			player.currentRiddleIndex += 1
			player.currentRiddleStartTime = Date()
			player.currentRiddleIncorrectGuesses = 0
			player.currentRiddleHintsUsed = 0
		}

		gameCenterManager.updateLeaderboard(newScore: player.currentRiddleIndex + 1)
		if let lastRiddleStats = player.riddleStats.last {
			let updatedAchievements = gameCenterManager.handleAchiementUpdates(
				currentAchievements: player.achievements,
				currentRiddleIndex: player.currentRiddleIndex,
				lastRiddleStats: lastRiddleStats
			)
			player.achievements = updatedAchievements
		}

		storageManager.savePlayer(player)
	}

	func correctDismissed() {
		guard player.currentRiddleIndex < riddles.count else { return }

		let showedAppStoreReview = handleShowingAppStoreReviewPrompt()
		guard !showedAppStoreReview else { return }

		handleShowingInterstitialAd()
	}

	// MARK: - Hints

	func openHints() {
		Analytics.shared.event(.tapOpenHints())
		navigationPath.append(NavigationRoute.hint)
	}

	func useHint() {
		Analytics.shared.event(.tapUseHint(numberOfHints: player.hintsAvailable))
		Logger.gameplay.info("Player tried to use hint")
		let riddleHasUnusedHints = player.currentRiddleHintsUsed < riddles[player.currentRiddleIndex].hints.count
		guard riddleHasUnusedHints else {
			withAnimation {
				showNoMoreHintsToast = true
			}
			Logger.gameplay.info("Unable to use hint as riddle has no more hints")
			return
		}

		let playerHasHints = player.hintsAvailable > 0
		if playerHasHints {
			player.currentRiddleHintsUsed += 1
			player.hintsAvailable -= 1
			Logger.gameplay.info("Player used a hint")
		}
	}

	func requestHints() {
		Analytics.shared.event(.tapGetMoreHints(numberOfHints: player.hintsAvailable))
		showRewardedAd = true
	}

	func handleHintReward() {
		Analytics.shared.event(.hintsRewarded())
		player.hintsAvailable += 3
		storageManager.savePlayer(player)
		withAnimation {
			showHintsRewardedToast = true
		}
	}

	// MARK: Victory

	func victoryStatsTapped() {
		Analytics.shared.event(.tapOpenStats())
		showVictoryStats = true
	}

	func shareVictory() {
		Analytics.shared.event(.tapShareVictory())
		UIPasteboard.general.string = player.victoryShareString
		withAnimation {
			showShareVictoryToast = true
		}
	}

	func shareCorrect() {
		UIPasteboard.general.string = player.correctShareString
		withAnimation {
			showShareCorrectToast = true
		}
	}

	func debugResetTapped() {
		player = Player()
		storageManager.savePlayer(player)
	}

	// MARK: - Ads

	func interstitialAdDidFinish() {
		showInterstitialAd = false
		lastAdWatchDate = Date()
	}

	func rewardedAdDidFinish() {
		showRewardedAd = false
	}

	// MARK: - App Store Review

	func promptedForAppStoreReview() {
		showAppStoreReviewPrompt = false
		lastAppStoreReviewPromptDate = Date()
	}

	// MARK: Private

	private let storageManager: StorageManaging
	private let gameCenterManager: GameCenterManager
	private let statsMapper: StatsMapper
	private let userDefaults: UserDefaults = .standard
	private var cancellables = Set<AnyCancellable>()

	private var lastAdWatchDate: Date?

	private let lastAppStoreReviewPromptKey = "LastAppStoreReviewPrompt"

	private var lastAppStoreReviewPromptDate: Date? {
		get {
			let timeInterval = userDefaults.double(forKey: lastAppStoreReviewPromptKey)
			guard timeInterval > 0 else { return nil }
			return Date(timeIntervalSinceReferenceDate: timeInterval)
		}
		set {
			let timeInterval = newValue?.timeIntervalSinceReferenceDate
			guard let timeInterval else { return }
			userDefaults.set(timeInterval, forKey: lastAppStoreReviewPromptKey)
		}
	}

	private func handleCorrectGuess(_ guess: String) {
		Analytics.shared.event(.correctGuess(guess, riddleNumber: player.currentRiddleIndex + 1))
		showCorrect = true
	}

	private func handleIncorrectGuess(_ guess: String) {
		Analytics.shared.event(.incorrectGuess(guess, riddleNumber: player.currentRiddleIndex + 1))
		withAnimation {
			player.currentRiddleIncorrectGuesses += 1
		}
		answerString = ""
		storageManager.savePlayer(player)
	}

	private func handleShowingAppStoreReviewPrompt() -> Bool {
		guard player.currentRiddleIndex > 10 else { return false }

		let lastShownLongEnoughAgo = lastAppStoreReviewPromptDate.map { $0.isBefore(Date(timeIntervalSinceNow: .weeks(-20))) } ?? true
		guard lastShownLongEnoughAgo else { return false }

		showAppStoreReviewPrompt = true
		return true
	}

	@discardableResult
	private func handleShowingInterstitialAd() -> Bool {
		if let lastAdWatchDate, lastAdWatchDate.isAfter(Date(timeIntervalSinceNow: .minutes(-3))) {
			return false
		}
		showInterstitialAd = true
		return true
	}

}
