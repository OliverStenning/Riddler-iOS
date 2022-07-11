import Foundation
import Firebase
import FirebaseAnalytics
import GameKit

class GameViewModel: ObservableObject {
    
    @Published var player: Player = Player()
    let riddles: [Riddle] = Bundle.main.decode("riddles.json")
    
    init() {
        loadPlayer()
    }
    
    // MARK: - UI computed variables
    var riddleNumString: String {
        "\(player.riddleDisplay)/\(riddles.count)"
    }
    
    func hintString() -> String {
        var hintString: String = ""
        var hintArray: [String] = []
        
        for x in 0..<riddles[player.riddle].hints.count {
            if x < player.riddleStats[player.riddle].hintsUsed {
                hintArray.append(riddles[player.riddle].hints[x])
            }
        }
        
        hintString = hintArray.joined(separator: "\n\n")
        
        if hintString == "" {
            return "No hints used."
        } else {
            return hintString
        }
    }
    
    // MARK: - Gameplay functions
    func checkAnswer(inputAnswer: String) -> (Bool, Bool) {
        let answer = inputAnswer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if answerContained(answer: answer) {
            var newAchievements: Bool = false
            newAchievements = player.correctGuess()
            
            savePlayer()
            
            checkAchievements()
            updateLeaderboard()
            
            // Log event to firebase
            guessEvent(guess: answer, correct: true)
            
            return (true, newAchievements)
        } else {
            player.incorrectGuess()
            savePlayer()
            
            // Log event to firebase
            guessEvent(guess: answer, correct: false)
            
            return (false, false)
        }
    }
    
    func answerContained(answer: String) -> Bool {
        for correctAnswer in riddles[player.riddle].answers {
            if answer == correctAnswer {
                return true
            }
        }
        return false
    }
    
    func useHint() {
        // Change player stats to show hints used
        player.useHint(riddleHints: riddles[player.riddle].hints.count)
        objectWillChange.send()
        savePlayer()
        
        // Log event to firebase
        useHintEvent()
    }
    
    func hintUsable() -> Bool {
        return player.hintUsable(riddleHints: riddles[player.riddle].hints.count)
    }
    
    func hintReward() {
        // Increase player hints
        player.addHints()
        objectWillChange.send()
        savePlayer()
        
        // Log event to firebase
        unlockHintsEvent()
    }
    
    func setRatingAsk() {
        player.ratingAsked = true
        savePlayer()
    }
    
    func updateRiddleStart() {
        player.updateRiddleStart()
        objectWillChange.send()
        savePlayer()
    }
    
//    func showAd() {
//        player.timeOfLastAd = Date()
//        objectWillChange.send()
//        savePlayer()
//    }
    
    // MARK: - Achievements
    func checkAchievements() {
        if GameKitManager.shared.gameKitEnabled {
            GKAchievement.loadAchievements(completionHandler: { (achievements: [GKAchievement]?, error: Error? ) in

                var achievementsToReport: [GKAchievement] = []
                
                for (key, value) in self.player.achievements {
                    if value == true {
                        let achievementID = key
                        var achievement: GKAchievement? = nil

                        // Check if achievement with that ID already exists
                        achievement = achievements?.first(where: { $0.identifier == achievementID })
                        
                        // If it doesn't add it to list of achievements to report
                        if achievement == nil {
                            let completedAchievement = GKAchievement(identifier: key)
                            completedAchievement.percentComplete = 100
                            achievementsToReport.append(completedAchievement)
                            print("GC Achievement Added: \(key) -> \(value)")
                        }
                    }
                }

                if achievementsToReport.count > 0 {
                    GKAchievement.report(achievementsToReport, withCompletionHandler: {(error: Error?) in
                        if error != nil {
                            print("GC Error: \(String(describing: error))")
                        }
                    })
                }
                
            })
        }
    }
    
    // MARK: - Leaderboard
    func updateLeaderboard() {
        if GameKitManager.shared.gameKitEnabled {
            var score: Int = player.riddle
            
            if player.completed {
                score = 50
            }
            
            GKLeaderboard.submitScore(score, context: -1, player: GKLocalPlayer.local, leaderboardIDs: ["riddle_progress"], completionHandler: { (error: Error?) in
                if error != nil {
                    print("GC Error: \(String(describing: error?.localizedDescription))")
                } else {
                    print("GC Score Updated")
                }
            })
        }
    }
    
    // MARK: - Player data handling
    func savePlayer() {
        if let encoded = try? JSONEncoder().encode(player) {
            UserDefaults.standard.set(encoded, forKey: "Player")
        }
    }
    
    func loadPlayer() {
        if TestVariables.RESET_DATA {
            player = Player()
        } else {
            if let loaded = UserDefaults.standard.data(forKey: "Player") {
                if let decoded = try? JSONDecoder().decode(Player.self, from: loaded) {
                    player = decoded
                }
            }
        }
    }
    
    // MARK: - Analytics logging
    func guessEvent(guess: String, correct: Bool) {
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
    
    func openHintsEvent() {
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
    
    func useHintEvent() {
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
    
    func unlockHintsEvent() {
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
    
    func copyResultsEvent() {
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
    
    func victoryEvent() {
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
    
    func openLeaderboardEvent() {
        // Only log events if tracking consented
        if ConsentManager.shared.userConsentType == ConsentManager.ConsentType.full {
            Analytics.logEvent("open_leaderboard", parameters: [
                "riddle_num" : player.riddle,
                "time_played_text" : player.timeString,
                "time_played" : player.time
            ])
        }
    }
    
    func openAchievementsEvent() {
        // Only log events if tracking consented
        if ConsentManager.shared.userConsentType == ConsentManager.ConsentType.full {
            Analytics.logEvent("open_achievements", parameters: [
                "riddle_num" : player.riddle,
                "time_played_text" : player.timeString,
                "time_played" : player.time
            ])
        }
    }
    
}
