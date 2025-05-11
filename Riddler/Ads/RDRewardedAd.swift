import Combine
import GoogleMobileAds
import OSLog
import SwiftUI

class RDRewardedAd: NSObject {

	// MARK: Internal

	static let shared = RDRewardedAd()

	var rewardedAd: RewardedAd?

	var adLoadedPublisher = PassthroughSubject<Void, Never>()

	func loadAd() {
		let request = Request()
		RewardedAd.load(with: adUnitId, request: request) { rewardedAd, error in
			if let error {
				Logger.ads.error("Failed to load rewarded ad with error: \(error)")
				return
			}

			Logger.ads.info("Loaded rewarded ad")
			self.rewardedAd = rewardedAd
			self.adLoadedPublisher.send()
		}
	}

	func clearAd() {
		rewardedAd = nil
	}

	// MARK: Private

	private let adUnitId: String = Config.rewardedAdUnitId

}
