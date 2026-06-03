import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'ccavenue-india-sdk-react-native' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const CCAvenueModule = NativeModules.CCAvenueModule
  ? NativeModules.CCAvenueModule
  : new Proxy(
    {},
    {
      get() {
        throw new Error(LINKING_ERROR);
      },
    }
  );

export interface CCAvenueOrderOptions {
  accessCode: string;
  encRequest: string;
  appColor?: string;
  fontColor?: string;
  paymentEnvironment?: string; // "qa" or "production" or "uat"
}

export class CCAvenueOrder {
  accessCode: string;
  encRequest: string;
  appColor?: string;
  fontColor?: string;
  paymentEnvironment?: string;

  constructor(options: CCAvenueOrderOptions) {
    this.accessCode = options.accessCode;
    this.encRequest = options.encRequest;
    this.appColor = options.appColor;
    this.fontColor = options.fontColor;
    this.paymentEnvironment = options.paymentEnvironment;
  }
}

export class CCAvenueSDK {
  initTransaction(order: CCAvenueOrder): Promise<any> {
    const finalOrder = {
      accessCode: order.accessCode,
      encRequest: order.encRequest,
      appColor: order.appColor || '#1F46BD',
      fontColor: order.fontColor || '#FFFFFF',
      paymentEnvironment: order.paymentEnvironment || 'production',
    };

    return CCAvenueModule.payCCAvenue(finalOrder);
  }
}

// Deprecated: Kept for backwards compatibility
export const payCCAvenue = (order: CCAvenueOrder): Promise<any> => {
  return new CCAvenueSDK().initTransaction(order);
};
