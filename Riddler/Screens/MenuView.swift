import GameKit
import SwiftUI

// MARK: - MenuView

struct MenuView: View {

	// MARK: Internal

	@StateObject var startupManager: StartupManager
	@StateObject var game: GameplayManager

	var body: some View {
		NavigationStack(path: $game.navigationPath) {
			ZStack {
				VStack {
					Spacer()
					Spacer()
					Text("Riddler")
						.kerning(-2)
						.font(RKFonts.Abel.regular.swiftUIFont(fixedSize: 110))
						.foregroundStyle(RKColors.accent.swiftUIColor)

					Spacer()

					ZStack {
						Grid {
							GridRow {
								Button(action: startTapped) {
									Text("Start")
										.font(RKFonts.Teko.regular.swiftUIFont(fixedSize: 48))
										.frame(width: 216, height: 64)
										.padding(.bottom, -2)
										.padding(.top, 2)
								}
								.buttonStyle(RKButtonStyle(style: .accent))
								.gridCellColumns(3)
							}

							GridRow {
								RKIconButton(icon: Image(systemName: "trophy"), size: .large, action: achievementsTapped)
								RKIconButton(icon: Image(systemName: "person.and.background.striped.horizontal"), size: .large, action: leaderboardTapped)
								RKIconButton(icon: Image(systemName: "gearshape"), size: .large, action: settingsTapped)
							}
						}
						.opacity(startupManager.startupStep == .complete ? 1 : 0)

						ProgressView()
							.controlSize(.large)
							.tint(RKColors.accent.swiftUIColor)
							.opacity(startupManager.startupStep != .complete ? 1 : 0)
					}

					Spacer()
					Spacer()
				}

				switch startupManager.startupStep {
				case .gameCenter:
					GKAuthenticationView(failed: handleGKError, authenticated: handleGKAuthentication)
				case .adsConsent:
					UMPConsentView(failure: handleUMPError, completion: handleUMPConsent)
				case .complete:
					EmptyView()
				}
			}
			.ignoresSafeArea(.all)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(RKBackground(isDark: true))
			.navigationDestination(for: NavigationRoute.self) { route in
				switch route {
				case .riddle:
					RiddleView()
				case .hint:
					HintView()
				case .victory:
					VictoryView()
				case .settings:
					SettingsView()
				}
			}
			.sheet(isPresented: $showLeaderboard) {
				GKLeaderboardView()
			}
			.sheet(isPresented: $showAchievements) {
				GKAchievementsView()
			}
			.alert("Unable to login to Game Center", isPresented: $showGKError) {
				Button("OK", role: .cancel) {}
			}
			.analyticsScreen(.menu())
		}
		.environmentObject(game)
	}

	// MARK: Private

	@State private var showAchievements = false
	@State private var showLeaderboard = false
	@State private var showAchievementsAfterAuth = false
	@State private var showLeaderboardAfterAuth = false
	@State private var showGKError = false

	private func startTapped() {
		Analytics.shared.event(.tapStart())
		game.startTapped()
	}

	private func settingsTapped() {
		Analytics.shared.event(.tapSettings())
		game.navigationPath.append(NavigationRoute.settings)
	}

	private func leaderboardTapped() {
		Analytics.shared.event(.tapLeaderboard())
		if !GKManager.shared.isAuthenticated {
			startupManager.startupStep = .gameCenter
			showLeaderboardAfterAuth = true
		} else {
			showLeaderboard = true
		}
	}

	private func achievementsTapped() {
		Analytics.shared.event(.tapAchievements())
		if !GKManager.shared.isAuthenticated {
			startupManager.startupStep = .gameCenter
			showAchievementsAfterAuth = true
		} else {
			showAchievements = true
		}
	}

	private func handleGKAuthentication(player: GKPlayer) {
		GKManager.shared.isAuthenticated = true
		game.handleGameCenterAuthenticated()
		startupManager.handleGameCenterComplete()
	}

	private func handleGKError(error: Error) {
		showGKError = true
		startupManager.handleGameCenterComplete()
	}

	private func handleUMPConsent() {
		startupManager.handleAdsConsentcomplete()
	}

	private func handleUMPError(error: Error) {
		startupManager.handleAdsConsentcomplete()
	}

}

// MARK: - MenuView_Previews

struct MenuView_Previews: PreviewProvider {
	static var previews: some View {
		MenuView(startupManager: StartupManager(startupStep: .complete), game: GameplayManager(storageManager: PreviewStorageManager()))
	}
}
