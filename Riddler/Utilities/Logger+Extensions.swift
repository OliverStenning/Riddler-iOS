import Foundation
import OSLog

extension Logger {

	private static var subsystem = Bundle.main.bundleIdentifier!

	static let gameplay = Logger(subsystem: subsystem, category: "gameplay")
	static let dataStorage = Logger(subsystem: subsystem, category: "dataStorage")
	static let gameCenter = Logger(subsystem: subsystem, category: "gameCenter")
	static let consent = Logger(subsystem: subsystem, category: "consent")
	static let ads = Logger(subsystem: subsystem, category: "ads")
	static let analytics = Logger(subsystem: subsystem, category: "analytics")

}
