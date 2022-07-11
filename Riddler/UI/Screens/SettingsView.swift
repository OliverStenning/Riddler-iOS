import SwiftUI

struct SettingsView: View {
    
    @Binding var mainScreen: String?
    
    var body: some View {
        
        ZStack {
            Background(isDark: true)
            BackButton(pressBack: pressBack)
                .buttonStyle(AccentButtonStyle())
            
            VStack {
                Spacer()
                Text("Settings")
                    .modifier(AccentTextStyle(textSize: 60))
                    .padding(40)
                
                Spacer()
                VStack(spacing: 20) {
                    SettingsItem(labelText: "Privacy Settings", buttonText: "Update",
                                 pressAction: pressPrivacySettings)
                    SettingsItem(labelText: "Privacy Policy", buttonText: "Read",
                                 pressAction: pressPrivacyPolicy)
                    SettingsItem(labelText: "Found a bug?", buttonText: "Report",
                                 pressAction: pressBugReport)
                }
                .padding(.horizontal, 20)
                Spacer()
            }
            .padding(20)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    struct SettingsItem: View {
        let labelText: String
        let buttonText: String
        let pressAction: () -> Void
        
        var body: some View {
            HStack {
                Text(labelText)
                    .modifier(AccentTextStyle(textSize: 25))
                Spacer()
                Button(action: pressAction) {
                    Text(buttonText)
                        .frame(width: 100, height: 40)
                }
                    .buttonStyle(AccentButtonStyle())
                    .modifier(ButtonTextStyle(textSize: 25))
            }
        }
    }
    
    
    // Button functions
    
    func pressBack() {
        mainScreen = nil
    }
    
    func pressPrivacySettings() {
        // Display consent form
        ConsentManager.shared.displayConsentForm(forceDisplay: true)
    }
    
    func pressPrivacyPolicy() {
        if let url = URL(string: "https://rddle.me/privacy") {
            UIApplication.shared.open(url)
        }
    }
    
    func pressBugReport() {
        if let url = URL(string: "mailto:bugs@rddle.me?subject=I%20have%20found%20a%20bug!") {
            UIApplication.shared.open(url)
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(mainScreen: .constant("Settings"))
    }
}
