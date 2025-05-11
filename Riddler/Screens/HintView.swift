import SwiftUI

// MARK: - HintView

struct HintView: View {

	// MARK: Internal

	@EnvironmentObject var game: GameplayManager

	var body: some View {
		VStack {
			Spacer()
			Text(game.hintString)
				.font(RKFonts.Abel.regular.swiftUIFont(fixedSize: 30))
				.foregroundStyle(RKColors.accent.swiftUIColor)
				.multilineTextAlignment(.center)

			Spacer()
			HStack {
				RKButton(title: buttonString, size: .fill, action: game.useHint)
				if game.canRequestMoreHints {
					RKIconButton(icon: Image(systemName: "plus"), action: addHintsTapped)
				}
			}
		}
		.sheet(isPresented: $showAddHintsSheet, onDismiss: addHintsSheetDismissed) {
			RKBottomSheetPrompt(
				titleText: "Unlock more hints?",
				bodyText: "Watch a short ad to unlock 3 hints.",
				primaryText: "Watch",
				secondaryText: "Close",
				primaryAction: watchAdTapped,
				secondaryAction: closeAddHintsSheetTapped
			)
			.presentationDetents([.fraction(0.3)])
		}
		.toolbar {
			ToolbarItem(placement: .principal) {
				Text("\(game.player.currentRiddleHintsUsed)/\(game.riddles[game.player.currentRiddleIndex].hints.count)")
					.font(RKFonts.Abel.regular.swiftUIFont(fixedSize: 24))
					.foregroundStyle(RKColors.accent.swiftUIColor)
			}
		}
		.padding(20)
		.frame(maxWidth: .infinity)
		.background(RKBackground(isDark: true))
		.toast(isShowing: $game.showNoMoreHintsToast, text: "Riddle has no more hints!")
		.toast(isShowing: $game.showHintsRewardedToast, text: "3 hints added")
		.overlay {
			if game.showRewardedAd {
				RewardedAdView(rewardedHandler: game.handleHintReward, completion: game.rewardedAdDidFinish)
			}
		}
		.analyticsScreen(.hint())
	}

	// MARK: Private

	@State private var showAddHintsSheet: Bool = false
	@State private var requestRewardedAdAfterDismiss: Bool = false

	private var buttonString: String {
		game.player.hintsAvailable == 0 ? "Out of hints" : "Use hint: \(game.player.hintsAvailable) remaining"
	}

	private func addHintsTapped() {
		Analytics.shared.event(.tapGetMoreHints(numberOfHints: game.player.hintsAvailable))
		showAddHintsSheet = true
	}

	private func closeAddHintsSheetTapped() {
		Analytics.shared.event(.tapCloseGetMoreHintsDialog(numberOfHints: game.player.hintsAvailable))
		showAddHintsSheet = false
	}

	private func watchAdTapped() {
		Analytics.shared.event(.tapWatchRewardedAd(numberOfHints: game.player.hintsAvailable))
		requestRewardedAdAfterDismiss = true
		showAddHintsSheet = false
	}

	private func addHintsSheetDismissed() {
		guard requestRewardedAdAfterDismiss else { return }
		game.requestHints()
		requestRewardedAdAfterDismiss = false
	}

}

// MARK: - HintView_Previews

struct HintView_Previews: PreviewProvider {
	static var previews: some View {
		HintView()
			.environmentObject(GameplayManager(storageManager: PreviewStorageManager()))
	}
}
