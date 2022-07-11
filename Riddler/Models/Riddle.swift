import Foundation

struct Riddle: Codable, Identifiable {
    var id: Int
    var question: String
    var answers: [String]
    var hints: [String]
    
    init() {
        self.id = 0
        self.question = "Question"
        self.answers = ["Answer"]
        self.hints = ["Hint"]
    }
    
}
