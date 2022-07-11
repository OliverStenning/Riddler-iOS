import SwiftUI

struct AdFailedDialog: View {
    
    var privacyAction: () -> Void
    var closeAction: () -> Void
    
    var body: some View {
        ZStack {
            // Darken background
            Color.black
                .edgesIgnoringSafeArea(.all)
                .opacity(0.8)
            
            // Dialog box
            
            VStack(spacing: 25) {
                
                Text("Ad Failed to Load")
                    .modifier(AccentTextStyle(textSize: 30))
                    .multilineTextAlignment(.center)
                
                Group {
                    Text("Check your internet connection. Update your ")
                    + Text("privacy settings").foregroundColor(Color("Accent"))
                    + Text(" to allow ads.")
                }
                .modifier(SecondaryTextStyle(textSize: 20))
                .multilineTextAlignment(.center)
                .onTapGesture(perform: privacyAction)

                
                Button(action: closeAction) {
                    Text("Close")
                        .padding(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10))
                        .frame(width: 125)
                }
                .buttonStyle(SecondaryButtonStyle())
                .modifier(ButtonTextStyle(textSize: 30))
            }
            .padding(20)
            .background(Color("Primary"))
            .cornerRadius(5)
        }
        .zIndex(1)
    }
}

struct AdFailedDialog_Previews: PreviewProvider {
    static var previews: some View {
        AdFailedDialog(privacyAction: {}, closeAction: {})
    }
}
