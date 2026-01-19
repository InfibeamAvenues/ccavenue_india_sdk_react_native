#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_REMAP_MODULE (CCAvenueModule, CcavenueIndiaSdkReactNative,
                                    NSObject)

RCT_EXTERN_METHOD(payCCAvenue : (NSDictionary *)arguments resolve : (
    RCTPromiseResolveBlock)resolve reject : (RCTPromiseRejectBlock)reject)

@end
