import SwiftUI

// MARK: - DebugView

struct DebugView: View {

	@EnvironmentObject var gameplay: GameplayManager

	var body: some View {
		VStack(spacing: 48) {
			Text("Debug")
				.kerning(-2)
				.font(.custom("Abel-Regular", size: 60))
				.foregroundStyle(RKColors.accent.swiftUIColor)

			VStack(spacing: 24) {
				RKButton(
					title: "Reset data",
					size: .fill,
					action: gameplay.debugResetTapped
				)
			}

			Spacer()

			Text("v1.0.1")
				.font(.custom("Abel-Regular", size: 20))
				.foregroundStyle(RKColors.accent.swiftUIColor)
		}
		.padding(.horizontal, 64)
		.padding(.vertical, 32)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(RKBackground(isDark: true))
	}

}

// MARK: - DebugView_Previews

struct DebugView_Previews: PreviewProvider {
	static var previews: some View {
		DebugView()
			.environmentObject(GameplayManager(storageManager: PreviewStorageManager()))
	}
}
