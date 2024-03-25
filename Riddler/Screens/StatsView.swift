import SwiftUI

// MARK: - StatsView

struct StatsView: View {

	var stats: [DisplayStat]

	var body: some View {
		VStack(spacing: 32) {
			Spacer()
			Text("Your Stats")
				.font(RKFonts.Abel.regular.swiftUIFont(fixedSize: 50))
				.foregroundStyle(RKColors.primaryDark.swiftUIColor)

			Spacer()

			VStack(spacing: 12) {
				ForEach(stats, id: \.name) { stat in
					StatItem(stat: stat)
				}
			}
			Spacer()
		}
		.padding(.horizontal, 32)
		.padding(.vertical, 32)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(RKBackground(isDark: false))
		.analyticsScreen(.stats())
	}
}

// MARK: - StatItem

struct StatItem: View {
	let stat: DisplayStat

	var body: some View {
		HStack {
			Text(stat.name)
			Spacer()
			Text(stat.value)
		}
		.font(RKFonts.Abel.regular.swiftUIFont(fixedSize: 24))
		.foregroundStyle(RKColors.primaryDark.swiftUIColor)
	}
}

// MARK: - StatsView_Previews

struct StatsView_Previews: PreviewProvider {

	static let stats: [DisplayStat] = [
		.init(name: "Quickest time:", value: "1 min, 23 sec"),
		.init(name: "Slowest time:", value: "3 hr, 23 min")
	]

	static var previews: some View {
		StatsView(stats: stats)
	}
}
