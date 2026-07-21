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
  private var snapshotView: UIView?

  @objc(payCCAvenue:resolve:reject:)
  public func payCCAvenue(_ arguments: [String: Any], resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
      self.resolve = resolve
      self.reject = reject
      
      initiateCCAvenueSDK(arguments: arguments)
  }
    
    private func initiateCCAvenueSDK(arguments: [String: Any]) {
        let accessCode         = arguments["accessCode"]          as? String ?? ""
        let encRequest         = arguments["encRequest"]          as? String ?? ""
        let appColor           = arguments["appColor"]           as? String ?? "#1F46BD"
        let fontColor          = arguments["fontColor"]          as? String ?? "#FFFFFF"
        let paymentEnvironment = arguments["paymentEnvironment"] as? String ?? "production"
        let encryptionMode     = arguments["encryptionMode"]     as? String ?? ""
 
        guard !accessCode.isEmpty, !encRequest.isEmpty else {
            self.reject?("INVALID_PARAMS", "empty params", nil)
            self.resolve = nil
            self.reject = nil
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            
            let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.keyWindow
            guard let rootVC = window?.rootViewController else { return }

            NSLog("🚀 About to call CCAvenueOrder init...")

            let model = CCAvenueOrder(
                accessCode: accessCode,
                encRequest: encRequest,
                paymentEnvironment: paymentEnvironment,
                appColor: appColor,
                fontColor: fontColor,
                encryptionMode:encryptionMode,
            )

            NSLog("✅ CCAvenueOrder created successfully")

            // Take screenshot
            let renderer = UIGraphicsImageRenderer(bounds: rootVC.view.bounds)
            let screenshot = renderer.image { ctx in
                rootVC.view.drawHierarchy(in: rootVC.view.bounds, afterScreenUpdates: false)
            }
            let snapshot = UIImageView(image: screenshot)
            snapshot.frame = window?.bounds ?? .zero
            snapshot.contentMode = .scaleAspectFill
            window?.addSubview(snapshot)
            self.snapshotView = snapshot

            NSLog("🚀 About to call CCAvenueSDK.initTransaction...")
            CCAvenueIndiaSDK.CCAvenueSDK.initTransaction(model, delegate: self, displayController: rootVC)
            NSLog("✅ CCAvenueSDK.initTransaction called successfully")
        }
    }
    
    // MARK: - CCAvenueDelegate
    public func onTransactionResponse(_ jsonResponse: [AnyHashable : Any]?) {
        NSLog("💳 Response: \(String(describing: jsonResponse))")
        let pendingResolve = self.resolve
        let pendingReject = self.reject
        self.resolve = nil
        self.reject = nil

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.snapshotView?.removeFromSuperview()
            self.snapshotView = nil

            if let responseData = jsonResponse,
               let jsonData = try? JSONSerialization.data(withJSONObject: responseData, options: []),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                pendingResolve?(jsonString)
            } else {
                pendingReject?("PAYMENT_ERROR", "Failed or parsing failed", nil)
            }
        }
    }
}