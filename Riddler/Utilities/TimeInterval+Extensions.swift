import Foundation

public extension TimeInterval {

	static func minutes(_ numberOfMinutes: Double) -> TimeInterval {
		numberOfMinutes * 60
	}

	static func hours(_ numberOfHours: Double) -> TimeInterval {
		numberOfHours * minutes(60)
	}

	static func days(_ numberOfDays: Double) -> TimeInterval {
		numberOfDays * hours(24)
	}

	static func weeks(_ numberOfWeeks: Double) -> TimeInterval {
		numberOfWeeks * days(7)
	}

}
