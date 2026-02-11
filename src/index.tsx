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

export interface SIInfo {
  siStartDate?: string;
  siEndDate?: string;
  siType?: string;
  siAmount?: string;
  siMerchantRefNo?: string;
  siSetupAmount?: string;
  siBillCycle?: string;
  siFrequencyNo?: string;
  siFrequencyType?: string;
  siUPIMandate?: string;
  siUPIDebitRule?: string;
}

export interface CCAvenueOrderModel {
  // Required fields
  accessCode: string;
  currency: string;
  amount: string;
  trackingId: string;
  requestHash: string;

  // Optional fields
  customerId?: string;
  paymentType?: string; // "all" | "creditcard" | "debitcard" | "netbanking" | "wallet" | "upi"
  ignorePaymentType?: string[]; // "creditcard" | "debitcard" | "netbanking" | "wallet" | "upi"
  displayPromo?: string; // "yes" or "no"
  appColor?: string;
  fontColor?: string;
  environment?: string; // "qa" or "production" or "uat"
  promoCode?: string;
  promoSkuCode?: string;
  displayDialog?: string; // "yes" or "no"
  siInfo?: SIInfo;
}

export const payCCAvenue = (order: CCAvenueOrderModel): Promise<any> => {
  let mappedSIInfo = null;
  if (order.siInfo) {
    mappedSIInfo = {
      si_start_date: order.siInfo.siStartDate,
      si_end_date: order.siInfo.siEndDate,
      si_type: order.siInfo.siType,
      si_amount: order.siInfo.siAmount,
      si_merchant_ref_no: order.siInfo.siMerchantRefNo,
      si_setup_amount: order.siInfo.siSetupAmount,
      si_bill_cycle: order.siInfo.siBillCycle,
      si_frequency: order.siInfo.siFrequencyNo,
      si_frequency_type: order.siInfo.siFrequencyType,
      si_upi_mandate: order.siInfo.siUPIMandate,
      si_upi_debit_rule: order.siInfo.siUPIDebitRule,
    };
  }

  // Apply defaults as per the model definition
  const finalOrder = {
    accessCode: order.accessCode,
    currency: order.currency || 'INR',
    amount: order.amount,
    trackingId: order.trackingId,
    requestHash: order.requestHash,
    customer_id: order.customerId || '',
    payment_type: order.paymentType || 'all',
    ignore_payment_type: order.ignorePaymentType
      ? order.ignorePaymentType.join('|')
      : '', // Join array to string for native
    display_promo: order.displayPromo || 'yes',
    app_color: order.appColor || '#1F46BD',
    font_color: order.fontColor || '#FFFFFF',
    payment_environment: order.environment || 'production',
    promo_code: order.promoCode || '',
    promo_sku_code: order.promoSkuCode || '',
    displayDialog: order.displayDialog || '',
    si_info: mappedSIInfo,
  };

  return CCAvenueModule.payCCAvenue(finalOrder);
};
