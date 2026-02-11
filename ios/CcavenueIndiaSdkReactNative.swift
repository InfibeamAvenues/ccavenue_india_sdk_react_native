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
  private var navigationController: UINavigationController?

  @objc(payCCAvenue:resolve:reject:)
  public func payCCAvenue(_ arguments: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
      self.resolve = resolve
      self.reject = reject
      
      initiateCCAvenueSDK(arguments: arguments)
  }
    
    private func initiateCCAvenueSDK(arguments: [String: Any]) {
        print("CCAvenue iOS: Received arguments: \(arguments)")
        
        // 1. Extract Main Parameters
        let accessCode = arguments["accessCode"] as? String ?? ""
        let currency = arguments["currency"] as? String ?? "INR"
        let amount = arguments["amount"] as? String ?? ""
        let trackingId = arguments["trackingId"] as? String ?? ""
        let requestHash = arguments["requestHash"] as? String ?? ""

        // 2. Extract Optional Parameters
        let customerId = arguments["customer_id"] as? String ?? ""
        let paymentType = arguments["payment_type"] as? String ?? "all"
        
   
        
        var ignorePaymentType = ""
        if let ignoreStr = arguments["ignore_payment_type"] as? String {
       
             ignorePaymentType = ignoreStr
        } else if let ignoreList = arguments["ignore_payment_type"] as? [String] {
             ignorePaymentType = ignoreList.joined(separator: "|")
        }

        let displayPromo = arguments["display_promo"] as? String ?? "yes"
        let promoCode = arguments["promo_code"] as? String ?? ""
        let promoSkuCode = arguments["promo_sku_code"] as? String ?? ""
        
        let appColor = arguments["app_color"] as? String ?? "#1F46BD"
        let fontColor = arguments["font_color"] as? String ?? "#FFFFFF"
        
        // 3. Environment: "qa", "uat", "production"
        let envString = arguments["payment_environment"] as? String ?? "production"
        let paymentEnvironment = envString

        // 4. Display Dialog: "yes", "no"
        let displayDialog = arguments["displayDialog"] as? String ?? "no"

        // 4. Handle SIInfo Struct
        var siInfoObj: SIInfo? = nil
        if let siData = arguments["si_info"] as? [String: Any] {
            siInfoObj = SIInfo(
                siType: siData["si_type"] as? String,
                siAmount: siData["si_amount"] as? String,
                siMerchantRefNo: siData["si_merchant_ref_no"] as? String,
                siSetupAmount: siData["si_setup_amount"] as? String,
                siBillCycle: siData["si_bill_cycle"] as? String,
                siFrequencyType: siData["si_frequency_type"] as? String,
                siFrequencyNo: siData["si_frequency"] as? String,
                siStartDate: siData["si_start_date"] as? String,
                siEndDate: siData["si_end_date"] as? String,
                siUPIMandate: siData["si_upi_mandate"] as? String,
                siUPIDebitRule: siData["si_upi_debit_rule"] as? String
            )
        }

        // 5. Initialize the Order object
        let ccAvenueOrder = CCAvenueOrder(
            accessCode: accessCode,
            currency: currency,
            amount: amount,
            trackingId: trackingId,
            requestHash: requestHash,
            paymentEnvironment: paymentEnvironment, 
            paymentType: paymentType,
            ignorePaymentType: ignorePaymentType,
            customerId: customerId,
            displayPromo: displayPromo,
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
            
            let avenueVC = CCAvenueViewController(ccAvenueOrder: ccAvenueOrder, andDelegate: self)
            
            // If the app uses a Nav controller, push it; otherwise, present it
            if let nav = rootViewController as? UINavigationController {
                self.navigationController = nav
                nav.pushViewController(avenueVC, animated: true)
            } else {
                let navWrapper = UINavigationController(rootViewController: avenueVC)
                navWrapper.modalPresentationStyle = .overFullScreen
                navWrapper.view.backgroundColor = .clear
                // Ensure the navigation bar is also transparent if the SDK doesn't style it
                navWrapper.navigationBar.setBackgroundImage(UIImage(), for: .default)
                navWrapper.navigationBar.shadowImage = UIImage()
                navWrapper.navigationBar.isTranslucent = true
                navWrapper.view.isOpaque = false
                
                rootViewController.present(navWrapper, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - CCAvenueDelegate
    public func onTransactionResponse(_ jsonResponse: [AnyHashable : Any]?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Close the SDK View
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
                self.navigationController = nil
            } else {
                 if let window = UIApplication.shared.delegate?.window, 
                   let rootViewController = window?.rootViewController {
                    rootViewController.dismiss(animated: true, completion: nil)
                }
            }
            
            // Send raw JSON string back to React Native
            if let responseData = jsonResponse,
               let jsonData = try? JSONSerialization.data(withJSONObject: responseData, options: []),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                self.resolve?(jsonString)
            } else {
                self.resolve?("No response or parsing failed")
            }
            
            self.resolve = nil
            self.reject = nil
        }
    }
}