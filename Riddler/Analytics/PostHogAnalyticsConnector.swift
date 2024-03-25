import Foundation
import PostHog

struct PostHogAnalyticsConnector: AnalyticsConnectable {

	func screen(_ screen: AnalyticsScreen) {
		PostHogSDK.shared.screen(screen.name, properties: screen.properties)
	}

	func event(_ event: AnalyticsEvent) {
		PostHogSDK.shared.capture(event.name, properties: event.properties)
	}

}
