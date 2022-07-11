import Foundation
import SwiftUI

struct AccentButtonStyle: ButtonStyle {
    var disabled: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(disabled ? Color("Disabled") : (configuration.isPressed ? Color("AccentDark") : Color("Accent")))
            .foregroundColor(Color("PrimaryDark"))
            .cornerRadius(5)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var disabled: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(disabled ? Color("Disabled") : (configuration.isPressed ? Color("PrimaryDark") : Color("Primary")))
            .foregroundColor(Color("Accent"))
            .cornerRadius(5)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    var disabled: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(disabled ? Color("Disabled") : (configuration.isPressed ? Color("SecondaryDark") : Color("Secondary")))
            .foregroundColor(Color("PrimaryDark"))
            .cornerRadius(5)
    }
}
