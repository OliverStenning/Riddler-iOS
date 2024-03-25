import Pow
import SwiftUI
import Vortex

// MARK: - VictoryView

struct VictoryView: View {

	@EnvironmentObject var game: GameplayManager

	var body: some View {
		VStack(spacing: 32) {
			Spacer()

			Image(systemName: "trophy")
				.font(.system(size: 180))
				.fontWeight(.thin)
				.foregroundStyle(RKColors.accent.swiftUIColor)

			VStack(spacing: 0) {
				Text("You have beaten")
					.font(RKFonts.Abel.regular.swiftUIFont(fixedSize: 36))

				Text("Riddler")
					.font(RKFonts.Abel.regular.swiftUIFont(fixedSize: 80))
			}
			.multilineTextAlignment(.center)
			.foregroundStyle(RKColors.accent.swiftUIColor)

			HStack(spacing: 12) {
				RKButton(title: "Stats", icon: Image(systemName: "chart.bar.fill"), size: .fill, action: game.victoryStatsTapped)
				RKButton(title: "Share", icon: Image(systemName: "square.and.arrow.up"), size: .fill, action: game.shareVictory)
			}
			.padding(.horizontal, 32)
			Spacer()
		}
		.padding(20)
		.frame(maxWidth: .infinity)
		.background(
			ZStack {
				RKBackground(isDark: true)
				VortexView(.fireworks) {
					Circle()
						.fill(.white)
						.blendMode(.plusLighter)
						.frame(width: 32)
						.tag("circle")
				}
				.opacity(0.5)
			}
		)
		.sheet(isPresented: $game.showVictoryStats) {
			StatsView(stats: game.victoryStats)
		}
		.toast(isShowing: $game.showShareVictoryToast, icon: Image(systemName: "bubble.left.fill"), text: "Copied to clipboard")
		.analyticsScreen(.victory())
	}
}

// MARK: - VictoryView_Previews

struct VictoryView_Previews: PreviewProvider {
	static var previews: some View {
		VictoryView()
			.environmentObject(GameplayManager(storageManager: PreviewStorageManager()))
	}
}
