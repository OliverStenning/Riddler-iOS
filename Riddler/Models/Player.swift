import Foundation

class Player: Codable, ObservableObject {
    
    // MARK: - Variables
    @Published var riddle: Int
    @Published var hints: Int
    @Published var completed: Bool
    var ratingAsked: Bool
    
    var startTime: Date
    var endTime: Date
    var incorrectGuesses: Int
    @Published var hintsUsed: Int
    @Published var riddleStats: [Stats]
//    var timeOfLastAd: Date
    
    var achievements: [String: Bool]
    
    // MARK: - computed variables
    var riddleDisplay: Int {
        if completed {
            return 51
        } else {
            return riddle + 1
        }
    }
    
    var guesses: Int {
        if completed {
            return incorrectGuesses + 50
        } else {
            return incorrectGuesses + riddle
        }
    }
    
    var time: Int {
        timeDifference(startTime: startTime, endTime: endTime)
    }
    var timeString: String {
        timeDifferenceString(startTime: startTime, endTime: endTime)
    }
    
    var timeSoFar: Int {
        timeDifference(startTime: startTime, endTime: Date())
    }
    
    var timeSoFarString: String {
        timeDifferenceString(startTime: startTime, endTime: Date())
    }
    
    var currentRiddleStats: Stats {
        riddleStats[riddle]
    }
    
    var previousRiddleStats: Stats {
        riddleStats[riddle - 1]
    }
    
    init() {
        self.riddle = TestVariables.START_RIDDLE
        self.hints = ConfigVariables.HINT_START_AMOUNT
        self.completed = TestVariables.COMPLETED
        self.ratingAsked = false
        self.startTime = Date()
        self.endTime = Date()
        self.incorrectGuesses = 0
        self.hintsUsed = 0
        self.riddleStats = [Stats]()
//        self.timeOfLastAd = Date()
        self.achievements = [:]
        
        for _ in 1...50 {
            riddleStats.append(Stats())
        }
    }
    
    // MARK: - encoding
    enum CodingKeys: CodingKey {
        case riddle, hints, completed, ratingAsked, startTime, endTime, incorrectGuesses, hintsUsed, riddleStats, timeOfLastAd, achievements
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        riddle = try container.decode(Int.self, forKey: .riddle)
        hints = try container.decode(Int.self, forKey: .hints)
        completed = try container.decode(Bool.self, forKey: .completed)
        ratingAsked = try container.decode(Bool.self, forKey: .ratingAsked)
        startTime = try container.decode(Date.self, forKey: .startTime)
        endTime = try container.decode(Date.self, forKey: .endTime)
        incorrectGuesses = try container.decode(Int.self, forKey: .incorrectGuesses)
        hintsUsed = try container.decode(Int.self, forKey: .hintsUsed)
        riddleStats = try container.decode([Stats].self, forKey: .riddleStats)
//        timeOfLastAd = try container.decode(Date.self, forKey: .timeOfLastAd)
        achievements = try container.decode([String: Bool].self, forKey: .achievements)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(riddle, forKey: .riddle)
        try container.encode(hints, forKey: .hints)
        try container.encode(completed, forKey: .completed)
        try container.encode(ratingAsked, forKey: .ratingAsked)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(incorrectGuesses, forKey: .incorrectGuesses)
        try container.encode(hintsUsed, forKey: .hintsUsed)
        try container.encode(riddleStats, forKey: .riddleStats)
//        try container.encode(timeOfLastAd, forKey: .timeOfLastAd)
        try container.encode(achievements, forKey: .achievements)
    }
    
    // MARK: - Gameplay functions
    func start() {
        startTime = Date()
    }
    
    func correctGuess() -> Bool {
        // Check if that was last riddle
        if riddle == 49 {
            if !completed {
                endTime = Date()
                riddleStats[riddle].endTime = Date()
                completed = true
                return updateAchievements()
            }
        } else {
            riddleStats[riddle].endTime = Date()
            riddle += 1
            riddleStats[riddle].startTime = Date()
            return updateAchievements()
        }
        return false
    }
    
    func incorrectGuess() {
        incorrectGuesses += 1
        riddleStats[riddle].incorrectGuesses += 1
    }
    
    func useHint(riddleHints: Int) {
        if hints > 0 && riddleStats[riddle].hintsUsed < riddleHints {
            hintsUsed += 1
            riddleStats[riddle].hintsUsed += 1
            hints -= 1
        }
    }
    
    func hintUsable(riddleHints: Int) -> Bool {
        return (riddleStats[riddle].hintsUsed < riddleHints)
    }
    
    func addHints() {
        hints += ConfigVariables.HINT_UNLOCK_AMOUNT
    }
    
    func askRating() -> Bool {
        if !ratingAsked && riddle > 5 {
            return true
        }
        return false
    }
    
    func updateRiddleStart() {
        riddleStats[riddle].startTime = Date()
    }
    
    private struct AchievementKeys {
        static let riddles50: String = "riddles_50"
        static let riddles40: String = "riddles_40"
        static let riddles30: String = "riddles_30"
        static let riddles20: String = "riddles_20"
        static let riddles10: String = "riddles_10"
        static let riddles5: String = "riddles_5"
        static let riddlesFirst: String = "riddles_first"
        static let under5Minutes: String = "under_5_minutes"
        static let noHelp: String = "no_help"
        static let firstTry: String = "first_try"
    }
    
