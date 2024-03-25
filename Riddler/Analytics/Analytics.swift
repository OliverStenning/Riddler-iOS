import Foundation

// MARK: - AnalyticsScreen

struct AnalyticsScreen {

	// MARK: Lifecycle

	init(name: String, properties: [String: Any] = [:]) {
		self.name = name
		self.properties = properties
	}

	// MARK: Internal

	let name: String
	let properties: [String: Any]

}

// MARK: - AnalyticsEvent

struct AnalyticsEvent {

	// MARK: Lifecycle

	init(name: String, properties: [String: Any] = [:]) {
		self.name = name
		self.properties = properties
	}

	// MARK: Internal

	let name: String
	let properties: [String: Any]

}

// MARK: - AnalyticsConnectable

protocol AnalyticsConnectable {
	func screen(_ screen: AnalyticsScreen)
	func event(_ event: AnalyticsEvent)
}

// MARK: - AnalyticsProtocol

protocol AnalyticsProtocol {
	func screen(_ screen: AnalyticsScreen)
	func event(_ event: AnalyticsEvent)
}

// MARK: - Analytics

final class Analytics: AnalyticsProtocol {

	// MARK: Lifecycle

	init() {}

	// MARK: Public

	public func addConnector(_ connector: AnalyticsConnectable) {
		connectors.append(connector)
	}

	// MARK: Internal

	static let shared = Analytics()

	func screen(_ screen: AnalyticsScreen) {
		connectors.forEach { $0.screen(screen) }
	}

	func event(_ event: AnalyticsEvent) {
		connectors.forEach { $0.event(event) }
	}

	// MARK: Private

	private var connectors: [AnalyticsConnectable] = []

}
