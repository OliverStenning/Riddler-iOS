import GameKit
import SwiftUI
import UIKit

struct GKLeaderboardView: UIViewControllerRepresentable {

	class Coordinator: NSObject, GKGameCenterControllerDelegate {

		// MARK: Lifecycle

		init(_ parent: GKLeaderboardView) {
			self.parent = parent
		}

		// MARK: Internal

		var parent: GKLeaderboardView

		func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
			gameCenterViewController.dismiss(animated: true)
		}

	}

	func makeUIViewController(context: Context) -> some UIViewController {
		let viewController = GKGameCenterViewController(leaderboardID: "riddle_progress", playerScope: .friendsOnly, timeScope: .allTime)
		viewController.gameCenterDelegate = context.coordinator
		return viewController
	}

	func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
}
