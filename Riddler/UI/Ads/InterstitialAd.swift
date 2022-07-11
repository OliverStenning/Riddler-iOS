import SwiftUI
import GoogleMobileAds
import Firebase
import FirebaseAnalytics

class InterstitialAd: NSObject {
    var interstitialAd: GADInterstitialAd?
    
    static let shared = InterstitialAd()
    
    func loadAd(withAdUnitID id: String) {
        let req = GADRequest()
        GADInterstitialAd.load(withAdUnitID: id, request: req) { interstitialAd, err in
            if let err = err {
                print("Failed to load ad with error: \(err)")
                
                return
            }
            print("Ad loaded")
            interstitialLoadedEvent()
            self.interstitialAd = interstitialAd
        }
    }
    
    func clearAd() {
        interstitialAd = nil
    }
    
}

final class InterstitialAdView: NSObject, UIViewControllerRepresentable, GADFullScreenContentDelegate {
    
    let interstitialAd = InterstitialAd.shared.interstitialAd
    @Binding var isPresented: Bool
    var adUnitId: String
    
    init(isPresented: Binding<Bool>, adUnitId: String) {
        self._isPresented = isPresented
        self.adUnitId = adUnitId
        super.init()
        
        interstitialAd?.fullScreenContentDelegate = self
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = UIViewController()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
            self.showAd(from: view)
        }
        
        return view
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func showAd(from root: UIViewController) {
        if let ad = interstitialAd {
            ad.present(fromRootViewController: root)
        } else {
            print("Ad not ready")
            interstitialNotReadyEvent()
            self.isPresented.toggle()
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        // Prepare another ad for the next time the view is presented
        InterstitialAd.shared.loadAd(withAdUnitID: adUnitId)
        
        // Dismisses the view once ad dismissed
        isPresented.toggle()
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad failed to display")
        InterstitialAd.shared.loadAd(withAdUnitID: adUnitId)
        isPresented = false
        interstitialFailedToShow(error: error)
    }

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad displaying")
        interstitialShownEvent()
    }
    
}
