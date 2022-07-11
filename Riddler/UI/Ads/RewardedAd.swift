import SwiftUI
import GoogleMobileAds
import Firebase
import FirebaseAnalytics

class RewardedAd: NSObject {
    var rewardedAd: GADRewardedAd?
    
    static let shared = RewardedAd()
    
    func loadAd(withAdUnitID id: String) {
        let req = GADRequest()
        GADRewardedAd.load(withAdUnitID: id, request: req) { rewardedAd, error in
            if let error = error {
                print("Failed to load ad with error: \(error)")
                rewardedFailedToLoad(error: error)
                return
            }
            rewardedLoadedEvent()
            self.rewardedAd = rewardedAd
        }
    }
    
    func clearAd() {
        rewardedAd = nil
    }

}

final class RewardedAdView: NSObject, UIViewControllerRepresentable, GADFullScreenContentDelegate {
    
    let rewardedAd = RewardedAd.shared.rewardedAd
    @Binding var isPresented: Bool
    @Binding var isErrorShowing: Bool
    let adUnitId: String
    let rewardFunc: (() -> Void)
    
    init(isPresented: Binding<Bool>, isErrorShowing: Binding<Bool>, adUnitId: String, rewardFunc: @escaping (() -> Void)) {
        self._isPresented = isPresented
        self._isErrorShowing = isErrorShowing
        self.adUnitId = adUnitId
        self.rewardFunc = rewardFunc
        
        super.init()
        
        rewardedAd?.fullScreenContentDelegate = self
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = UIViewController()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
            self.showAd(from: view)
        }
        
        return view
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func showAd(from root: UIViewController) {
        if let ad = rewardedAd {
            ad.present(fromRootViewController: root) {
                self.rewardFunc()
            }
        } else {
            print("Ad not ready")
            rewardedNotReadyEvent()
            self.isPresented = false
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad finished displaying")
        RewardedAd.shared.loadAd(withAdUnitID: adUnitId)
        isPresented = false
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad failed to display")
        RewardedAd.shared.loadAd(withAdUnitID: adUnitId)
        rewardedFailedToShow(error: error)
        isPresented = false
        withAnimation {
            isErrorShowing = true
        }
        
    }

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad displaying")
        rewardedShownEvent()
    }
    
}
