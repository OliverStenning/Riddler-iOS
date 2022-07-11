import SwiftUI

struct Background: View {
    var isDark: Bool
    
    var body: some View {
        ZStack {
            Color(isDark ? "Primary" : "Accent").ignoresSafeArea()
            Image(isDark ? "bg_primary" : "bg_accent")
                .resizable()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct Background_Previews: PreviewProvider {
    static var previews: some View {
        Background(isDark: true)
        Background(isDark: false)
    }
}
