import SwiftUI

// MARK: - RKIconButton

struct RKIconButton: View {

	// MARK: Lifecycle

	init(icon: Image, style: RKButton.Style = .accent, size: Size = .general, action: @escaping () -> Void) {
		self.icon = icon
		self.style = style
		self.size = size
		self.action = action
	}

	// MARK: Internal

	enum Size {
		case general
		case large

		// MARK: Internal

		var iconSize: CGFloat {
			switch self {
			case .general: 24
			case .large: 32
			}
		}

		var padding: CGFloat {
			switch self {
			case .general: 12
			case .large: 16
			}
		}
	}

	var body: some View {
		Button(action: action) {
			icon
				.resizable()
				.fontWeight(.bold)
				.scaledToFit()
				.frame(width: size.iconSize, height: size.iconSize)
				.padding(size.padding)
		}
		.buttonStyle(RKButtonStyle(style: style))
	}

	// MARK: Private

	private let icon: Image
	private let style: RKButton.Style
	private let size: Size
	private let action: () -> Void

}

// MARK: - RKIconButton_Previews

struct RKIconButton_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			RKIconButton(icon: Image(systemName: "chart.bar.fill"), style: .accent, size: .general, action: {})
			RKIconButton(icon: Image(systemName: "chart.bar.fill"), style: .accent, size: .large, action: {})

			RKIconButton(icon: Image(systemName: "chart.bar.fill"), style: .primary, size: .general, action: {})
			RKIconButton(icon: Image(systemName: "chart.bar.fill"), style: .primary, size: .large, action: {})

			RKIconButton(icon: Image(systemName: "chart.bar.fill"), style: .grey, size: .general, action: {})
			RKIconButton(icon: Image(systemName: "chart.bar.fill"), style: .grey, size: .large, action: {})
		}
		.padding(32)
	}
}
