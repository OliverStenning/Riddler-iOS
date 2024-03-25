import SwiftUI

// MARK: - RKBackground

struct RKBackground: View {
	var isDark: Bool

	var body: some View {
		ZStack {
			Color(uiColor: isDark ? RKColors.primary.color : RKColors.accent.color)
				.ignoresSafeArea(edges: .all)
			Image(isDark ? "primaryBackground" : "accentBackground")
				.resizable()
				.aspectRatio(contentMode: .fill)
				.ignoresSafeArea(edges: .all)
		}
	}
}

// MARK: - Background_Previews

struct Background_Previews: PreviewProvider {
	static var previews: some View {
		RKBackground(isDark: true)
		RKBackground(isDark: false)
	}
}
