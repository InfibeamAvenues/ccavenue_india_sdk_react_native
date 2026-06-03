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
        let encRequest = arguments["encRequest"] as? String ?? ""
        let appColor = arguments["appColor"] as? String ?? "#1F46BD"
        let fontColor = arguments["fontColor"] as? String ?? "#FFFFFF"
        let paymentEnvironment = arguments["paymentEnvironment"] as? String ?? "production"
     
        let ccAvenueOrder = CCAvenueOrder(
            accessCode: accessCode,
            encRequest: encRequest, 
            paymentEnvironment: paymentEnvironment, 
            appColor: appColor,
            fontColor: fontColor
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