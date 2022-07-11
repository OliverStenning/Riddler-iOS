import Foundation
import SwiftUI

struct ButtonTextStyle: ViewModifier {
    var textSize: CGFloat
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Teko-Regular", size: textSize))
    }
}

struct ContentTextStyle: ViewModifier {
    var textSize: CGFloat
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Abel-Regular", size: textSize))
    }
}

struct PrimaryTextStyle: ViewModifier {
    var textSize: CGFloat
    func body(content: Content) -> some View {
        content
            .modifier(ContentTextStyle(textSize: textSize))
            .foregroundColor(Color("PrimaryDark"))
    }
}

struct SecondaryTextStyle: ViewModifier {
    var textSize: CGFloat
    func body(content: Content) -> some View {
        content
            .modifier(ContentTextStyle(textSize: textSize))
            .foregroundColor(Color("Secondary"))
    }
}

struct AccentTextStyle: ViewModifier {
    var textSize: CGFloat
    func body(content: Content) -> some View {
        content
            .modifier(ContentTextStyle(textSize: textSize))
            .foregroundColor(Color("Accent"))
    }
}

struct MultilineTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.2)
    }
}

struct AccentTextFieldStyle: ViewModifier {
    var textSize: CGFloat
    func body(content: Content) -> some View {
        content
            .modifier(ContentTextStyle(textSize: textSize))
            .padding(6)
            .foregroundColor(Color("AccentDark"))
            .accentColor(Color("AccentDark"))
            .background(Color("PrimaryDark"))
            .cornerRadius(5)
    }
}
