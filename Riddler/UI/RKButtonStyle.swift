import Foundation
import SwiftUI

struct RKButtonStyle: ButtonStyle {

	var style: RKButton.Style

	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.font(RKFonts.Teko.regular.swiftUIFont(fixedSize: 28))
			.background(style.backgroundColor(isPressed: configuration.isPressed))
			.foregroundColor(style.foregroundColor())
			.cornerRadius(8)
	}
}
