import Foundation

protocol PlayerDataConvertible: Codable {
	func upgraded() -> Player
}
