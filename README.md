# ccavenue-india-sdk-react-native

A React Native wrapper for integrating the CCAvenue Payment Gateway (India) on Android and iOS. This plugin supports the latest CCAvenue SDKs.

## Installation

```bash
npm install ccavenue-india-sdk-react-native
# or
yarn add ccavenue-india-sdk-react-native
```

## Android Setup

### 1. Update `android/build.gradle`

In your **project-level** `android/build.gradle` (not app-level), add the following Maven repositories to the `allprojects` or `dependencyResolutionManagement` block:

```gradle
allprojects {
    repositories {
        

        // 1. CCAvenue SDK 2.0
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

### 2. Update `local.properties`

Add your CCAvenue and Maven credentials to your `android/local.properties` file. **You can get these credentials from the Support team.**

```properties
gpr.usr=InfibeamAvenues
gpr.key=xxxxxx
```

### 3. Update `android/app/build.gradle` (Optional)

Ensure dependencies are resolved correctly. The plugin should handle this automatically, but if you need to manually specify versions or configurations:

```gradle
dependencies {
    implementation("com.ccavenue.indiasdk:indiasdk-uat:0.0.49") {
        isTransitive = true
    }
}
```

## iOS Setup

1.  Run `pod install` in your `ios` directory.

```bash
cd ios && pod install
```

## Usage

```javascript
import { payCCAvenue } from 'ccavenue-india-sdk-react-native';

// ...

