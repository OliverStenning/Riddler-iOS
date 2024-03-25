import Foundation
import GoogleMobileAds
import SwiftUI

struct InterstitialAdView: UIViewControllerRepresentable {

	// MARK: Lifecycle

	public init(
		completion: @escaping (() -> Void)
	) {
		self.completion = completion
	}

	// MARK: Internal

	func makeUIViewController(context: UIViewControllerRepresentableContext<InterstitialAdView>) -> InterstitialAdViewController {
		let adViewController = InterstitialAdViewController(completion: completion)
		return adViewController
	}

	func updateUIViewController(_ uiViewController: InterstitialAdViewController, context: UIViewControllerRepresentableContext<InterstitialAdView>) {}

	// MARK: Private

	private let completion: () -> Void

}
