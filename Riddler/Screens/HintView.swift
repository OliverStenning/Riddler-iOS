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
					RKIconButton(icon: Image(systemName: "plus"), action: game.requestHints)
				}
			}
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

	private var buttonString: String {
		game.player.hintsAvailable == 0 ? "Out of hints" : "Use hint: \(game.player.hintsAvailable) remaining"
	}

}

// MARK: - HintView_Previews

struct HintView_Previews: PreviewProvider {
	static var previews: some View {
		HintView()
			.environmentObject(GameplayManager(storageManager: PreviewStorageManager()))
	}
}
