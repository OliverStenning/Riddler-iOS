import Foundation
import GoogleMobileAds
import OSLog

// MARK: - AdsManager

class AdsManager {

	// MARK: Lifecycle

	private init() {}

	// MARK: Internal

	static let shared = AdsManager()

	var hasConsented: Bool = false {
		didSet {
			if hasConsented {
				setupAdsSDK()
			}
		}
	}

	// MARK: Private

	private var isSDKSetup: Bool = false

	private func setupAdsSDK() {
		guard !isSDKSetup, Config.admobEnabled else { return }

		Logger.consent.info("Starting Mobile Ads SDK")
		MobileAds.shared.start { [weak self] _ in
			guard let self else { return }
			isSDKSetup = true
			MobileAds.shared.requestConfiguration.testDeviceIdentifiers = Config.adMobTestDevices

			RDInterstitialAd.shared.loadAd()
			RDRewardedAd.shared.loadAd()
		}
	}
}
