import AdSupport
import GoogleMobileAds
import Pow
import StoreKit
import SwiftUI

// MARK: - RiddleView

struct RiddleView: View {

	@Environment(\.requestReview) var requestReview
	@EnvironmentObject var game: GameplayManager
	@FocusState var isFocused: Bool

	var body: some View {
		VStack {
			if let riddle = game.currentRiddle {
				VStack {
					GeometryReader { geometry in
						ScrollView(.vertical) {
							Text(riddle.question)
								.font(RKFonts.Abel.regular.swiftUIFont(fixedSize: 30))
								.foregroundStyle(RKColors.accent.swiftUIColor)
								.multilineTextAlignment(.center)
								.frame(width: geometry.size.width)
								.frame(minHeight: geometry.size.height)
						}
					}

					VStack(spacing: 10) {
						HStack {
							Spacer()
							RKButton(title: "Hints: \(game.player.hintsAvailable)", action: game.openHints)
						}

						HStack {
							TextField(text: $game.answerString) {
								Text("Enter answer...")
									.foregroundStyle(RKColors.grey.swiftUIColor.opacity(0.8))
							}
							.textInputAutocapitalization(.never)
							.focused($isFocused)
							.tint(RKColors.accent.swiftUIColor)
							.foregroundStyle(RKColors.accent.swiftUIColor)
							.font(RKFonts.Abel.regular.swiftUIFont(fixedSize: 24))
							.padding(.horizontal, 16)
							.frame(height: 48)
							.background(RKColors.primaryDark.swiftUIColor.opacity(0.75))
							.clipShape(RoundedRectangle(cornerRadius: 8))
							.changeEffect(.shake(rate: .fast), value: game.player.currentRiddleIncorrectGuesses)

							RKIconButton(icon: Image(systemName: "chevron.right"), action: game.checkAnswer)
						}
					}
				}
				.padding(20)
				.toolbar {
					ToolbarItem(placement: .principal) {
						Text(game.riddleNumberString)
							.font(RKFonts.Abel.regular.swiftUIFont(fixedSize: 24))
							.foregroundStyle(RKColors.accent.swiftUIColor)
					}
				}
			} else {
				VictoryView()
			}
		}
		.sheet(isPresented: $game.showCorrect, onDismiss: game.correctDismissed) {
			CorrectView()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(RKBackground(isDark: true))
		.onAppear {
			isFocused = true
		}
		.overlay {
			if game.showInterstitialAd {
				InterstitialAdView(completion: game.interstitialAdDidFinish)
			}
		}
		.onChange(of: game.showAppStoreReviewPrompt) { showAppStoreReviewPrompt in
			guard showAppStoreReviewPrompt else { return }
			requestReview()
			game.promptedForAppStoreReview()
		}
		.analyticsScreen(.riddle())
	}

}

// MARK: - RiddleView_Previews

struct RiddleView_Previews: PreviewProvider {
	static var previews: some View {
		RiddleView()
			.environmentObject(GameplayManager(storageManager: PreviewStorageManager()))
	}
}
