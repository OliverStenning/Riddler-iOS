import Foundation
import GameKit
import SwiftUI

struct UMPConsentView: UIViewControllerRepresentable {

	// MARK: Lifecycle

	public init(failure: @escaping ((Error) -> Void), completion: @escaping (() -> Void)) {
		self.failure = failure
		self.completion = completion
	}

	// MARK: Internal

	func makeUIViewController(context: UIViewControllerRepresentableContext<UMPConsentView>) -> UMPConsentViewController {
		let consentViewController = UMPConsentViewController(failure: failure, completion: completion)
		return consentViewController
	}

	func updateUIViewController(_ uiViewController: UMPConsentViewController, context: UIViewControllerRepresentableContext<UMPConsentView>) {}

	// MARK: Private

	private let failure: (Error) -> Void
	private let completion: () -> Void
}
