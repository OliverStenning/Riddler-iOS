import SwiftUI

// MARK: - StartupStep

enum StartupStep {
	case gameCenter
	case adsConsent
	case complete
}

// MARK: - StartupManager

final class StartupManager: ObservableObject {

	// MARK: Lifecycle

	init(startupStep: StartupStep = .gameCenter) {
		self.startupStep = startupStep
	}

	// MARK: Internal

	@Published var startupStep: StartupStep = .gameCenter

	func handleGameCenterComplete() {
		startupStep = .adsConsent
	}

	func handleAdsConsentcomplete() {
		startupStep = .complete
	}

}
