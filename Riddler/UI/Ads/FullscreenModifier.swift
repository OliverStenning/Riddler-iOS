import SwiftUI

struct FullScreenAd<Parent: View>: View {
    
    @Binding var isPresented: Bool
    @Binding var isErrorShowing: Bool
    @State var adType: AdType
    
    enum AdType {
        case interstitial
        case rewarded
    }
    
    var rewardFunc: () -> Void
    var adUnitId: String
    var parent: Parent
    
    var body: some View {
        ZStack {
            parent
            
            if isPresented {
                EmptyView()
                    .edgesIgnoringSafeArea(.all)
                
                if adType == .rewarded {
                    RewardedAdView(isPresented: $isPresented, isErrorShowing: $isErrorShowing, adUnitId: adUnitId, rewardFunc: rewardFunc)
                        .edgesIgnoringSafeArea(.all)
                } else if adType == .interstitial {
                    InterstitialAdView(isPresented: $isPresented, adUnitId: adUnitId)
                }
            }
        }
        .onAppear {
            if adType == .rewarded {
                RewardedAd.shared.loadAd(withAdUnitID: adUnitId)
            } else if adType == .interstitial {
                InterstitialAd.shared.loadAd(withAdUnitID: adUnitId)
            }
        }
    }
    
}

extension View {
    func presentRewardedAd(isPresented: Binding<Bool>, isErrorShowing: Binding<Bool>, adUnitId: String, rewardFunc: @escaping (() -> Void), game: GameViewModel) -> some View {
        FullScreenAd(isPresented: isPresented, isErrorShowing: isErrorShowing, adType: .rewarded, rewardFunc: rewardFunc, adUnitId: adUnitId, parent: self)
            .environmentObject(game)
    }
    
    func presentInterstitialAd(isPresented: Binding<Bool>, adUnitId: String) -> some View {
        FullScreenAd(isPresented: isPresented, isErrorShowing: .constant(false), adType: .interstitial, rewardFunc: {}, adUnitId: adUnitId, parent: self)
    }
}
