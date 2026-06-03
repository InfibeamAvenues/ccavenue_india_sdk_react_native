# ccavenue-india-sdk-react-native

A React Native library for integrating the CCAvenue Payment Gateway (India) on Android and iOS. CCAvenue React Native SDK is a secure, PCI-DSS compliant way to accept Debit/Credit card, Net-banking, UPI and Wallet payments from your customers in your app.

# Steps to Integrate React Native SDK:


## 1. Installation

Add the `ccavenue-india-sdk-react-native` package to your React Native project:

```bash
npm install ccavenue-india-sdk-react-native
# or
yarn add ccavenue-india-sdk-react-native
```

## 2. Android Setup

### 2.1. Update `android/build.gradle`

Add the required repositories in your project-level settings.gradle or build.gradle file:

```gradle
allprojects {
    repositories {
        // ... other repositories

        // CCAvenue SDK 2.0
        maven {
            name = "GitHubPackages"
            url = uri("https://maven.pkg.github.com/InfibeamAvenues/CCAvenue_SDK_2.0")
            credentials {
                username = "YOUR_USERNAME" // Provided by CCAvenue
                password = "YOUR_PASSWORD" // Provided by CCAvenue
            }
        }
    }
}
```


### 2.2. Update `android/app/build.gradle`

Add the CCAvenue Android SDK dependency in your app-level build.gradle:

```gradle
dependencies {
    implementation("com.ccavenue.indiasdk:sdk:x.x.x")
}
```


## 3. iOS Setup

Run `pod install` in your `ios` directory:

```bash
cd ios && pod install
```

### 3.1. Configure UPI or BANK apps URL Schemes (Optional)

To display and launch installed UPI or BANK apps, you must add below URL schemes in your `Info.plist`.

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
		<string>paytm</string>
		<string>phonepe</string>
		<string>tez</string>
		<string>credpay</string>
		<string>bhim</string>
		<string>mobikwik</string>
		<string>freecharge</string>
		<string>amazonpay</string>
		<string>navi</string>
		<string>kiwi</string>
		<string>payzapp</string>
		<string>jupiter</string>
		<string>omnicard</string>
		<string>icici</string>
		<string>popclubapp</string>
		<string>sbiyono</string>
		<string>myjio</string>
		<string>slice-upi</string>
		<string>bobupi</string>
		<string>shriramone</string>
		<string>whatsapp</string>
		<string>com.rediff.pay</string>
		<string>hdfcbanknb</string>

		<string>aunb</string>
		<string>icici</string>
		<string>yonolitenb</string>
		<string>yesirisnb</string>
		<string>fedmobilenb</string>
		<string>axisbanknb</string>
</array>
```

### 3.2. Enable Card Scan Feature (Optional)

To enable the Card Scan feature, please add the following key to your application’s `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera permission is required to scan card</string>
```

This SDK uses the device camera to scan card details securely and locally on the device.
If this key is not added, the Card Scan feature will remain disabled.

## 4. Usage


### 4.1 Import the SDK
The merchant needs to import the SDK in the JavaScript/TypeScript file where payment needs to be
initiated:

```javascript
import { payCCAvenue } from 'ccavenue-india-sdk-react-native';
```

### 4.2 Create the CCAvenueOrderModel

Before starting a transaction, initialize the order object with required order parameters:

```javascript
const order = {
  accessCode: 'ABCD42EF06GH33IJKL',           
  encRequest: 'YOUR_ENCRYPTED_REQUEST',       
  paymentEnvironment: 'production',                  
  appColor: '#1F46BD',                    
  fontColor: '#FFFFFF',                    
};
```

### 4.3 Pass the model to payCCAvenue method

```javascript
const response = await payCCAvenue(order);
```

### 4.4 Sample Code

```javascript
import { payCCAvenue } from 'ccavenue-india-sdk-react-native';

