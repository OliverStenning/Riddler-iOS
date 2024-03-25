import SwiftUI
import UserMessagingPlatform

// MARK: - SettingsView

struct SettingsView: View {

	// MARK: Internal

	var body: some View {
		ZStack {
			VStack(spacing: 48) {
				Text("Settings")
					.kerning(-2)
					.font(.custom("Abel-Regular", size: 60))
					.foregroundStyle(RKColors.accent.swiftUIColor)

				VStack(spacing: 24) {
					RKButton(
						title: "Privacy Policy",
						icon: Image(systemName: "doc.fill"),
						size: .fill,
						action: privacyPolicyTapped
					)

					if UMPConsentInformation.sharedInstance.privacyOptionsRequirementStatus == .required {
						RKButton(
							title: "Update privacy",
							icon: Image(systemName: "rectangle.and.pencil.and.ellipsis"),
							size: .fill,
							action: updatePrivacyTapped
						)
					}

					RKButton(
						title: "Report bug",
						icon: Image(systemName: "exclamationmark.bubble.fill"),
						size: .fill,
						action: reportBugTapped
					)
				}

				Spacer()

				Text("v1.1.0")
					.font(.custom("Abel-Regular", size: 20))
					.foregroundStyle(RKColors.accent.swiftUIColor)
					.onTapGesture(count: 5, perform: openDebugMenuTapped)
			}

			if showPrivacyForm {
				UMPPrivacyView(failure: handlePrivacyError, completion: handlePrivacyComplete)
			}
		}
		.padding(.horizontal, 64)
		.padding(.vertical, 32)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(RKBackground(isDark: true))
		.sheet(isPresented: $showDebugMenu) {
			DebugView()
		}
		.alert("Unable to update privacy settings", isPresented: $showPrivacyError) {
			Button("OK", role: .cancel) {}
		}
		.analyticsScreen(.settings())
	}

	// MARK: Private

	@State private var showDebugMenu: Bool = false
	@State private var showPrivacyForm: Bool = false
	@State private var showPrivacyError: Bool = false

	private func privacyPolicyTapped() {
		Analytics.shared.event(.tapPrivacyPolicy())
		if let url = URL(string: "https://rddle.me/privacy") {
			UIApplication.shared.open(url)
		}
	}

	private func updatePrivacyTapped() {
		Analytics.shared.event(.tapUpdatePrivacy())
		showPrivacyForm = true
	}

	private func reportBugTapped() {
		Analytics.shared.event(.tapReportBug())
		if let url = URL(string: "mailto:bugs@rddle.me?subject=I%20have%20found%20a%20bug!") {
			UIApplication.shared.open(url)
		}
	}

	private func openDebugMenuTapped() {
		#if DEBUG
		showDebugMenu = true
		#endif
	}

	private func handlePrivacyComplete() {
		showPrivacyForm = false
	}

	private func handlePrivacyError(error: Error) {
		showPrivacyForm = false
		showPrivacyError = true
	}

}

// MARK: - SettingsView_Previews

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
	}
}
