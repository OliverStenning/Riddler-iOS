import Foundation

func timeDifference(startTime: Date, endTime: Date) -> Int {
    let timeDifference = Calendar.current.dateComponents([.second], from: startTime, to: endTime)
    return timeDifference.second ?? 0
}

func timeDifferenceString(startTime: Date, endTime: Date) -> String {
    var timeString = ""
    var timeArray: [String] = []
    
    let timeDifference = Calendar.current.dateComponents([.year, .day, .hour, .minute, .second], from: startTime, to: endTime)
    
    let years = timeDifference.year ?? 0
    let days = timeDifference.day ?? 0
    let hours = timeDifference.hour ?? 0
    let minutes = timeDifference.minute ?? 0
    let seconds = timeDifference.second ?? 0
    
    if years > 0 {
        if years == 1 {
            timeArray.append("\(years) year")
        } else {
            timeArray.append("\(years) years")
        }
    }
    
    if days > 0 {
        if days == 1 {
            timeArray.append("\(days) day")
        } else {
            timeArray.append("\(days) days")
        }
    }
    
    if hours > 0 {
        if hours == 1 {
            timeArray.append("\(hours) hr")
        } else {
            timeArray.append("\(hours) hrs")
        }
    }
    
    if minutes > 0 {
        timeArray.append("\(minutes) min")
    }
    
    if seconds > 0 {
        timeArray.append("\(seconds) sec")
    }
    
    while timeArray.count > 2 {
        timeArray.removeLast()
    }
    
    timeString = timeArray.joined(separator: ", ")
    
    if timeString == "" {
        timeString = "1 sec"
    }
    
    return timeString
}
