import SwiftUI

// MARK: - RKBottomSheetPrompt

struct RKBottomSheetPrompt: View {

	var titleText: String
	var bodyText: String
	var primaryText: String
	var secondaryText: String
	var primaryAction: () -> Void
	var secondaryAction: () -> Void

	var body: some View {
		VStack(spacing: 0) {
			Text(titleText)
				.font(RKFonts.Abel.regular.swiftUIFont(fixedSize: 36))
				.foregroundStyle(RKColors.accent.swiftUIColor)
				.multilineTextAlignment(.center)

			Spacer(minLength: 16)

			Text(bodyText)
				.font(RKFonts.Abel.regular.swiftUIFont(fixedSize: 24))
				.foregroundStyle(RKColors.accent.swiftUIColor)
				.multilineTextAlignment(.center)
				.fixedSize(horizontal: false, vertical: true)

			Spacer(minLength: 16)

			HStack(spacing: 24) {
				RKButton(title: secondaryText, style: .grey, size: .fill, action: secondaryAction)
				RKButton(title: primaryText, style: .accent, size: .fill, action: primaryAction)
			}
		}
		.frame(maxWidth: .infinity)
		.padding(16)
		.background(RKColors.primary.swiftUIColor)
	}
}

// MARK: - BasicDialog_Previews

struct BasicDialog_Previews: PreviewProvider {
	static var previews: some View {
		RKBottomSheetPrompt(
			titleText: "Need some help?",
			bodyText: "Watch a video to unlock 3 more hints",
			primaryText: "Watch",
			secondaryText: "Close",
			primaryAction: {},
			secondaryAction: {}
		)
	}
}
