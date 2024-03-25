import Foundation

struct Riddle: Codable, Identifiable {
	let id: Int
	let question: String
	let answers: [String]
	let hints: [String]
}
