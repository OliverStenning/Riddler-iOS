import SwiftUI

struct BackButton: View {
    var pressBack: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                IconButton(image: "back", size: 32, action: pressBack)
                Spacer()
            }
            Spacer()
        }
        .padding(20)
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton(pressBack: {})
    }
}



