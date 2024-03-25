import GoogleMobileAds
import OSLog
import SwiftUI

class InterstitialAd: NSObject {

	// MARK: Internal

	static let shared = InterstitialAd()

	var interstitialAd: GADInterstitialAd?

	func loadAd() {
		let request = GADRequest()
		GADInterstitialAd.load(withAdUnitID: adUnitId, request: request) { interstitialAd, error in
			if let error {
				Logger.ads.error("Failed to load ad with error: \(error)")
				return
			}
			Logger.ads.info("Loaded interstitial ad")
			self.interstitialAd = interstitialAd
		}
	}

	func clearAd() {
		interstitialAd = nil
	}

	// MARK: Private

	private let adUnitId: String = Config.interstitialAdUnitId

}
