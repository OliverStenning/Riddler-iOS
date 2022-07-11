import Foundation

struct Stats: Codable {
    var startTime: Date
    var endTime: Date
    
    var incorrectGuesses: Int
    var hintsUsed: Int

    init() {
        self.startTime = Date()
        self.endTime = Date()
        self.incorrectGuesses = 0
        self.hintsUsed = 0
    }
    
    var time: Int {
        timeDifference(startTime: startTime, endTime: endTime)
    }
    
    var timeString: String {
        timeDifferenceString(startTime: startTime, endTime: endTime)
    }
    
    var guesses: Int {
        incorrectGuesses + 1
    }
    
    var guessesString: String {
        if incorrectGuesses == 0 {
            return "1 guess"
        } else {
            return "\(incorrectGuesses + 1) guesses"
        }
    }
    
}
