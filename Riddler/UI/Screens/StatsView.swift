import SwiftUI

struct StatsView: View {
    
    let statNames: [String] = [
        "Total time:",
        "Quickest time:",
        "Slowest time:",
        "Total guesses:",
        "Correct first guesses:",
        "Most incorrect guesses:",
        "Hints used:",
        "Correct without hints:"
    ]
    
    var statValues: [String]
    
    var body: some View {
        ZStack {
            Background(isDark: false)
        
            VStack {
                Spacer()
                Text("Stats")
                    .modifier(PrimaryTextStyle(textSize: 60))
                    .padding(40)
                
                Spacer()
                VStack(spacing: 12) {
                    ForEach((0..<statNames.count), id: \.self) { x in
                        StatItem(name: statNames[x], value: statValues[x])
                    }
                }
                .padding(.horizontal, 36)
                
                Spacer()
            }
            
        }
    }
    
}

struct StatItem: View {
    
    let textSize: CGFloat = 24
    
    let name: String
    let value: String
    
    var body: some View {
        HStack() {
            Text(name)
                .modifier(PrimaryTextStyle(textSize: textSize))
            Spacer()
            Text(value)
                .modifier(PrimaryTextStyle(textSize: textSize))
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        let statValues: [String] = [ "5 days, 3 hours", "1 min, 23 sec", "3 days, 2 hours", "246", "43", "13", "39", "26" ]
        StatsView(statValues: statValues)
    }
}
