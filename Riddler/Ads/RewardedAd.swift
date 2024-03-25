import Combine
import GoogleMobileAds
import OSLog
import SwiftUI

class RewardedAd: NSObject {

	// MARK: Internal

	static let shared = RewardedAd()

	var rewardedAd: GADRewardedAd?

	var adLoadedPublisher = PassthroughSubject<Void, Never>()

	func loadAd() {
		let request = GADRequest()
		GADRewardedAd.load(withAdUnitID: adUnitId, request: request) { rewardedAd, error in
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
