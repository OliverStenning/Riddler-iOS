import Foundation
import OSLog

// MARK: - StorageManaging

protocol StorageManaging {
	func savePlayer(_ player: Player)
	func loadPlayer() -> Player
}

// MARK: - PreviewStorageManager

struct PreviewStorageManager: StorageManaging {
	func savePlayer(_ player: Player) {}
	func loadPlayer() -> Player {
		Player()
	}
}

// MARK: - StorageManager

struct StorageManager: StorageManaging {

	// MARK: Internal

	func savePlayer(_ player: Player) {
		Logger.dataStorage.info("Attempting to save player data")
		guard let encoded = try? JSONEncoder().encode(player) else {
			Logger.dataStorage.error("Failed to encode player data")
			return
		}

		let playerVersion = PlayerVersion.latest
		UserDefaults.standard.set(playerVersion.rawValue, forKey: playerVersionKey)
		UserDefaults.standard.set(encoded, forKey: playerVersion.storageKey)
	}

	func loadPlayer() -> Player {
		Logger.dataStorage.info("Attempting to load player data")
		let playerVersion = getPlayerVersion()
		guard let data = readPlayerData(for: playerVersion), let playerData = decodePlayerData(playerVersion.decodableType, from: data) else {
			Logger.dataStorage.info("Creating a new player")
			return Player()
		}
		return playerData.upgraded()
	}

	// MARK: Private

	private enum PlayerVersion: String {
		case v1
		case v2

		// MARK: Lifecycle

		init(rawValue: String?) {
			switch rawValue {
			case "v2": self = .v2
			default: self = .v1
			}
		}

		// MARK: Internal

		static var latest: Self {
			.v2
		}

		var storageKey: String {
			switch self {
			case .v1: "Player"
			case .v2: "PlayerV2"
			}
		}

		var decodableType: PlayerDataConvertible.Type {
			switch self {
			case .v1: return PlayerV1.self
			case .v2: return PlayerV2.self
			}
		}

	}

	private let playerVersionKey: String = "PlayerVersion"

	private func getPlayerVersion() -> PlayerVersion {
		let playerVersion = PlayerVersion(rawValue: UserDefaults.standard.string(forKey: playerVersionKey))
		Logger.dataStorage.info("Current player version: \(playerVersion.rawValue)")
		return playerVersion
	}

	private func readPlayerData(for playerVersion: PlayerVersion) -> Data? {
		guard let data = UserDefaults.standard.data(forKey: playerVersion.storageKey) else {
			Logger.dataStorage.info("No player data in UserDefaults for \(playerVersion.rawValue)")
			return nil
		}
		return data
	}

	private func decodePlayerData<T>(_ type: T.Type, from data: Data) -> T? where T: Decodable {
		guard let decodedData = try? JSONDecoder().decode(type, from: data) else {
			Logger.dataStorage.error("Failed to decode player data for \(type).")
			return nil
		}
		return decodedData
	}

}
