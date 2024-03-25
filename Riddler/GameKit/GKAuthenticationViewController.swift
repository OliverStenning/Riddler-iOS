import Foundation
import GameKit
import OSLog
import SwiftUI

class GKAuthenticationViewController: UIViewController {

	// MARK: Lifecycle

	init(failed: @escaping (Error) -> Void, authenticated: @escaping (GKLocalPlayer) -> Void) {
		self.failed = failed
		self.authenticated = authenticated
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		GKAuthentication.shared.authenticate { authenticationViewController in
			self.add(authenticationViewController)
		} failed: { error in
			Logger.gameCenter.error("Authentication failed with error: \(error.localizedDescription)")
			self.failed(error)
		} authenticated: { player in
			Logger.gameCenter.info("Played authenticated \(player.displayName)")
			self.authenticated(player)
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		removeAll()
	}

	// MARK: Internal

	let failed: (Error) -> Void
	let authenticated: (GKLocalPlayer) -> Void

}
