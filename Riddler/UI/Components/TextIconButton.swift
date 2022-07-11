import SwiftUI

struct TextIconButton: View {
    var text: String
    var image: String
    var iconSize: CGFloat
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center) {
                Text(text)
                    .padding(.trailing, 4)
                Image(image)
                    .resizable()
                    .frame(width: iconSize, height: iconSize)
            }
            .frame(width: 160, height: 50)
        }
    }
}

struct TextIconButton_Previews: PreviewProvider {
    static var previews: some View {
        TextIconButton(text: "Stats", image: "stats", iconSize: 28, action: {})
    }
}
