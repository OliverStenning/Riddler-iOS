import Foundation
import OSLog

struct LoggingAnalyticsConnector: AnalyticsConnectable {

	func screen(_ screen: AnalyticsScreen) {
		Logger.analytics.info("Screen: \(screen.name)\nProperties: \(screen.properties)")
	}

	func event(_ event: AnalyticsEvent) {
		Logger.analytics.info("Event: \(event.name)\nProperties: \(event.properties)")
	}

}
