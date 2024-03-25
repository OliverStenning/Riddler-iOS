import SwiftUI

@main
struct RiddlerApp: App {

	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

	var body: some Scene {
		WindowGroup {
			MenuView(startupManager: StartupManager(), game: GameplayManager())
				.preferredColorScheme(.dark)
		}
	}

}
