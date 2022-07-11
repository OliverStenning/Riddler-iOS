import Foundation
import UserMessagingPlatform
import AppTrackingTransparency
import Firebase
import GoogleMobileAds

class ConsentManager {
    static let shared = ConsentManager()
    private init() {}
    
    var consentForm: UMPConsentForm? = nil
    var userConsentType = ConsentType.none
    
    var ConsentConfigured: Bool = false
    
    enum ConsentType {
        case full
        case partial
        case none
    }
    
    var completion: () -> Void = {}
    
    func startupConsent(completion: @escaping () -> Void) {
        
        self.completion = completion
        
        // Reset consent if flag set
        if TestVariables.RESET_CONSENT {
            UMPConsentInformation.sharedInstance.reset()
        }
        
        // Create parameter list for consent update
        let parameters = UMPRequestParameters()
        parameters.tagForUnderAgeOfConsent = false
        
        // Check if consent needs to be collected
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters, completionHandler: { updateError in
            if updateError != nil {
                // Consent is unknown therefore disable ads
                print("Consent request error")
                print(updateError ?? "")
                self.updateConsentResults(disableAds: true)
                
            } else {
                // Check if consent form is available
                let formStatus = UMPConsentInformation.sharedInstance.formStatus
                if formStatus == UMPFormStatus.available {
                    // Load consent form
                    self.loadConsentForm(andDisplay: true)
                    
                }
            }
        })
    }
    
    private func loadConsentForm(andDisplay: Bool) {
        // Load consent form
        UMPConsentForm.load(completionHandler: { form, loadError in
            if loadError != nil {
                // Unable to display consent form therefore disable ads
                print("Consent form error")
                print(loadError ?? "")
                self.updateConsentResults(disableAds: true)
                
            } else {
                // Store the consent form to be used
                print("Consent Form: Loaded")
                self.consentForm = form
                if andDisplay {
                    self.displayConsentForm(forceDisplay: false)
                }
            }
        })
    }
    
    func displayConsentForm(forceDisplay: Bool) {
        // Check if consent is required or form forced to display
        if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.required || forceDisplay {
            // Display consent form
            print("Consent Status: Required")
            self.consentForm?.present(from: UIApplication.shared.windows.first!.rootViewController! as UIViewController) { dismissError in
                if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.obtained {
                    // Detect which level on consent provided
                    print("Consent Status: Obtained")
                    self.updateConsentResults(disableAds: false)
                } else {
                    // Consent unknown therefore disable ads
                    print("Consent Status: Unknown")
                    self.updateConsentResults(disableAds: true)
                }
            }
            
        } else if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.obtained {
            print("Consent Status: Obtained")
            self.updateConsentResults(disableAds: false)
        } else if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.notRequired {
            print("Consent Status: Not Required")
            self.updateConsentResults(disableAds: false)
        } else if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.unknown {
            print("Consent Status: Unknown")
            self.updateConsentResults(disableAds: true)
        }
        
        // Load a new consent form in case form is shown again
        self.loadConsentForm(andDisplay: false)
    }
    
    // Sets the consent type to save whether consent given
    private func updateConsentResults(disableAds: Bool) {
        
        print("Start: Consent")
        
        ConsentConfigured = true
        
        // If ads are disabled no checks required
        if disableAds {
            self.userConsentType = ConsentType.none
        } else {
            // Check to see what type of ads can be shown with the users current consent values
            if self.canShowPersonalizedAds() {
                self.userConsentType = ConsentType.full
                print("Consent Type: Personalized")
            } else if self.canShowAds() {
                self.userConsentType = ConsentType.partial
                print("Consent Type: Non Personalized")
            } else {
                self.userConsentType = ConsentType.none
                print("Consent Type: None")
            }
        }
        
        // Check if Firebase is running
        if FirebaseApp.app() != nil {
            // Check if consent is still given
            if self.userConsentType != ConsentType.full || TestVariables.DISABLE_FIREBASE {
                // Delete any Firebase apps currently running
                FirebaseApp.app()?.delete({ _ in })
            }
        } else {
            if self.userConsentType == ConsentType.full && !TestVariables.DISABLE_FIREBASE {
                // Startup Firebase if permission is given and not already running
                print("Firebase started")
                FirebaseApp.configure()
            }
        }
        
        // Check if any consent given
        if self.userConsentType != ConsentType.none {
            // Startup Google Mobile Ads
            GADMobileAds.sharedInstance().start(completionHandler: nil)
            
            InterstitialAd.shared.clearAd()
            RewardedAd.shared.clearAd()
            
            InterstitialAd.shared.loadAd(withAdUnitID: interstitialId)
            RewardedAd.shared.loadAd(withAdUnitID: rewardedId)
            
        }
        
        completion()
        
    }
    
    // Check if non personalized ads can be shown
    private func canShowAds() -> Bool {
        let settings = UserDefaults.standard
        
        //https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/TCFv2/IAB%20Tech%20Lab%20-%20CMP%20API%20v2.md#in-app-details
        //https://support.google.com/admob/answer/9760862?hl=en&ref_topic=9756841
        
        let purposeConsent = settings.string(forKey: "IABTCF_PurposeConsents") ?? ""
        let vendorConsent = settings.string(forKey: "IABTCF_VendorConsents") ?? ""
        let vendorLI = settings.string(forKey: "IABTCF_VendorLegitimateInterests") ?? ""
        let purposeLI = settings.string(forKey: "IABTCF_PurposeLegitimateInterests") ?? ""
        
        let googleId = 755
        let hasGoogleVendorConsent = hasAttribute(input: vendorConsent, index: googleId)
        let hasGoogleVendorLI = hasAttribute(input: vendorLI, index: googleId)
        
        // Minimum required for at least non-personalized ads
        return hasConsentFor([1], purposeConsent, hasGoogleVendorConsent)
        && hasConsentOrLegitimateInterestFor([2,7,9,10], purposeConsent, purposeLI, hasGoogleVendorConsent, hasGoogleVendorLI)
        
    }
    
    // Check if personalized ads can be shown
    private func canShowPersonalizedAds() -> Bool {
        let settings = UserDefaults.standard
        
        //https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/TCFv2/IAB%20Tech%20Lab%20-%20CMP%20API%20v2.md#in-app-details
        //https://support.google.com/admob/answer/9760862?hl=en&ref_topic=9756841
        
        // required for personalized ads
        let purposeConsent = settings.string(forKey: "IABTCF_PurposeConsents") ?? ""
        let vendorConsent = settings.string(forKey: "IABTCF_VendorConsents") ?? ""
        let vendorLI = settings.string(forKey: "IABTCF_VendorLegitimateInterests") ?? ""
        let purposeLI = settings.string(forKey: "IABTCF_PurposeLegitimateInterests") ?? ""
        
        let googleId = 755
        let hasGoogleVendorConsent = hasAttribute(input: vendorConsent, index: googleId)
        let hasGoogleVendorLI = hasAttribute(input: vendorLI, index: googleId)
        
        if !hasAllowedATT() {
            return false
        } else {
            return hasConsentFor([1,3,4], purposeConsent, hasGoogleVendorConsent)
            && hasConsentOrLegitimateInterestFor([2,7,9,10], purposeConsent, purposeLI, hasGoogleVendorConsent, hasGoogleVendorLI)
        }
    }
    
    // Check if the user clicked allow on ATT
    private func hasAllowedATT() -> Bool {
        
        var allowed = false
        
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                allowed = true
            case .denied:
                allowed = false
            case .notDetermined:
                allowed = false
            case .restricted:
                allowed = false
            @unknown default:
                allowed = false
            }
        }
        return allowed
    }
    
    // Check if the user is in the EEA
    private func isGDPR() -> Bool {
        let settings = UserDefaults.standard
        let gdpr = settings.integer(forKey: "IABTCF_gdprApplies")
        return gdpr == 1
    }
    
    // Check if a binary string has a "1" at position "index" (1-based)
    private func hasAttribute(input: String, index: Int) -> Bool {
        return input.count >= index && String(Array(input)[index-1]) == "1"
    }
    
    // Check if consent is given for a list of purposes
    private func hasConsentFor(_ purposes: [Int], _ purposeConsent: String, _ hasVendorConsent: Bool) -> Bool {
        return purposes.allSatisfy { i in hasAttribute(input: purposeConsent, index: i) } && hasVendorConsent
    }
    
    // Check if a vendor either has consent or legitimate interest for a list of purposes
    private func hasConsentOrLegitimateInterestFor(_ purposes: [Int], _ purposeConsent: String, _ purposeLI: String, _ hasVendorConsent: Bool, _ hasVendorLI: Bool) -> Bool {
        return purposes.allSatisfy { i in
            (hasAttribute(input: purposeLI, index: i) && hasVendorLI) ||
            (hasAttribute(input: purposeConsent, index: i) && hasVendorConsent)
        }
    }
    
    
    
}
