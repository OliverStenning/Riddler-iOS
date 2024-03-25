import Foundation
import GameKit
import OSLog
import SwiftUI
import UserMessagingPlatform

class UMPPrivacyViewController: UIViewController {

	// MARK: Lifecycle

	init(failure: @escaping (Error) -> Void, completion: @escaping () -> Void) {
		self.failure = failure
		self.completion = completion
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		UMPConsentForm.presentPrivacyOptionsForm(from: self) { [weak self] error in
			guard let self else { return }

			if let error {
				Logger.consent.error("Failed to present privacy form from settings with error: \(error)")
				failure(error)
			} else {
				AdsManager.shared.hasConsented = UMPConsentInformation.sharedInstance.canRequestAds
				Logger.consent.info("Updated consent status to hasConsented: \(AdsManager.shared.hasConsented)")
				Logger.consent.info("Updated consent status to: \(UMPConsentInformation.sharedInstance.consentStatus.rawValue)")
				completion()
			}
		}
	}

	// MARK: Internal

	let failure: (Error) -> Void
	let completion: () -> Void

}