const initiatePayment = async () => {
  // 1. Create the Order Model
  const order = {
    accessCode: 'ABCD42EF06GH33IJKL',           
    encRequest: 'YOUR_ENCRYPTED_REQUEST',       
    paymentEnvironment: 'production',                  
    appColor: '#1F46BD',                    
    fontColor: '#FFFFFF',                    
  };

  try {
    // 2. Initiate Payment
    const response = await payCCAvenue(order);
    console.log('Payment Response (JSON String):', response);
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
  "statusMessage": "Success",
  "data": {
    "orderStatus": "Success",
    "accessCode": "ABCD4567JKSP",
    "encResponse": "6bea0fb0bd0044ed0cf03e70be90eb16405d5329b5e95c8a4530eb69c1f8653f2a493d56d11d91ae19a61a0cf4f415eeb9749e9acdac51b6b29e195e4a7d1a09ded14d05866985760a27831a872dc99d0946926265eaec97d5a1b9da84cea39ef2eb4811c70357952238388d932756e6a6708906c95a724e2119d44a332b581ad911986d392d410533e5054c926777294be9e9284e8433de90c8f62dcd35185f62601348561ef16b6090a64b0e7f791649455e8d1f1288e2041004408f7dc962197485ff9c502bd7c643901213869ce3b3004a55785f7cbe3e344bb80e83e93f6701d8d2b602f06de8649ebca3afa74588c9898e07df49fe29ad1212945f4a90ecafc783f87006ac626d1444dd5e33bba75a9df21f0f7892c0316d3f2a3030d452c1c2cdc0bf35a8aa8c9b4d83587a5fefd9c59e40fca7ca7f69b9afcfaa32df8ebe65c54d863212e844eec5abeea1fc34f938765e6ca7f21df9a364b4a3e3fbd8824d3d41e736a936ad589be91bdf900f8574d4e51da5a4b335b0f9b948809b4dc5634a2c370d56151f295b93ee1e108fa49b1ce9f9de151c91f821f7c4ded56b103923491116e2ae8f25ddf9e274b86e444ce93924fb87de061b3273025c51dd7b6709565b19675fb053ae21b16a2a286b7803de26de7fbe06fab5e9b6dde071e540c645cd7f3405179dd293382b38d8991f90b1bc4d854ad06da7697a6b9ccf5b387d0f064b0e30253cb3628fde9fc4d9361b351188c2c46b1aaf6320be775a174f0fe91e20a25fa2ab7c1a981ac1856a72f49ce8801adc778eaf7b8c1396f06167af8f3f78b1779234952b72e9c9f3eea8c9a15185e874710e51e400e71393435a07388c9f73e8f74e6d29d0fb4a675707e66b4895362780609f72d12c113e8198a9efe4428ff062175c9074477425663871e66a15775c82a62c4d77aeedd9bfae2f7ea3256d19b89d0d7202748a1634d805ce5ff795338cba1b25fee90726a25893a23ebd4bd1ed11ca34d35f567039032a5d5d1d02b33a7b280b597baf0c343cff342730cbd6f6790e0996cf1bc1b4a68cb88fe81fd81a0fd1111b0d096c9ec21f13319bd404d23a3673876449e0f1c17fb0cbadcc10511e196dd0428f8e4f01c0f0410b699a49d5825b34014581081781ac90f7d11e04eac5cecaba32dfbcc51b1e33f881295ccbe58de170cacb5162372962857a6f5b19b7f63de4d72935832b64da0986dc1590e294e9a870dcc80d7386925c816a8b683c3b07ad23bcf72a14ef4596c94f1d9e36e48e54f766635fa5a34ed73acff9fff5ccf609af70dab870830de4015426e405163940a71e2cfff9b3b06f790192d64d6605f5b07f17574ca7829923e4a63f27ef1f8263e69f6af513b5fbc1e74c5f745077147aff6ae886a3e804549eddbf98c72868aabd15a29d8bbae71d75be00b7291a98d603ca714ab1de06c9c5991bcdc6101f4cb4dbf1f618a0880515d01794e0fd887561105f139a375278db81eb55451595be6169512134b23ba9a355c6c697e666669876b5d7b018c404c17ddf3b56adce7ad6fe1ded55a6d6cc655046cf06e42cec22992123ae65a0c6d5382cb42d942e2f0e70989623e6be145ae9ab60a02a5ec8298b978807def386c284dfe535d1837d7c9d3c48545a0e4a949b2c093162378c102f16c452ff4a10456d18f1686541d4"
  }
}
```
 

## 6. Request Parameters

| Parameter | Type | Mandatory | Description |
| :--- | :--- | :--- | :--- |
| **accessCode** | String | Yes | You will get this parameter from CCAvenue M.A.R.S account, under Settings tab > API Keys page |
| **encRequest** | String | Yes | Details on how to generate the encRequest are provided in the Preconfiguration section. |
| **paymentEnvironment** | String | No | The default value is "production". Expected values: `production` or `uat` |
| **appColor** | String | No | Hex color code used as the primary theme color in the payment UI. Default value is '#1F46BD'. |
| **fontColor** | String | No | Hex color codes used for text and buttons in the payment UI. Default value is '#FFFFFF'. |
 
## 7. Response Parameters

| Parameter | Type | Mandatory | Description |
| :--- | :--- | :--- | :--- |
| **statusCode** | String | Yes | The status code for this transaction. |
| **statusMessage** | String | Yes | The status message for this transaction. |
| **accessCode** | String | Yes | AccessCode sent in request. |
| **orderStatus** | String | Yes | Status of the order. Success, Failure, Aborted, Timeout |
| **encResponse** | String | Yes | The response is encrypted. Please decrypt it using the logic provided in the pre-configuration section, where all required parameters are also defined. |
 

---

**Need help with integration?** Contact us for assistance.
