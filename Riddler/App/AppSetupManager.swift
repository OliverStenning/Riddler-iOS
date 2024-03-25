import Foundation
import PostHog
import UIKit

enum AppSetupManager {

	// MARK: Internal

	static func setup() {
		setupPostHog()
		setupAnalyticsLogging()
		setupAppearance()
	}

	// MARK: Private

	private static func setupPostHog() {
		// Omitted from public repo
		guard let postHogApiKey = Config.postHogApiKey, let postHogHost = Config.postHogHost else { return }
		let config = PostHogConfig(apiKey: postHogApiKey, host: postHogHost)
		PostHogSDK.shared.setup(config)
		Analytics.shared.addConnector(PostHogAnalyticsConnector())
	}

	private static func setupAnalyticsLogging() {
		Analytics.shared.addConnector(LoggingAnalyticsConnector())
	}

	private static func setupAppearance() {
		UIBarButtonItem.appearance().setTitleTextAttributes([
			.font: RKFonts.Teko.regular.font(size: 24),
			.foregroundColor: RKColors.accent.color
		], for: .normal)

		UIBarButtonItem.appearance().setTitleTextAttributes([
			.font: RKFonts.Teko.regular.font(size: 24),
			.foregroundColor: RKColors.accentDark.color
		], for: .highlighted)

		UIBarButtonItem.appearance().tintColor = RKColors.accent.color
	}

}
