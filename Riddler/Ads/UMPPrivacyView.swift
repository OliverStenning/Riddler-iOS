import Foundation
import GameKit
import SwiftUI

struct UMPPrivacyView: UIViewControllerRepresentable {

	// MARK: Lifecycle

	public init(failure: @escaping ((Error) -> Void), completion: @escaping (() -> Void)) {
		self.failure = failure
		self.completion = completion
	}

	// MARK: Internal

	func makeUIViewController(context: UIViewControllerRepresentableContext<UMPPrivacyView>) -> UMPPrivacyViewController {
		let consentViewController = UMPPrivacyViewController(failure: failure, completion: completion)
		return consentViewController
	}

	func updateUIViewController(_ uiViewController: UMPPrivacyViewController, context: UIViewControllerRepresentableContext<UMPPrivacyView>) {}

	// MARK: Private

	private let failure: (Error) -> Void
	private let completion: () -> Void
}
