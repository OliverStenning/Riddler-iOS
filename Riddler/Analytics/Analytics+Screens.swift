import Foundation

extension AnalyticsScreen {

	static func menu() -> Self {
		.init(name: "Menu")
	}

	static func settings() -> Self {
		.init(name: "Settings")
	}

	static func riddle() -> Self {
		.init(name: "Riddle")
	}

	static func hint() -> Self {
		.init(name: "Hint")
	}

	static func correct() -> Self {
		.init(name: "Correct")
	}

	static func victory() -> Self {
		.init(name: "Victory")
	}

	static func stats() -> Self {
		.init(name: "Stats")
	}

	static func interstitialAd() -> Self {
		.init(name: "Interstitial ad")
	}

	static func rewardedAd() -> Self {
		.init(name: "Rewarded ad")
	}

}
