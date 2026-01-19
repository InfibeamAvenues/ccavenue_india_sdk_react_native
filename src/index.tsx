import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-ccavenue-india-sdk-react-native' doesn't seem to be linked. Make sure: \n\n` +
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

export enum PaymentEnvironment {
  local = 'app_local',
  staging = 'test',
  live = 'live',
}

export interface CCAvenueOrderModel {
  accessCode: string;
  amount: string;
  currency: string;
  trackingId: string;
  requestHash: string;

  // Optional
  customerId?: string;
  paymentType?: string;
  ignorePaymentOption?: string;
  displayPromo?: boolean;
  appColor?: string;
  fontColor?: string;
  environment?: PaymentEnvironment;
}

export function payCCAvenue(order: CCAvenueOrderModel): Promise<any> {
  const params = {
    ...order,
    // Default values if not provided, to match Flutter example logic
    currency: order.currency || "INR",
    paymentType: order.paymentType || "all",
    environment: order.environment || PaymentEnvironment.local
  };
  return CCAvenueModule.payCCAvenue(params);
}
