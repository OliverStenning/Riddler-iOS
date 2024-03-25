import Combine
import Foundation
import GameKit
import os.log

public final class GKAuthentication: NSObject, GKLocalPlayerListener {

	// MARK: Lifecycle

	private override init() {
		isAuthenticated.value = GKLocalPlayer.local.isAuthenticated
		super.init()
		// Setup internal observer for GameKit authentication changes
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(GKAuthentication.authenticationChanged),
			name: Notification.Name.GKPlayerAuthenticationDidChangeNotificationName,
			object: nil
		)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: Public

	public static let shared = GKAuthentication()

	public private(set) var isAuthenticated = CurrentValueSubject<Bool, Never>(false)

	public func authenticate(
		authenticationViewController: @escaping (UIViewController) -> Void,
		failed: @escaping (Error) -> Void,
		authenticated: @escaping (GKLocalPlayer) -> Void
	) {
		if GKLocalPlayer.local.isAuthenticated {
			authenticated(GKLocalPlayer.local)
			return
		}

		if let authenticationError {
			failed(authenticationError)
			return
		}

		GKLocalPlayer.local.authenticateHandler = { viewController, error in
			if GKLocalPlayer.local.isAuthenticated {
				authenticated(GKLocalPlayer.local)
				return
			}

			if let viewController {
				authenticationViewController(viewController)
				return
			}

			if let error {
				Logger.gameCenter.error("Authentication failed with error: \(error.localizedDescription)")
				self.authenticationError = error
				failed(error)
				return
			}
		}
	}

	// MARK: Internal

	private(set) var authenticationError: Error?

	// MARK: Fileprivate

	@objc fileprivate func authenticationChanged() {
		isAuthenticated.value = GKLocalPlayer.local.isAuthenticated
	}
}
