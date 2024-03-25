import Foundation
import GoogleMobileAds
import OSLog
import SwiftUI

// MARK: - InterstitialAdViewController

class InterstitialAdViewController: UIViewController {

	// MARK: Lifecycle

	init(completion: @escaping () -> Void) {
		interstitialAd = InterstitialAd.shared.interstitialAd
		self.completion = completion
		super.init(nibName: nil, bundle: nil)
		interstitialAd?.fullScreenContentDelegate = self
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		guard !hasShownAd else { return }

		if let interstitialAd {
			Logger.ads.info("Presenting interstitial ad")
			Analytics.shared.screen(.interstitialAd())
			hasShownAd = true
			interstitialAd.present(fromRootViewController: self)
		} else {
			Logger.ads.error("Tried to show interstitial ad when it wasn't loaded")
			completion()
		}
	}

	// MARK: Private

	private let interstitialAd: GADInterstitialAd?

	private let completion: () -> Void

	private var hasShownAd: Bool = false

}

// MARK: GADFullScreenContentDelegate

extension InterstitialAdViewController: GADFullScreenContentDelegate {

	func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
		Logger.ads.info("Add finished displaying")
		InterstitialAd.shared.loadAd()
		completion()
	}

	func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
		Logger.ads.error("Ad failed to present with error: \(error)")
		InterstitialAd.shared.loadAd()
		completion()
	}

}
