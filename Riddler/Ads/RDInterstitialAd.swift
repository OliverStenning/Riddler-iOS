import GoogleMobileAds
import OSLog
import SwiftUI

class RDInterstitialAd: NSObject {

	// MARK: Internal

	static let shared = RDInterstitialAd()

	var interstitialAd: InterstitialAd?

	func loadAd() {
		let request = Request()
		InterstitialAd.load(with: adUnitId, request: request) { interstitialAd, error in
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
