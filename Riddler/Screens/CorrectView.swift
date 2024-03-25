import Pow
import SwiftUI

// MARK: - CorrectView

struct CorrectView: View {

	// MARK: Internal

	@EnvironmentObject var game: GameplayManager

	var body: some View {
		VStack {
			Spacer()

			if showTickAnimation {
				Image(systemName: "checkmark")
					.fontWeight(.bold)
					.font(.system(size: 200))
					.foregroundColor(RKColors.primaryDark.swiftUIColor)
					.padding(.top, 30)
					.transition(.movingParts.pop(RKColors.primaryDark.swiftUIColor))
			} else {
				Image(systemName: "checkmark")
					.fontWeight(.bold)
					.font(.system(size: 200))
					.opacity(0)
			}

			Spacer()
			Text("Correct")
				.kerning(-2.0)
				.font(RKFonts.Abel.regular.swiftUIFont(fixedSize: 80))
				.foregroundStyle(RKColors.primaryDark.swiftUIColor)

			Spacer()
			VStack {
				HStack {
					Text("Guesses:")
					Spacer()
					Text(String((game.player.riddleStats.last?.incorrectGuesses ?? 0) + 1))
				}
				HStack {
					Text("Time:")
					Spacer()
					Text(game.player.riddleStats.last?.formattedTimeTaken ?? "0 sec")
				}
			}
			.font(RKFonts.Abel.regular.swiftUIFont(fixedSize: 30))
			.foregroundStyle(RKColors.primaryDark.swiftUIColor)
			.padding(.horizontal, 20)
			.padding(.vertical, 10)

			Spacer()
			HStack(spacing: 12) {
				RKButton(title: "Suggest", icon: Image(systemName: "exclamationmark.bubble"), style: .primary, size: .fill, action: suggestTapped)
				RKButton(title: "Share", icon: Image(systemName: "square.and.arrow.up"), style: .primary, size: .fill, action: shareTapped)
			}
			.padding(.horizontal, 16)
			Spacer()
		}
		.padding(20)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(RKBackground(isDark: false))
		.onAppear {
			showTickAnimation = true
			game.correctAppeared()
		}
		.sheet(isPresented: $showSuggestBottomSheet) {
			RKBottomSheetPrompt(
				titleText: "Missing answer?",
				bodyText: "Suggest an alterative answer to help improve Riddler.",
				primaryText: "Suggest",
				secondaryText: "Close",
				primaryAction: pressDialogSuggest,
				secondaryAction: pressDialogClose
			)
			.presentationDetents([.fraction(0.35)])
		}
		.toast(isShowing: $game.showShareCorrectToast, icon: Image(systemName: "bubble.left.fill"), text: "Copied to clipboard")
		.toast(isShowing: $game.showAchievementToast, icon: Image(systemName: "trophy"), text: "Achievement Unlocked!")
		.analyticsScreen(.correct())
	}

	func suggestTapped() {
		Analytics.shared.event(.tapOpenSuggestDialog())
		showSuggestBottomSheet = true
	}

	func shareTapped() {
		Analytics.shared.event(.tapShareCorrect())
		game.shareCorrect()
	}

	func pressDialogSuggest() {
		Analytics.shared.event(.tapSuggestAnswer())
		showSuggestBottomSheet = false
		if let url = URL(string: "mailto:suggest@rddle.me?subject=I%20have%20a%20valid%20answer%20on%20riddle%20%23\(game.player.currentRiddleIndex)") {
			UIApplication.shared.open(url)
		}
	}

	func pressDialogClose() {
		Analytics.shared.event(.tapCloseSuggestDialog())
		showSuggestBottomSheet = false
	}

	// MARK: Private

	@State private var showSuggestBottomSheet: Bool = false
	@State private var showTickAnimation = false
}

// MARK: - CorrectView_Previews

struct CorrectView_Previews: PreviewProvider {
	static var previews: some View {
		CorrectView()
			.environmentObject(GameplayManager(storageManager: PreviewStorageManager()))
	}
}
