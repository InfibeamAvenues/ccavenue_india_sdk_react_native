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
    promoCode: '',                      // Promo Code
    promoSkuCode: '',                     // SKU Code

    // SI Mandate (Optional)
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

### 5.1. Transaction Success Response

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

**Decrypted Response (Server-side):**

```json
{
  "status_message": "Transaction is Successful",
  "delivery_address": "",
  "response_code": "Transaction is Successful",
  "trans_date": "2026-02-19 11:05:13.407",
  "status_code": "",
  "delivery_name": "",
  "billing_address": "",
  "failure_message": "",
  "bank_ref_no": "bs93b681eaa7d4",
  "order_status": "Successful",
  "billing_tel": "",
  "billing_state": "",
  "billing_email": "",
  "billing_zip": "",
  "currency": "INR",
  "merchant_param1": "Merchant Param1",
  "merchant_param2": "Merchant Param2",
  "merchant_param3": "",
  "tracking_id": "2130000002080856",
  "merchant_param4": "",
  "vault": "Y",
  "offer_type": null,
  "retry": "N",
  "merchant_param5": "Merchant Param5",
  "auth_ref_num": "",
  "delivery_country": "",
  "payment_mode": "Net Banking",
  "amount": "170.00",
  "bin_country": "",
  "billing_country": "",
  "mer_amount": "170.00",
  "discount_value": "0.0",
  "delivery_state": "",
  "bin_supported": "",
  "offer_code": null,
  "billing_name": "",
  "billing_city": "",
  "billing_notes": "",
  "eci_value": null,
  "card_name": "Avenues Test for New TC",
  "delivery_tel": "",
  "order_id": "123454321123",
  "delivery_city": "",
  "delivery_zip": ""
}
```

### 5.2. Transaction Failure Response

```json
{
  "statusCode": 0,
  "statusMessage": "Success",
  "data": {
    "orderStatus": "Unsuccessful",
    "accessCode": "AVZC42NB40AS14CZSA",
    "encResponse": "87310ae51e2c4710479e35cbfc09653643ead2afd8040eff6294f05012cb0fa1b275ae336cb340808de0c9ed29b6ddd67721efd55a55bad229187296e3c9a461280db774c5c47235eaefb6204155bd4dace541eec9bec726fca89328f1d5e86ab2ce908be7b970834a75d652d8726ceb429752b7cbba2fbdb44e0f727e3a907a8dd6da126e07e270600d3526bfcd2556e2d20e0c483d4233e2f361a76f32052b415952d79ff71eb6e54392a0c86824570ab4ee7c938bafef12e619d7b2a1d0f7cf012f328531e4c85d8eec3763b90ed7f1d8e7719d54c992b27bce7de3549028991b15817e60612ee7669b661be923d5fcbc533a5a82cd5606eec77785fbdb02988246971ea33f0b5f4fb1bdb1d7527cf2956979854668baf8c802173a352441857a7ec0a35232116adb0cbc634bf6cb22813566c31a6412c49f1243cec4b9327cb91f4765a6dc2686ec1a21b6966fa8587fc3aa38184b862e2c702620864bb3a72c9612e2e71f19a1daf35c2335d612d69d110ae6b372cdeca0e673e87501c68296490e3297391150f533d630024293a8bbf59d028383d67f405f3480e57227a5374c33b50bf1677063cf4891f63386b798e2f0d633822a1d8485699b105f173d5e7d959c6743ec267392bc2acf67751f9b3415ce03f47c04e79c0577449d6337d52d5cf236c5eb148a493a3cf63d39ce11e42d2dd7c8f3bcf841c86470fa741f96bd8d533e3637661512c5a6921628d273b6837bffd5f5a3ea31c0208e4c7dc81eebacc9717dc3d5f029ad1d86bc5c5958e9f349e4cd29297ac8ee0cb61764c074106e341c4c2f33cf5eb4b211601a35636356b0fbf3c205b2614c99da1db3aef2f10ad2b3f896207dfca6c34ba186d922a0b7f807348b31cfaed31de1e92be162e7ffcd8008bd29b65c726eb23ee5fca7c8afeb769e3e4c4bfb88e6c952351e354eb560e255af42458d0f8f3df147ae20bdde58ce97e0ad8079e55e76e78bdab7c3983247c7735945b00988fe614cd34ac178e6c5baca626be5ed848ec78e02177109267bf2d638dd35a7380f3e31a5e4ca9ebf38b534a47133e772272b2f5bc837f93acbe569723593bb3f3c8bd067927e7e1fc560f64bce32ccc1ac6051cbd9167fe9c2770b40dd67a6217e112ab571af90c9b5de8eeea59c81199006ad0f6221bdf1107ee58a7c884ca8f87a80e18a1461b9c61c9c5ed819dac612145178ed94b7ca7f6d9f5fd6beaa10822da833b92d0bbab8b9f537223880ed63dcac0ce6eff71be45789193c02c4366ec3e32adc526f9635e9950a8dffb09ffcfbf41c516279678e413e96aa56ab09d79f81b3be4fcf19aba174b85fe75c6f22a4bd80efd1430739a5868098e405a826922ac3240e1dd32406088979b7f57a2350d4ca7f7a13011272313711713babefa810f50e4455563703b0fdfbb3d8279987ba"
  }
}
```

**Decrypted Response (Server-side):**

```json
{
  "status_message": "Transaction is Failed",
  "delivery_address": "",
  "response_code": "Transaction is Failed",
  "trans_date": "2026-02-19 11:16:00.33",
  "status_code": "",
  "delivery_name": "",
  "billing_address": "",
  "failure_message": "",
  "bank_ref_no": "bsd77d05ec848b",
  "order_status": "Unsuccessful",
  "billing_tel": "",
  "billing_state": "",
  "billing_email": "",
  "billing_zip": "",
  "currency": "INR",
  "merchant_param1": "Merchant Param1",
  "merchant_param2": "Merchant Param2",
  "merchant_param3": "",
  "tracking_id": "2130000002080885",
  "merchant_param4": "",
  "vault": "Y",
  "offer_type": null,
  "retry": "N",
  "merchant_param5": "Merchant Param5",
  "auth_ref_num": "",
  "delivery_country": "",
  "payment_mode": "Net Banking",
  "amount": "170.00",
  "bin_country": "",
  "billing_country": "",
  "mer_amount": "170.00",
  "discount_value": "0.0",
  "delivery_state": "",
  "bin_supported": "",
  "offer_code": null,
  "billing_name": "",
  "billing_city": "",
  "billing_notes": "",
  "eci_value": null,
  "card_name": "Avenues Test for New TC",
  "delivery_tel": "",
  "order_id": "123454321123",
  "delivery_city_alt": "",
  "delivery_zip_alt": ""
}
```

> **Important:** Always decrypt the encResponse on your server-side to extract and verify complete transaction details securely. The encrypted response contains sensitive payment information that must be processed server-side only.

## 6. Other SDK Error Codes

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

> **Important:** The `requestHash` must be generated server-side
 

## 8. SI Mandate Parameters

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

 

---

**Need help with integration?** Contact us for assistance.
