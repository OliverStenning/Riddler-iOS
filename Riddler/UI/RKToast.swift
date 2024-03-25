import SwiftUI

// MARK: - RKToastModifier

struct RKToastModifier: ViewModifier {

	// MARK: Lifecycle

	init(isShowing: Binding<Bool>, icon: Image?, text: String, duration: TimeInterval, isError: Bool) {
		_isShowing = isShowing
		self.icon = icon
		self.text = text
		self.duration = duration
		self.isError = isError
	}

	// MARK: Internal

	@Binding var isShowing: Bool
	let icon: Image?
	let text: String
	let duration: TimeInterval
	let isError: Bool

	func body(content: Content) -> some View {
		ZStack {
			content
			if isShowing {
				toast
					.zIndex(1)
					.onAppear {
						DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
							withAnimation {
								isShowing.toggle()
							}
						}
					}
			}
		}
	}

	// MARK: Private

	private var toast: some View {
		VStack {
			Spacer()
			HStack(alignment: .center, spacing: 20) {
				if let icon {
					icon
						.font(.system(size: 20))
						.fontWeight(.bold)
				}
				Text(text)
					.font(RKFonts.Teko.regular.swiftUIFont(fixedSize: 30))
			}
			.foregroundColor(isError ? RKColors.primaryDark.swiftUIColor : RKColors.accent.swiftUIColor)
			.padding()
			.padding(.horizontal, 12)
			.background(isError ? RKColors.error.swiftUIColor : RKColors.primaryDark.swiftUIColor)
			.cornerRadius(8)
			.shadow(radius: 16)
		}
		.padding(32)
		.padding(.bottom, 64)
	}

}

extension View {
	func toast(isShowing: Binding<Bool>, icon: Image? = nil, text: String, duration: TimeInterval = 2, isError: Bool = false) -> some View {
		modifier(RKToastModifier(isShowing: isShowing, icon: icon, text: text, duration: duration, isError: isError))
	}
}
