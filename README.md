# ccavenue-india-sdk-react-native

A React Native wrapper for integrating the CCAvenue Payment Gateway (India) on Android and iOS. This plugin supports the latest CCAvenue SDKs.

## 1. Installation

```bash
npm install ccavenue-india-sdk-react-native
# or
yarn add ccavenue-india-sdk-react-native
```

## 2. Android Setup

### 2.1. Update `android/build.gradle`

In your **project-level** `android/build.gradle` (not app-level), add the following Maven repositories to the `allprojects` or `dependencyResolutionManagement` block:

```gradle
allprojects {
    repositories {
        // ... other repositories

        // CCAvenue SDK 2.0
        maven {
            name = "GitHubPackages"
            url = uri("https://maven.pkg.github.com/InfibeamAvenues/CCAvenue_SDK_2.0_UAT")
            credentials {
                username = project.properties["gpr.usr"]
                password = project.properties["gpr.key"]
            }
        }
    }
}
```


### 2.2. Update `local.properties`

Add your CCAvenue and Maven credentials to your `android/local.properties` file.

```properties
gpr.usr=InfibeamAvenues
gpr.key=xxxxxx
```

> **Important:** You can obtain these credentials from the CCAvenue Support team.

### 2.3. Update `android/app/build.gradle` (Optional)

Ensure dependencies are resolved correctly. The plugin should handle this automatically, but if you need to manually specify versions or configurations:

```gradle
dependencies {
    implementation("com.ccavenue.indiasdk:indiasdk-uat:0.0.49") {
        isTransitive = true
    }
}
```

## 3. iOS Setup

Run `pod install` in your `ios` directory:

```bash
cd ios && pod install
```

## 4. Usage

```javascript
import { payCCAvenue } from 'ccavenue-india-sdk-react-native';

const initiatePayment = async () => {
  // 1. Create the Order Model
  const order = {
    // ---------------- Required Parameters ----------------
    accessCode: 'AVZC42NB40AS14CZSA',           // Your Access Code
    amount: '30.00',                             // Transaction Amount
    currency: 'INR',                             // Currency Code
    trackingId: '2130000002059981',              // Unique Tracking ID
    requestHash: '08ed172268ab0c2cecb597784dd8c8a01b2f846b08d561e4d121b3d1f471a6910abf2fe99d532d1e1f9301bc46656dcfde7237b12bbb31dbc90e38f6b0d9f50a', //  

    // ---------------- Optional Parameters ----------------

    // Environment & Customization
    environment: 'production',                   // 'production' | 'uat' (Default: production)
    appColor: '#1F46BD',                        // Hex Color Code (Default: #1F46BD)
    fontColor: '#FFFFFF',                       // Hex Color Code (Default: #FFFFFF)
    displayDialog: 'no',                        // 'yes' | 'no' (Default: no)

    // Payment Options
    paymentType: 'all',                         // 'all' | 'creditcard' | 'debitcard' | 'netbanking' | 'wallet' | 'upi' (Default: all)
    ignorePaymentType: ['wallet', 'upi'],       // Array of payment types to hide

    // Promo/Customer Details
    customerId: 'customer@example.com',         // Customer Identifier
    display_promo: 'yes',                       // 'yes' | 'no' (Default: yes)
    promoCode: 'PROMO123',                      // Promo Code
    promoSkuCode: 'SKU123',                     // SKU Code

    // Recurring Payments (Optional)
    siInfo: {
      siType: 'FIXED',                          // 'FIXED' | 'ONDEMAND'
      siMerchantRefNo: 'REF123456789',          // Alphanumeric (15 chars)
      siSetupAmount: '100.00',                  // Amount to be charged for setup
      siBillCycle: '12',                        // Number of times to charge (for FIXED)
      siFrequencyType: 'MONTHS',                // 'DAYS' | 'MONTHS' | 'YEARS' | 'Weekly' | 'One Time' | 'As-presented'
      siFrequencyNo: '1',                       // Frequency number
      siStartDate: '01-01-2024',                // dd-MM-yyyy
      siEndDate: '01-01-2025',                  // dd-MM-yyyy (Optional)
      siUPIMandate: 'Yes',                      // 'Yes' | 'No'
      siUPIDebitRule: 'ON'                      // 'ON' | 'before' | 'After'
    }
  };

  try {
    // 2. Initiate Payment
    const response = await payCCAvenue(order);
    console.log('Payment Response:', response);
  } catch (error) {
    console.error('Payment Error:', error);
  }
};
```

