import SwiftUI

struct BasicDialog: View {
    
    var titleText: String
    var bodyText: String
    
    var primaryText: String
    var secondaryText: String
    
    var primaryAction: () -> Void
    var secondaryAction: () -> Void
    
    var body: some View {
        ZStack {
            // Darken background
            Color.black
                .edgesIgnoringSafeArea(.all)
                .opacity(0.8)
            
            // Dialog box
            VStack(spacing: 20) {
                Text(titleText)
                    .modifier(AccentTextStyle(textSize: 30))
                    .multilineTextAlignment(.center)
                
                Text(bodyText)
                    .modifier(AccentTextStyle(textSize: 20))
                    .multilineTextAlignment(.center)
                    
                                        
                HStack(spacing: 24) {
                    Button(action: secondaryAction) {
                        Text(secondaryText)
                            .padding(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10))
                            .frame(width: 125)
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    .modifier(ButtonTextStyle(textSize: 30))
                    
                    Button(action: primaryAction) {
                        Text(primaryText)
                            .padding(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10))
                            .frame(width: 125)
                    }
                    .buttonStyle(AccentButtonStyle(disabled: false))
                    .modifier(ButtonTextStyle(textSize: 30))
                }
            }
            .padding(20)
            .background(Color("Primary"))
            .cornerRadius(5)
        }
        .zIndex(1)
    }
}

struct BasicDialog_Previews: PreviewProvider {
    static var previews: some View {
        BasicDialog(titleText: "Need some help?", bodyText: "Watch a video to unlock 3 more hints", primaryText: "Watch", secondaryText: "Close", primaryAction: {}, secondaryAction: {})
    }
}
