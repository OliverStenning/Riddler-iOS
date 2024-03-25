import Foundation

extension Bundle {
	func decode<Type: Codable>(_ file: String) -> [Type] {
		guard let url = url(forResource: file, withExtension: nil) else {
			fatalError("Failed to locate \(file) in bundle.")
		}

		guard let data = try? Data(contentsOf: url) else {
			fatalError("Failed to load \(file) from bundle.")
		}

		let decoder = JSONDecoder()

		guard let loaded = try? decoder.decode([Type].self, from: data) else {
			fatalError("Failed to decode \(file) from bundle.")
		}
		return loaded
	}
}
