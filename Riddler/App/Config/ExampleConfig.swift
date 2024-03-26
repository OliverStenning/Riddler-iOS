import Foundation

typealias Config = ExampleConfig

// MARK: - ExampleConfig

enum ExampleConfig {

	// PostHog analytics are disabled when the property is nil
	static let postHogApiKey: String? = nil
	static let postHogHost: String? = nil

	// AdMob requires updating app ID in Info.plist
	static let admobEnabled: Bool = false

	static let interstitialAdUnitId: String = "ca-app-pub-3940256099942544/4411468910"
	static let rewardedAdUnitId: String = "ca-app-pub-3940256099942544/1712485313"

	static let adMobTestDevices: [String] = []

}
