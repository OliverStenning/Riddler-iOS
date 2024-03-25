import Foundation
import GameKit
import SwiftUI

struct GKAuthenticationView: UIViewControllerRepresentable {

	// MARK: Lifecycle

	public init(failed: @escaping ((Error) -> Void), authenticated: @escaping ((GKPlayer) -> Void)) {
		self.failed = failed
		self.authenticated = authenticated
	}

	// MARK: Internal

	func makeUIViewController(context: UIViewControllerRepresentableContext<GKAuthenticationView>) -> GKAuthenticationViewController {
		let authenticationViewController = GKAuthenticationViewController { failed in
			self.failed(failed)
		} authenticated: { player in
			authenticated(player)
		}
		return authenticationViewController
	}

	func updateUIViewController(_ uiViewController: GKAuthenticationViewController, context: UIViewControllerRepresentableContext<GKAuthenticationView>) {}

	// MARK: Private

	private let failed: (Error) -> Void
	private let authenticated: (GKPlayer) -> Void
}
