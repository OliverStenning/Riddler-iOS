import SwiftUI

struct ToastModifier: ViewModifier {
    let image: String
    let text: String
    @Binding var isShowing: Bool
    let duration: TimeInterval
    let isError: Bool
    let customImage: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isShowing {
                toast
                    .zIndex(1)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation() {
                                isShowing.toggle()
                            }
                        }
                    }
            }
        }
    }
    
    private var toast: some View {
        VStack {
            Spacer()
            HStack(alignment: customImage ? .center : .lastTextBaseline, spacing: 20) {
                if image != "" {
                    if customImage {
                        Image(image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                    } else {
                        Image(systemName: image)
                            .font(.system(size: 25))
                    }
                }
                Text(text)
                    .modifier(ButtonTextStyle(textSize: 30))
            }
            .foregroundColor(isError ? Color("PrimaryDark") : Color("Accent"))
            .padding()
            .padding(.horizontal, 10)
            .background(isError ? Color("Error") : Color("Primary"))
            .cornerRadius(5)
            .shadow(radius: 15)
        }
        .padding(30)
        .padding(.bottom, 60)
    }
    
}

extension View {
    func toast(image: String, customImage: Bool = false, text: String, isShowing: Binding<Bool>, duration: TimeInterval = 2, isError: Bool = false) -> some View {
        modifier(ToastModifier(image: image, text: text, isShowing: isShowing, duration: duration, isError: isError, customImage: customImage))
    }
}