    private func updateAchievements() -> Bool {
        
        var newAchievement: Bool = false
        
        // 50 riddles
        if completed && achievements[AchievementKeys.riddles50] == nil {
            achievements.updateValue(true, forKey: AchievementKeys.riddles50)
            newAchievement = true
        }
        
        // 40 riddles
        if riddle >= 40 && achievements[AchievementKeys.riddles40] == nil {
            achievements.updateValue(true, forKey: AchievementKeys.riddles40)
            newAchievement = true
        }
        
        // 30 riddles
        if riddle >= 30 && achievements[AchievementKeys.riddles30] == nil {
            achievements.updateValue(true, forKey: AchievementKeys.riddles30)
            newAchievement = true
        }
        
        // 20 riddles
        if riddle >= 20 && achievements[AchievementKeys.riddles20] == nil {
            achievements.updateValue(true, forKey: AchievementKeys.riddles20)
            newAchievement = true
        }
        
        // 10 riddles
        if riddle >= 10 && achievements[AchievementKeys.riddles10] == nil {
            achievements.updateValue(true, forKey: AchievementKeys.riddles10)
            newAchievement = true
        }
        
        // 5 riddles
        if riddle >= 5 && achievements[AchievementKeys.riddles5] == nil {
            achievements.updateValue(true, forKey: AchievementKeys.riddles5)
            newAchievement = true
        }
        
        // First riddle
        if riddle >= 1 && achievements[AchievementKeys.riddlesFirst] == nil {
            achievements.updateValue(true, forKey: AchievementKeys.riddlesFirst)
            newAchievement = true
        }
        
        // Under 5 minutes
        if riddleStats[riddle - 1].time < 300 && achievements[AchievementKeys.under5Minutes] == nil {
            achievements.updateValue(true, forKey: AchievementKeys.under5Minutes)
            newAchievement = true
        }
        
        // No hints used
        if riddleStats[riddle - 1].hintsUsed == 0 && achievements[AchievementKeys.noHelp] == nil {
            achievements.updateValue(true, forKey: AchievementKeys.noHelp)
            newAchievement = true
        }
        
        // First try
        if riddleStats[riddle - 1].incorrectGuesses == 0 && achievements[AchievementKeys.firstTry] == nil {
            achievements.updateValue(true, forKey: AchievementKeys.firstTry)
            newAchievement = true
        }
        
        return newAchievement
        
    }
    
//    func shouldShowAd() -> Bool {
//        // Show ad if longer than 3 mins since last ad
//        return timeDifference(startTime: timeOfLastAd, endTime: Date()) > ConfigVariables.TIME_BETWEEN_ADS
//    }
    
    // MARK: - Stats functions
    func victoryStats() -> [String] {
        var victoryStats: [String] = []
        
        victoryStats.append(timeString)
        victoryStats.append(quickestTime())
        victoryStats.append(slowestTime())
        victoryStats.append(String(guesses))
        victoryStats.append(String(correctFirstGuesses()))
        victoryStats.append(String(mostIncorrectGuesses()))
        victoryStats.append(String(hintsUsed))
        victoryStats.append(String(riddlesWithoutHints()))
        
        return victoryStats
    }
    
    func quickestTime() -> String {
        var quickestTime: Int = riddleStats[0].time
        var quickestRiddle: Int = 0
        
        for x in 1..<riddleStats.count {
            let time = riddleStats[x].time
            if time < quickestTime {
                quickestTime = time
                quickestRiddle = x
            }
        }
        return riddleStats[quickestRiddle].timeString
    }
    
    func slowestTime() -> String {
        var slowestTime: Int = riddleStats[0].time
        var slowestRiddle: Int = 0
        
        for x in 1..<riddleStats.count {
            let time = riddleStats[x].time
            
            if time > slowestTime {
                slowestTime = time
                slowestRiddle = x
            }
        }
        return riddleStats[slowestRiddle].timeString
    }

    func correctFirstGuesses() -> Int {
        var correctFirsts: Int = 0
        
        for x in 0..<riddleStats.count {
            if riddleStats[x].incorrectGuesses == 0 {
                correctFirsts += 1
            }
        }
        return correctFirsts
    }
    
    func mostIncorrectGuesses() -> Int {
        var mostIncorrect: Int = riddleStats[0].incorrectGuesses

        for x in 1..<riddleStats.count {
            if riddleStats[x].incorrectGuesses > mostIncorrect {
                mostIncorrect = riddleStats[x].incorrectGuesses
            }
        }
        return mostIncorrect
    }
    
    func riddlesWithoutHints() -> Int {
        var noHints: Int = 0
        
        for x in 0..<riddleStats.count {
            if riddleStats[x].hintsUsed == 0 {
                noHints += 1
            }
        }
        return noHints
    }
    
    // MARK: - Share functions
    func riddleResults() -> String {
        return """
            Riddler #\(riddleDisplay - 1)
            \(riddleStats[riddle - 1].timeString)
            \(riddleStats[riddle - 1].guessesString)
            rddle.me/this
            """
    }
    
    func playerResults() -> String {
        return """
            Riddler - Defeated
            \(timeString)
            \(guesses) guesses
            rddle.me/this
            """
    }
    
}
