
import Foundation
import React
import CCAvenueIndiaSDK

@objc(CcavenueIndiaSdkReactNative)
public class CcavenueIndiaSdkReactNative: NSObject, RCTBridgeModule, CCAvenueDelegate {
  
  public static func moduleName() -> String! {
    return "CCAvenueModule"
  }
  
  public static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  var resolve: RCTPromiseResolveBlock?
  var reject: RCTPromiseRejectBlock?
  var navigationController: UINavigationController?

  @objc(payCCAvenue:resolve:reject:)
  public func payCCAvenue(_ arguments: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
      self.resolve = resolve
      self.reject = reject
      
      initiateCCAvenueSDK(arguments: arguments)
  }
    
    private func initiateCCAvenueSDK(arguments: [String: Any]) {
        print("CCAvenue iOS: Received arguments: \(arguments)")
        
        // 1. Extract Parameters
        let accessCode = arguments["accessCode"] as? String ?? ""
        let currency = arguments["currency"] as? String ?? "INR"
        let amount = arguments["amount"] as? String ?? ""
        let trackingId = arguments["trackingId"] as? String ?? ""
        let requestHash = arguments["requestHash"] as? String ?? ""
        
        // Optional
        let customerId = arguments["customerId"] as? String ?? ""
        let paymentType = arguments["paymentType"] as? String ?? "all"
        let ignorePaymentType = arguments["ignorePaymentOption"] as? String ?? ""
        
        let shouldDisplayPromo = arguments["displayPromo"] as? Bool ?? true
        
        let appColor = arguments["appColor"] as? String ?? "#1F46BD"
        let fontColor = arguments["fontColor"] as? String ?? "#FFFFFF"
        
        // 2. Map Environment
        let envString = (arguments["environment"] as? String ?? "LIVE").uppercased()
        var paymentEnvironment: Enviroment = .LIVE
        
        if envString == "LOCAL" || envString == "APP_LOCAL" {
            paymentEnvironment = .LOCAL
        } else if envString == "STAGING" || envString == "TEST" {
            paymentEnvironment = .STAGING
        }
        
        // 3. Create Model
        let model = CCAvenueOrder(
            accessCode: accessCode,
            currency: currency,
            amount: amount,
            trackingId: trackingId,
            requestHash: requestHash,
            paymentEnviroment: paymentEnvironment,
            paymentType: paymentType,
            ignorePaymentType: ignorePaymentType,
            customerId: customerId,
            displayPromo: shouldDisplayPromo,
            promoCode: "", 
            promoSkuCode: "", 
            siInfo: nil,
            appColor: appColor,
            fontColor: fontColor,
            displayDialog: .FULL
        )
        
        // 4. Present the Payment Controller
        DispatchQueue.main.async {
            guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return }
            
            // Handle nested presented ViewControllers to find the top-most one
            var topController = rootViewController
            while let presented = topController.presentedViewController {
                topController = presented
            }

            let avenueVC = CCAvenueViewController(ccAvenueOrder: model, andDelegate: self)
            
            // If the top controller is a generic UIViewController, we might need to wrap in NavController
            // The SDK often expects to be pushed or presented.
            
            let navWrapper = UINavigationController(rootViewController: avenueVC)
            navWrapper.modalPresentationStyle = .fullScreen
            topController.present(navWrapper, animated: true, completion: nil)
        }
    }
    
    // MARK: - CCAvenueDelegate
    public func onTransactionResponse(_ jsonResponse: [AnyHashable : Any]?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Close the SDK View
            // We presented it on the top-most controller, so we dismiss it.
             if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                var topController = rootViewController
                while let presented = topController.presentedViewController {
                    if let nav = presented as? UINavigationController,
                       nav.viewControllers.first is CCAvenueViewController {
                        // This is our guy
                        presented.dismiss(animated: true, completion: nil)
                        break
                    }
                    topController = presented
                }
            }
            
            // Send raw JSON string back to React Native
            if let responseData = jsonResponse {
                if let jsonData = try? JSONSerialization.data(withJSONObject: responseData, options: []),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    self.resolve?(jsonString)
                } else {
                    self.resolve?("{}")
                }
            } else {
                self.resolve?("{}")
            }
            
            self.resolve = nil
            self.reject = nil
        }
    }
}
