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

  @objc(payCCAvenue:resolve:reject:)
  public func payCCAvenue(_ arguments: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
      self.resolve = resolve
      self.reject = reject
      
      initiateCCAvenueSDK(arguments: arguments)
  }
    
    private func initiateCCAvenueSDK(arguments: [String: Any]) {
        print("CCAvenue iOS: Received arguments: \(arguments)")
        
        // 1. Core Parameters
        let accessCode = arguments["accessCode"] as? String ?? ""
        let currency = arguments["currency"] as? String ?? "INR"
        let amount = arguments["amount"] as? String ?? ""
        let trackingId = arguments["trackingId"] as? String ?? ""
        let requestHash = arguments["requestHash"] as? String ?? ""
        
        // 2. Logic & Optional Parameters
        let customerId = arguments["customerId"] as? String ?? ""
        let paymentType = arguments["paymentType"] as? String ?? "all"
        let ignorePaymentType = arguments["ignorePaymentOption"] as? String ?? ""
        let promoCode = arguments["promoCode"] as? String ?? ""
        let promoSkuCode = arguments["promoSkuCode"] as? String ?? ""
        let shouldDisplayPromo = arguments["displayPromo"] as? Bool ?? true
        
        // 3. UI & Environment
        let appColor = arguments["appColor"] as? String ?? "#1F46BD"
        let fontColor = arguments["fontColor"] as? String ?? "#FFFFFF"
        
        // Enum Mapping: Environment
        let envString = (arguments["environment"] as? String ?? "LIVE").uppercased()
        let paymentEnvironment: Enviroment = (envString == "LOCAL") ? .LOCAL : (envString == "STAGING" ? .STAGING : .LIVE)
        
        // Enum Mapping: Display Dialog
        let dialogString = (arguments["displayDialog"] as? String ?? "FULL").uppercased()
        let displayDialog: DisplayDialog = (dialogString == "DIALOG") ? .DIALOG : .FULL
        
        // 4. Handle Nested SIInfo Struct
        var siInfoObj: SIInfo? = nil
        if let siData = arguments["siInfo"] as? [String: Any] {
            siInfoObj = SIInfo(
                siStartDate: siData["si_start_date"] as? String,
                siEndDate: siData["si_end_date"] as? String,
                siType: siData["si_type"] as? String,
                siAmount: siData["si_amount"] as? String,
                siMerchantRefNo: siData["si_merchant_ref_no"] as? String,
                siSetupAmount: siData["si_setup_amount"] as? String,
                siBillCycle: siData["si_bill_cycle"] as? String,
                siFrequency: siData["si_frequency"] as? String,
                siFrequencyType: siData["si_frequency_type"] as? String,
                siUPIMandate: siData["si_upi_mandate"] as? String,
                siUPIDebitRule: siData["si_upi_debit_rule"] as? String
            )
        }
        
        // 5. Create SDK Model
        let model = CCAvenueOrder(
            accessCode: accessCode,
            currency: currency,
            amount: amount,
            trackingId: trackingId,
            requestHash: requestHash,
            paymentEnviroment: paymentEnvironment, // Matches SDK spelling
            paymentType: paymentType,
            ignorePaymentType: ignorePaymentType,
            customerId: customerId,
            displayPromo: shouldDisplayPromo,
            promoCode: promoCode,
            promoSkuCode: promoSkuCode,
            siInfo: siInfoObj,
            appColor: appColor,
            fontColor: fontColor,
            displayDialog: displayDialog
        )
        
        // 6. Presentation Logic
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.delegate?.window else { return }
            guard let rootViewController = window?.rootViewController else { return }
            
            var topController = rootViewController
            while let presented = topController.presentedViewController {
                topController = presented
            }

            let avenueVC = CCAvenueViewController(ccAvenueOrder: model, andDelegate: self)
            let navWrapper = UINavigationController(rootViewController: avenueVC)
            navWrapper.modalPresentationStyle = .fullScreen
            topController.present(navWrapper, animated: true, completion: nil)
        }
    }
    
    // MARK: - CCAvenueDelegate
    public func onTransactionResponse(_ jsonResponse: [AnyHashable : Any]?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Dismiss the SDK View Controller
            if let window = UIApplication.shared.delegate?.window, 
               let rootViewController = window?.rootViewController {
                var topController = rootViewController
                while let presented = topController.presentedViewController {
                    if let nav = presented as? UINavigationController,
                       nav.viewControllers.first is CCAvenueViewController {
                        presented.dismiss(animated: true, completion: nil)
                        break
                    }
                    topController = presented
                }
            }
            
            // Return Response to React Native Promise
            if let responseData = jsonResponse,
               let jsonData = try? JSONSerialization.data(withJSONObject: responseData, options: []),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                self.resolve?(jsonString)
            } else {
                self.resolve?("{}")
            }
            
            self.resolve = nil
            self.reject = nil
        }
    }
}