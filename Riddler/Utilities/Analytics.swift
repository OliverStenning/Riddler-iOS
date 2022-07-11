//
//  Analytics.swift
//  Riddler
//
//  Created by Oliver Stenning on 13/07/2022.
//

import Foundation
import FirebaseAnalytics

//MARK: - Game Events
func guessEvent(guess: String, correct: Bool, player: Player) {
    // Only log events if tracking consented
    if ConsentManager.shared.userConsentType == ConsentManager.ConsentType.full {
        Analytics.logEvent("guess", parameters: [
            "guess" : guess,
            "correct" : correct,
            "riddle_num" : player.riddle + 1,
            "incorrect_guesses" : player.riddleStats[player.riddle].incorrectGuesses,
            "hints_used" : player.riddleStats[player.riddle].hintsUsed,
            "time_taken_text" : player.riddleStats[player.riddle].timeString,
            "time_taken" : player.riddleStats[player.riddle].time
        ])
    }
}

func openHintsEvent(player: Player) {
    // Only log events if tracking consented
    if ConsentManager.shared.userConsentType == ConsentManager.ConsentType.full {
        Analytics.logEvent("open_hints", parameters: [
            "hints_used" : player.riddleStats[player.riddle].hintsUsed,
            "total_hints_used" : player.hintsUsed,
            "hints_remaining" : player.hints,
            "riddle_num" : player.riddle,
            "incorrect_guesses" : player.riddleStats[player.riddle].incorrectGuesses,
            "time_taken_text" : player.riddleStats[player.riddle].timeString,
            "time_taken" : player.riddleStats[player.riddle].time
        ])
    }
}

func useHintEvent(player: Player) {
    // Only log events if tracking consented
    if ConsentManager.shared.userConsentType == ConsentManager.ConsentType.full {
        Analytics.logEvent("use_hint", parameters: [
            "hints_used" : player.riddleStats[player.riddle].hintsUsed,
            "total_hints_used" : player.hintsUsed,
            "hints_remaining" : player.hints,
            "riddle_num" : player.riddle,
            "incorrect_guesses" : player.riddleStats[player.riddle].incorrectGuesses,
            "time_taken_text" : player.riddleStats[player.riddle].timeString,
            "time_taken" : player.riddleStats[player.riddle].time
        ])
    }
}

func unlockHintsEvent(player: Player) {
    // Only log events if tracking consented
    if ConsentManager.shared.userConsentType == ConsentManager.ConsentType.full {
        Analytics.logEvent("unlock_hint", parameters: [
            "hints_used" : player.riddleStats[player.riddle].hintsUsed,
            "total_hints_used" : player.hintsUsed,
            "hints_remaining" : player.hints,
            "riddle_num" : player.riddle,
            "incorrect_guesses" : player.riddleStats[player.riddle].incorrectGuesses,
            "time_taken_text" : player.riddleStats[player.riddle].timeString,
            "time_taken" : player.riddleStats[player.riddle].time
        ])
    }
}

func copyResultsEvent(player: Player) {
    // Only log events if tracking consented
    if ConsentManager.shared.userConsentType == ConsentManager.ConsentType.full {
        Analytics.logEvent("copy_results", parameters: [
            "riddle_num" : player.riddle,
            "guesses" : player.riddleStats[player.riddle - 1].guesses,
            "hints_used" : player.riddleStats[player.riddle - 1].hintsUsed,
            "time_taken_text" : player.riddleStats[player.riddle - 1].timeString,
            "time_taken" : player.riddleStats[player.riddle - 1].time
        ])
    }
}

func victoryEvent(player: Player) {
    // Only log events if tracking consented
    if ConsentManager.shared.userConsentType == ConsentManager.ConsentType.full {
        Analytics.logEvent("victory", parameters: [
            "total_hints_used" : player.hintsUsed,
            "total_guesses" : player.guesses,
            "time_played_text" : player.timeString,
            "time_played" : player.time
        ])
    }
}

func openLeaderboardEvent(player: Player) {
    // Only log events if tracking consented
    if ConsentManager.shared.userConsentType == ConsentManager.ConsentType.full {
        Analytics.logEvent("open_leaderboard", parameters: [
            "riddle_num" : player.riddle,
            "time_played_text" : player.timeString,
            "time_played" : player.time
        ])
    }
}

func openAchievementsEvent(player: Player) {
    // Only log events if tracking consented
    if ConsentManager.shared.userConsentType == ConsentManager.ConsentType.full {
        Analytics.logEvent("open_achievements", parameters: [
            "riddle_num" : player.riddle,
            "time_played_text" : player.timeString,
            "time_played" : player.time
        ])
    }
}

//MARK: - Interstitial Ad
func interstitialLoadedEvent() {
    // Only log events if tracking consented
    if ConsentManager.shared.userConsentType == ConsentManager.ConsentType.full {
        Analytics.logEvent("interstitial_loaded", parameters: [:])
    }
}

func interstitialShownEvent() {
    // Only log events if tracking consented
    if ConsentManager.shared.userConsentType == ConsentManager.ConsentType.full {
        Analytics.logEvent("interstitial_shown", parameters: [:])
    }
}

func interstitialNotReadyEvent() {
    // Only log events if tracking consented
    if ConsentManager.shared.userConsentType == ConsentManager.ConsentType.full {
        Analytics.logEvent("interstitial_not_ready", parameters: [:])
    }
}

func interstitialFailedToLoad(error: Error) {
    // Only log events if tracking consented
    if ConsentManager.shared.userConsentType == ConsentManager.ConsentType.full {
        Analytics.logEvent("interstitial_failed_to_load", parameters: [
            "error_code" : error._code,
            "description" : error.localizedDescription
        ])
    }
}

func interstitialFailedToShow(error: Error) {
    // Only log events if tracking consented
    if ConsentManager.shared.userConsentType == ConsentManager.ConsentType.full {
        Analytics.logEvent("interstitial_failed_to_show", parameters: [
            "error_code" : error._code,
            "description" : error.localizedDescription
        ])
    }
}

//MARK: - Rewarded Ad
func rewardedLoadedEvent() {
    // Only log events if tracking consented
    if ConsentManager.shared.userConsentType == ConsentManager.ConsentType.full {
        Analytics.logEvent("rewarded_loaded", parameters: [:])
    }
}

func rewardedShownEvent() {
    // Only log events if tracking consented
    if ConsentManager.shared.userConsentType == ConsentManager.ConsentType.full {
        Analytics.logEvent("rewarded_shown", parameters: [:])
    }
}

func rewardedNotReadyEvent() {
    // Only log events if tracking consented
    if ConsentManager.shared.userConsentType == ConsentManager.ConsentType.full {
        Analytics.logEvent("rewarded_not_ready", parameters: [:])
    }
}

func rewardedFailedToLoad(error: Error) {
    // Only log events if tracking consented
    if ConsentManager.shared.userConsentType == ConsentManager.ConsentType.full {
        Analytics.logEvent("rewarded_failed_to_load", parameters: [
            "error_code" : error._code,
            "description" : error.localizedDescription
        ])
    }
}

func rewardedFailedToShow(error: Error) {
    // Only log events if tracking consented
    if ConsentManager.shared.userConsentType == ConsentManager.ConsentType.full {
        Analytics.logEvent("rewarded_failed_to_show", parameters: [
            "error_code" : error._code,
            "description" : error.localizedDescription
        ])
    }
}
