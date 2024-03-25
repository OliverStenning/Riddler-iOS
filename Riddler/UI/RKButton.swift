import SwiftUI

// MARK: - RKButton

struct RKButton: View {

	// MARK: Lifecycle

	init(title: String, icon: Image? = nil, style: Style = .accent, size: Size = .flex, action: @escaping () -> Void) {
		self.title = title
		self.icon = icon
		self.style = style
		self.size = size
		self.action = action
	}

	// MARK: Internal

	enum Style {
		case accent
		case primary
		case grey

		// MARK: Internal

		func foregroundColor() -> Color {
			switch self {
			case .accent, .grey: RKColors.primaryDark.swiftUIColor
			case .primary: RKColors.accent.swiftUIColor
			}
		}

		func backgroundColor(isPressed: Bool) -> Color {
			isPressed ? pressedBackgroundColor : defaultBackgroundColor
		}

		// MARK: Private

		private var defaultBackgroundColor: Color {
			switch self {
			case .accent: RKColors.accent.swiftUIColor
			case .primary: RKColors.primary.swiftUIColor
			case .grey: RKColors.grey.swiftUIColor
			}
		}

		private var pressedBackgroundColor: Color {
			switch self {
			case .accent: RKColors.accentDark.swiftUIColor
			case .primary: RKColors.primaryDark.swiftUIColor
			case .grey: RKColors.grey2.swiftUIColor
			}
		}

	}

	enum Size {
		case fill
		case flex

		// MARK: Internal

		var maxWidth: CGFloat? {
			switch self {
			case .flex: nil
			case .fill: .infinity
			}
		}

		var horizontalPadding: CGFloat? {
			switch self {
			case .flex: 24
			case .fill: nil
			}
		}
	}

	var body: some View {
		Button(action: action) {
			Label(
				title: {
					Text(title)
						.padding(.bottom, -2)
						.fixedSize(horizontal: false, vertical: true)
						.multilineTextAlignment(.center)
						.padding(.vertical, 4)
				},
				icon: {
					if let icon {
						icon
							.font(.system(size: 20))
							.fontWeight(.bold)
					}
				}
			)
			.frame(maxWidth: size.maxWidth)
			.frame(minHeight: 48)
			.padding(.horizontal, size.horizontalPadding)
		}
		.buttonStyle(RKButtonStyle(style: style))
	}

	// MARK: Private

	private let title: String
	private let icon: Image?
	private let style: Style
	private let size: Size
	private let action: () -> Void

}

// MARK: - RKButton_Previews

struct RKButton_Previews: PreviewProvider {
	static var previews: some View {
		ScrollView {
			VStack(spacing: 0) {
				VStack {
					RKButton(title: "Share", style: .accent, action: {})
					RKButton(title: "Share", icon: Image(systemName: "chart.bar.fill"), style: .accent, action: {})
					RKButton(title: "Share", style: .accent, size: .fill, action: {})
					RKButton(title: "Share", icon: Image(systemName: "chart.bar.fill"), style: .accent, size: .fill, action: {})
				}
				.padding(16)
				.background(RKColors.primary.swiftUIColor)

				VStack {
					RKButton(title: "Share", style: .primary, action: {})
					RKButton(title: "Share", icon: Image(systemName: "chart.bar.fill"), style: .primary, action: {})
					RKButton(title: "Share", style: .primary, size: .fill, action: {})
					RKButton(title: "Share", icon: Image(systemName: "chart.bar.fill"), style: .primary, size: .fill, action: {})
				}
				.padding(16)
				.background(RKColors.accent.swiftUIColor)

				VStack {
					RKButton(title: "Share", style: .grey, action: {})
					RKButton(title: "Share", icon: Image(systemName: "chart.bar.fill"), style: .grey, action: {})
					RKButton(title: "Share", style: .grey, size: .fill, action: {})
					RKButton(title: "Share", icon: Image(systemName: "chart.bar.fill"), style: .grey, size: .fill, action: {})
				}
				.padding(16)
				.background(RKColors.primary.swiftUIColor)
			}
			.padding(32)
		}
		.background(RKColors.primary.swiftUIColor)
	}
}
