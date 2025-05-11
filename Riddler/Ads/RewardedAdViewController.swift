import Foundation
import GoogleMobileAds
import OSLog
import SwiftUI

// MARK: - RewardedAdViewController

class RewardedAdViewController: UIViewController {

	// MARK: Lifecycle

	init(rewardHandler: @escaping () -> Void, completion: @escaping () -> Void) {
		rewardedAd = RDRewardedAd.shared.rewardedAd
		self.rewardHandler = rewardHandler
		self.completion = completion
		super.init(nibName: nil, bundle: nil)
		rewardedAd?.fullScreenContentDelegate = self
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		guard !hasShownAd else { return }

		if let rewardedAd {
			Logger.ads.info("Presenting rewarded ad")
			Analytics.shared.screen(.rewardedAd())
			hasShownAd = true
			rewardedAd.present(from: self, userDidEarnRewardHandler: rewardHandler)
		} else {
			Logger.ads.error("Tried to show rewarded ad when it wasn't loaded")
			completion()
		}
	}

	// MARK: Private

	private let rewardedAd: RewardedAd?

	private let rewardHandler: () -> Void
	private let completion: () -> Void

	private var hasShownAd: Bool = false

}

// MARK: GADFullScreenContentDelegate

extension RewardedAdViewController: FullScreenContentDelegate {

	func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
		Logger.ads.info("Rewarded ad finished displaying")
		RDRewardedAd.shared.loadAd()
		completion()
	}

	func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
		Logger.ads.error("Rewarded ad failed to present with error: \(error)")
		RDRewardedAd.shared.loadAd()
		completion()
	}

}