## 5. SDK Response

### 5.1. Success Response

```json
{
  "statusCode": 0, 
  "data": {
    "accessCode": "AVZC42NB40AS14CZSA",
    "encResponse": "dc387ccac08380898157649b22767c5d...",
    "orderStatus": "Successful"
  }
}
```

**Decrypted Response (Server-side):**

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "decryptedResponse": "order_id=ORD1770895283828001&tracking_id=2130000002077083&bank_ref_no=bs07b4ef3db316&order_status=Successful&failure_message=&payment_mode=Net Banking&card_name=Avenues Test for New TC&status_code=&status_message=Transaction is Successful&currency=INR&amount=30.00&billing_name=&billing_address=&billing_city=&billing_state=&billing_zip=&billing_country=&billing_tel=&billing_email=&delivery_name=&delivery_address=&delivery_city=&delivery_state=&delivery_zip=&delivery_country=&delivery_tel=&merchant_param1=test1&merchant_param2=test2&merchant_param3=test3&merchant_param4=test4&merchant_param5=test5&vault=null&offer_type=null&offer_code=null&discount_value=0.0&mer_amount=30.00&eci_value=null&retry=N&response_code=Transaction is Successful&billing_notes=&trans_date=2026-02-12 16:49:33.83&bin_country=&bin_supported=&auth_ref_num="
  }
}
```

### 5.2. Failure Response

```json
{
  "statusCode": 0, 
  "data": {
    "accessCode": "AVZC42NB40AS14CZSA",
    "encResponse": "dc387ccac08380898157649b22767c5d...",
    "orderStatus": "Unsuccessful"
  }
}
```

**Decrypted Response (Server-side):**

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "decryptedResponse": "order_id=ORD1770895283828001&tracking_id=2130000002077091&bank_ref_no=bs40e7925acdc2&order_status=Unsuccessful&failure_message=&payment_mode=Net Banking&card_name=Avenues Test for New TC&status_code=&status_message=Transaction is Failed&currency=INR&amount=30.00&billing_name=&billing_address=&billing_city=&billing_state=&billing_zip=&billing_country=&billing_tel=&billing_email=&delivery_name=&delivery_address=&delivery_city=&delivery_state=&delivery_zip=&delivery_country=&delivery_tel=&merchant_param1=test1&merchant_param2=test2&merchant_param3=test3&merchant_param4=test4&merchant_param5=test5&vault=null&offer_type=null&offer_code=null&discount_value=0.0&mer_amount=30.00&eci_value=null&retry=N&response_code=Transaction is Failed&billing_notes=&trans_date=2026-02-12 16:52:09.617&bin_country=&bin_supported=&auth_ref_num="
  }
}
```

> **Important:** Always decrypt the encResponse on your server-side to extract and verify complete transaction details securely. The encrypted response contains sensitive payment information that must be processed server-side only.

## 6. Error Codes

| Code | Description |
|------|-------------|
| **104** | API Failure |
| **105** | Missing parameter |
| **106** | Invalid parameter |

## 7. Parameter Reference

