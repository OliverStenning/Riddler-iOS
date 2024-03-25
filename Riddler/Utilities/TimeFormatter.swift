import Foundation

enum TimeFormatter {

	// MARK: Internal

	static func timeDifference(from startTime: Date, to endTime: Date) -> String {
		let timeDifference = Calendar.current.dateComponents([.year, .day, .hour, .minute, .second], from: startTime, to: endTime)

		let components: [String?] = [
			format(unitValue: timeDifference.year ?? 0, unitName: "year"),
			format(unitValue: timeDifference.day ?? 0, unitName: "day"),
			format(unitValue: timeDifference.hour ?? 0, unitName: "hr"),
			format(unitValue: timeDifference.minute ?? 0, unitName: "min"),
			format(unitValue: timeDifference.second ?? 0, unitName: "sec")
		]

		let timeArray = components.compactMap { $0 }.prefix(2)
		let timeString = timeArray.joined(separator: ", ")
		return timeString.isEmpty ? "0 sec" : timeString
	}

	// MARK: Private

	private static func format(unitValue: Int, unitName: String) -> String? {
		guard unitValue != 0 else { return nil }
		return "\(unitValue) \(unitName)\(unitValue == 1 ? "" : "s")"
	}

}