const initiatePayment = async () => {
  // 1. Create the Order Model
  const order = {

    //----------------Required----------------

    accessCode: 'AVRF42ME06BS33FRSB', // Your Access Code (Required)
    amount: '100.00', // Transaction Amount (Required)
    currency: 'INR', // Currency Code (Required)
    trackingId: '2130000002059981', // Unique Tracking ID (Required)
    requestHash: '08ed172268ab0c2cecb597784dd8c8a01b2f846b08d561e4d121b3d1f471a6910abf2fe99d532d1e1f9301bc46656dcfde7237b12bbb31dbc90e38f6b0d9f50a', // SHA-512 Encrypted Hash (Required)

    //----------------Optional----------------

    // Environment & Customization
    environment: 'production', // 'production' | 'uat' (Default: production)
    appColor: '#1F46BD', // Hex Color Code (Default: #1F46BD)
    fontColor: '#FFFFFF', // Hex Color Code (Default: #FFFFFF)
    displayDialog: 'no', // 'yes' | 'no' (Default: no)

    // Payment Options
    paymentType: 'all', // 'all' | 'creditcard' | 'debitcard' | 'netbanking' | 'wallet' | 'upi' (Default: all)
    ignorePaymentType: ['wallet', 'upi'], // Array of payment types to hide. E.g., ['wallet', 'upi']

    // Promo/Customer Details
    customerId: 'customer@example.com', // Customer Identifier (Optional)
    display_promo: 'yes', // 'yes' | 'no' (Default: yes)
    promoCode: 'PROMO123', // Promo Code (Optional)
    promoSkuCode: 'SKU123', // SKU Code (Optional)

    // Recurring Payments (Optional)
    siInfo: {
        siType: 'FIXED', // 'FIXED' | 'ONDEMAND'
        siMerchantRefNo: 'REF123456789', // Alphanumeric (15 chars)
        siSetupAmount: '100.00', // Amount to be charged for setup
        siBillCycle: '12', // Number of times to charge (for FIXED)
        siFrequencyType: 'MONTHS', // 'DAYS' | 'MONTHS' | 'YEARS' | 'Weekly' | 'One Time' | 'As-presented'
        siFrequencyNo: '1', // Frequency number (e.g. 1 for every month)
        siStartDate: '01-01-2024', // dd-MM-yyyy
        siEndDate: '01-01-2025', // dd-MM-yyyy (Optional)
        siUPIMandate: 'Yes', // 'Yes' | 'No'
        siUPIDebitRule: 'ON' // 'ON' | 'before' | 'After'
    }
  };

  try {
    // 2. Initiate Payment
    const response = await payCCAvenue(order);
    console.log("Payment Response:", response);
  } catch (error) {
    console.error("Payment Error:", error);
  }
};
```

## Sample Response

### Success:
```json
{
  "statusCode": 0, 
  "data": {
    "accessCode": "ABCD42EF06GH33IJKL",
    "encResponse": "316dc7f54c50d0e2ceb812e9bfa19b983c5db8aa27472cb752f6a7258577fb53c751b3089b262c7c9e35d0ac9ff3a4c5942e329557adba4bb790736da9fa76560dbc1ac34ed484c13685a7c40898523172c3aaeb0db5007d9bbf25371795ac582ba0919a8a04683a95dc42711f645e2be416c1a4fd17179b6085a37a6a052252113f9f4812dc2a8a998087ff21fe0a1a785af40e402c5f00f495fbd2820be94ba5aca5c0ab35dbf13d79a7a22f217b1fdce2a95d9dd6d9f77370d407c00e8214e2a9daae9a8bf0a0dc6ea255a7ae3842d01e510335a0b6df4b6388ec4adf98506b62ae72446eddaad6c427f243d3d5aa31f3090a79d968dbac5ac67f6f995ec4850fca425cc4203250d1aa8f3e7ac067ce58699cab640e28d62063f467d99387aa3cd6822d8dcdc79c12bc7269356a25363c950b7fd9dd73fb076f6aae284f02fe7900164893e0986060c57b7b90865de1c63cd45a82b2eb0d134a299594db894d9dcbc419deefe129eb2a12d3b43c2fc0dc972e99e7c669f9f7eb0798fdeb2e8e79696800fdce40811",
    "orderStatus": "Successful"
  }
}
```

### Failure:
```json
 {
  "statusCode": 0, 
  "data": {
    "accessCode": "ABCD42EF06GH33IJKL",
    "encResponse": "316dc7f54c50d0e2ceb812e9bfa19b983c5db8aa27472cb752f6a7258577fb53c751b3089b262c7c9e35d0ac9ff3a4c5942e329557adba4bb790736da9fa76560dbc1ac34ed484c13685a7c40898523172c3aaeb0db5007d9bbf25371795ac582ba0919a8a04683a95dc42711f645e2be416c1a4fd17179b6085a37a6a052252113f9f4812dc2a8a998087ff21fe0a1a785af40e402c5f00f495fbd2820be94ba5aca5c0ab35dbf13d79a7a22f217b1fdce2a95d9dd6d9f77370d407c00e8214e2a9daae9a8bf0a0dc6ea255a7ae3842d01e510335a0b6df4b6388ec4adf98506b62ae72446eddaad6c427f243d3d5aa31f3090a79d968dbac5ac67f6f995ec4850fca425cc4203250d1aa8f3e7ac067ce58699cab640e28d62063f467d99387aa3cd6822d8dcdc79c12bc7269356a25363c950b7fd9dd73fb076f6aae284f02fe7900164893e0986060c57b7b90865de1c63cd45a82b2eb0d134a299594db894d9dcbc419deefe129eb2a12d3b43c2fc0dc972e99e7c669f9f7eb0798fdeb2e8e79696800fdce40811",
    "orderStatus": "Unsuccessfull"
  }
}
```
#### Note -> You Can decrypt the encResponse on server side for transaction details.

## Status Codes

| Code | Description |
| :--- | :--- |
| **104** | API Failure |
| **105** | Missing parameter |
| **106** | Invalid parameter |

## Parameters

| Parameter | Type | Description | Mandatory |
| :--- | :--- | :--- | :--- |
| **accessCode** | String | A unique Access Code provided by CCAvenue for each whitelisted server domain or IP address. Only requests originating from the registered IP/domain are allowed to process transactions. | Yes |
| **currency** | String | The currency in which the transaction will be processed. Example: "INR" | Yes |
| **amount** | String | The transaction amount payable by the customer. The value must be a string with two decimal places. Example: "100.00" | Yes |
| **trackingId** | String | A unique payment reference number received from Tracking Id Generation API response for identifying the transaction. | Yes |
| **requestHash** | String | A SHA-512 encrypted hash generated using: `trackingId + currency + amount + workingKey`. This is used to validate the integrity of the payment request. | Yes |
| **paymentEnvironment** | String | Payment environment configuration. <br> **Default:** "production" <br> **Possible values:** `production`, `uat` | No |
| **paymentType** | String | Specifies the allowed payment modes. <br> **Default:** "all" <br> **Example values:** <br> "all" – Allow all payment options <br> "card" - Allow both credit and debit cards <br> "creditcard" <br> "debitcard" <br> "netbanking" <br> "wallet" <br> "upi" | No |
| **ignorePaymentType** | String | Payment modes to be excluded from the payment screen. <br> **Default:** empty string <br> **Example:** "wallet" - wallet will not display on payment screen. <br> **Example:** "wallet\|upi" - wallet and UPI will not display on the payment screen. | No |
| **customerId** | String | The identifier against which the card information is to be stored or retrieved. <br> **Default:** empty string | No |
| **displayPromo** | String | Determines whether promotional offers should be displayed on the payment screen. <br> **Default:** "yes" <br> **Possible values:** "yes", "no" | No |
| **promoCode** | String | Promotion code to be applied during payment. Promotion created in the CCAvenue MARS by which you may offer specific discounts to customers using specific payment options. <br> **Default:** empty string | No |
| **promoSkuCode** | String | SKU code related to the product. <br> **Default:** empty string | No |
| **siInfo** | SIInfo (Model) | Standing Instruction (SI) details used for recurring payments. By default this model is nil. | No |
| **appColor** | String | Hex color code used as the primary theme color for the payment UI. <br> **Default:** "#1F46BD" | No |
| **fontColor** | String | Hex color code used for text and buttons on the payment UI. <br> **Default:** "#FFFFFF" | No |
| **displayDialog** | String | Determines how the payment UI is presented. <br> **Default:** "no" <br> **Possible values:** <br> no – Full screen payment UI <br> yes – Dialog based UI | No |

## SI Info Model Parameters

All parameters are string type.

| Parameter | Description | Remark |
| :--- | :--- | :--- |
| **siType** | This parameter is used to identify whether the standing instruction request is for the fixed amount or for variable amount. <br> **Possible values:** `FIXED`, `ONDEMAND` | |
| **siMerchantRefNo** | Merchant's Reference Value | Alphanumeric (15) <br> dot and Comma (Consecutive characters are not allowed) |
| **siSetupAmount** | **Expected values:** Yes or No <br> **Yes** - The amount sent on the billing shipping page will be treated as setup amount and the merchant has to send si_amount to be charged. <br> **No** - Transaction will be used just for authentication of card and the amount will be refunded back upon successful transaction. | |
| **siBillCycle** | This parameter will enable you to set the value for the total number of times you want to charge a customer. | Only in case of "FIXED" type standing instructions |
| **siFrequencyType** | This will be required only in case of "FIXED" type standing instruction. <br> **Expected Values:** `DAYS`, `MONTHS`, `YEARS`, `Weekly`, `One Time`, `As-presented` | This is used with siFrequencyNo. E.g. If you want to charge the customer every 2 months, you will set the siFrequencyType parameter as “MONTHS” and siFrequencyNo as 2. |
| **siFrequencyNo** | This will be required only in case of “FIXED” type standing instruction. This parameter will enable you to set the frequency on which you want to charge the customer. | This is used with siFrequencyType. E.g. If you want to charge the customer every 2 months, you will set the siFrequencyType parameter as “MONTHS” and siFrequencyNo as 2. |
| **siStartDate** | This is the date from which SI billing will start for the customer. | Only in case of "Fixed" type standing instructions. <br> **Date format:** dd-MM-yyyy |
| **siEndDate** | The date on which the SI billing should end. | **Date format:** dd-MM-yyyy |
| **siUPIMandate** | **Possible values:** `Yes`, `No` | |
| **siUPIDebitRule** | **Possible values:** `ON`, `before`, `After` | |


## License
ccavenue-india-sdk-react-native is Copyright (c) 2026 AvenuesAI Ltd. It is distributed under the MIT License.

Contact us to help you with integrations.
