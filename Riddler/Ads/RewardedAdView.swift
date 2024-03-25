import Foundation
import GoogleMobileAds
import SwiftUI

struct RewardedAdView: UIViewControllerRepresentable {

	// MARK: Lifecycle

	public init(
		rewardedHandler: @escaping () -> Void,
		completion: @escaping () -> Void
	) {
		rewardHandler = rewardedHandler
		self.completion = completion
	}

	// MARK: Internal

	func makeUIViewController(context: UIViewControllerRepresentableContext<RewardedAdView>) -> RewardedAdViewController {
		let adViewController = RewardedAdViewController(rewardHandler: rewardHandler, completion: completion)
		return adViewController
	}

	func updateUIViewController(_ uiViewController: RewardedAdViewController, context: UIViewControllerRepresentableContext<RewardedAdView>) {}

	// MARK: Private

	private let rewardHandler: () -> Void
	private let completion: () -> Void

}
