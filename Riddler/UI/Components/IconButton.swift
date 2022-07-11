import SwiftUI

struct IconButton: View {
    let image: String
    let size: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .padding(10)
        }
    }
    
}

struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        IconButton(image: "back", size: 50, action: {})
    }
}
