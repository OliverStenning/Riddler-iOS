import GoogleMobileAds
import OSLog
import SwiftUI
import UserMessagingPlatform

class UMPConsentViewController: UIViewController {

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

	override func viewDidLoad() {
		super.viewDidLoad()

		let requestParameters = UMPRequestParameters()
		let debugSettings = UMPDebugSettings()
		debugSettings.geography = .EEA
		debugSettings.testDeviceIdentifiers = ["12E8FAFC-172A-45C0-B1BF-A7A2C8413E22"]
		requestParameters.debugSettings = debugSettings

		UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: requestParameters) { [weak self] error in
			guard let self else { return }

			if let error {
				Logger.consent.error("Failed to request consent with error: \(error)")
			}

			Logger.consent.info("Loading and presenting consent form if required.")
			UMPConsentForm.loadAndPresentIfRequired(from: self) { [weak self] error in
				guard let self else { return }

				if let error {
					Logger.consent.error("Failed to present consent form with error: \(error)")
					failure(error)
				} else {
					AdsManager.shared.hasConsented = UMPConsentInformation.sharedInstance.canRequestAds
					Logger.consent.info("Consent collection completed with hasConsented: \(AdsManager.shared.hasConsented)")
					completion()
				}
			}
		}

		let hasPreviouslyConsented = UMPConsentInformation.sharedInstance.canRequestAds
		Logger.ads.info("Using consent information from previous session, hasConsent: \(hasPreviouslyConsented)")
		AdsManager.shared.hasConsented = hasPreviouslyConsented
	}

	// MARK: Private

	private let failure: (Error) -> Void
	private let completion: () -> Void

}
