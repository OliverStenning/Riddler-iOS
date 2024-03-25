import GameKit
import SwiftUI
import UIKit

struct GKAchievementsView: UIViewControllerRepresentable {

	class Coordinator: NSObject, GKGameCenterControllerDelegate {

		// MARK: Lifecycle

		init(_ parent: GKAchievementsView) {
			self.parent = parent
		}

		// MARK: Internal

		var parent: GKAchievementsView

		func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
			gameCenterViewController.dismiss(animated: true)
		}

	}

	func makeUIViewController(context: Context) -> some UIViewController {
		let viewController = GKGameCenterViewController(state: .achievements)
		viewController.gameCenterDelegate = context.coordinator
		return viewController
	}

	func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
}
