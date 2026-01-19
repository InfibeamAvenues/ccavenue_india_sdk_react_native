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
  local = 'LOCAL',
  staging = 'STAGING',
  live = 'LIVE',
}

export enum DisplayDialog {
  full = 'FULL',
  dialog = 'DIALOG',
}

export interface SIInfo {
  si_start_date?: string;
  si_end_date?: string;
  si_type?: string;
  si_amount?: string;
  si_merchant_ref_no?: string;
  si_setup_amount?: string;
  si_bill_cycle?: string;
  si_frequency?: string;
  si_frequency_type?: string;
  si_upi_mandate?: string;
  si_upi_debit_rule?: string;
}

export interface CCAvenueOrderModel {
  accessCode: string;
  amount: string;
  currency: string;
  trackingId: string;
  requestHash: string;

  // Optional Logic
  customerId?: string;
  paymentType?: string;
  ignorePaymentOption?: string;
  displayPromo?: boolean;
  promoCode?: string;
  promoSkuCode?: string;
  
  // UI & Environment
  appColor?: string;
  fontColor?: string;
  environment?: PaymentEnvironment;
  displayDialog?: DisplayDialog;
  
  // Nested SI
  siInfo?: SIInfo;
}

export function payCCAvenue(order: CCAvenueOrderModel): Promise<any> {
  const params = {
    ...order,
    // Ensure default values are handled for the Native Bridge
    currency: order.currency || "INR",
    paymentType: order.paymentType || "all",
    environment: order.environment || PaymentEnvironment.live,
    displayDialog: order.displayDialog || DisplayDialog.full,
    displayPromo: order.displayPromo ?? true, // Use nullish coalescing for booleans
  };
  
  return CCAvenueModule.payCCAvenue(params);
}