| Parameter | Type | Description | Mandatory |
| :--- | :--- | :--- | :--- |
| **accessCode** | String | A unique Access Code provided by CCAvenue for each whitelisted server domain or IP address. Only requests originating from the registered IP/domain are allowed to process transactions. | Yes |
| **currency** | String | The currency in which the transaction will be processed. Example: "INR" | Yes |
| **amount** | String | The transaction amount payable by the customer. The value must be a string with two decimal places. Use amount received from Tracking Id Generation API response. Example: "100.00" | Yes |
| **trackingId** | String | A unique payment reference number received from Tracking Id Generation API response for identifying the transaction. | Yes |
| **requestHash** | String | Use requestHash received from Tracking Id Generation API response. | Yes |
| **environment** | String | Payment environment configuration. <br> **Default:** "production" <br> **Possible values:** `production`, `uat` | No |
| **paymentType** | String | Specifies the allowed payment modes. <br> **Default:** "all" <br> **Example values:** <br> "all" – Allow all payment options <br> "card" - Allow both credit and debit cards <br> "creditcard" <br> "debitcard" <br> "netbanking" <br> "wallet" <br> "upi" | No |
| **ignorePaymentType** | Array | Payment modes to be excluded from the payment screen. <br> **Default:** empty array <br> **Example:** `['wallet']` - wallet will not display on payment screen. <br> **Example:** `['wallet', 'upi']` - wallet and UPI will not display on the payment screen. | No |
| **customerId** | String | The identifier against which the card information is to be stored or retrieved. <br> **Default:** empty string | No |
| **display_promo** | String | Determines whether promotional offers should be displayed on the payment screen. <br> **Default:** "yes" <br> **Possible values:** "yes", "no" | No |
| **promoCode** | String | Promotion code to be applied during payment. Promotion created in the CCAvenue MARS by which you may offer specific discounts to customers using specific payment options. <br> **Default:** empty string | No |
| **promoSkuCode** | String | SKU code related to the product. <br> **Default:** empty string | No |
| **siInfo** | Object | Standing Instruction (SI) details used for recurring payments. By default this is null. | No |
| **appColor** | String | Hex color code used as the primary theme color for the payment UI. <br> **Default:** "#1F46BD" | No |
| **fontColor** | String | Hex color code used for text and buttons on the payment UI. <br> **Default:** "#FFFFFF" | No |
| **displayDialog** | String | Determines how the payment UI is presented. <br> **Default:** "no" <br> **Possible values:** <br> no – Full screen payment UI <br> yes – Dialog based UI | No |

 

## 8. SI Info Model Parameters

All parameters are string type.

| Parameter | Description | Remark |
| :--- | :--- | :--- |
| **siType** | This parameter is used to identify whether the standing instruction request is for the fixed amount or for variable amount. <br> **Possible values:** `FIXED`, `ONDEMAND` | |
| **siMerchantRefNo** | Merchant's Reference Value | Alphanumeric (15) <br> dot and Comma (Consecutive characters are not allowed) |
| **siSetupAmount** | **Expected values:** Yes or No <br> **Yes** - The amount sent on the billing shipping page will be treated as setup amount and the merchant has to send si_amount to be charged. <br> **No** - Transaction will be used just for authentication of card and the amount will be refunded back upon successful transaction. | |
| **siBillCycle** | This parameter will enable you to set the value for the total number of times you want to charge a customer. | Only in case of "FIXED" type standing instructions |
| **siFrequencyType** | This will be required only in case of "FIXED" type standing instruction. <br> **Expected Values:** `DAYS`, `MONTHS`, `YEARS`, `Weekly`, `One Time`, `As-presented` | This is used with siFrequencyNo. E.g. If you want to charge the customer every 2 months, you will set the siFrequencyType parameter as "MONTHS" and siFrequencyNo as 2. |
| **siFrequencyNo** | This will be required only in case of "FIXED" type standing instruction. This parameter will enable you to set the frequency on which you want to charge the customer. | This is used with siFrequencyType. E.g. If you want to charge the customer every 2 months, you will set the siFrequencyType parameter as "MONTHS" and siFrequencyNo as 2. |
| **siStartDate** | This is the date from which SI billing will start for the customer. | Only in case of "Fixed" type standing instructions. <br> **Date format:** dd-MM-yyyy |
| **siEndDate** | The date on which the SI billing should end. | **Date format:** dd-MM-yyyy |
| **siUPIMandate** | **Possible values:** `Yes`, `No` | |
| **siUPIDebitRule** | **Possible values:** `ON`, `before`, `After` | |

 

## License

ccavenue-india-sdk-react-native is Copyright © 2026 AvenuesAI Ltd. It is distributed under the MIT License.

---

**Need help with integration?** Contact us for assistance.
