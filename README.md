# react-native-ccavenue-india-sdk-react-native

A React Native wrapper for integrating the CCAvenue Payment Gateway (India) on Android and iOS. This plugin supports the latest CCAvenue SDKs.

## Installation

```bash
npm install react-native-ccavenue-india-sdk-react-native
# or
yarn add react-native-ccavenue-india-sdk-react-native
```

## Android Setup

### 1. Update `android/build.gradle`

In your **project-level** `android/build.gradle` (not app-level), add the following Maven repositories to the `allprojects` or `dependencyResolutionManagement` block:

```gradle
allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url "https://jitpack.io" }

        // 1. CCAvenue SDK 2.0
        maven {
            name = "GitHubPackages"
            url = uri("https://maven.pkg.github.com/InfibeamAvenues/CCAvenue_SDK_2.0_UAT")
            credentials {
                username = project.properties["gpr.usr"] ?: "InfibeamAvenues"
                password = project.properties["gpr.key"] ?: ""
            }
        }
    }
}
```

### 2. Update `local.properties`

Add your CCAvenue and Maven credentials to your `android/local.properties` file. **You can obtain these credentials from the InfibeamAvenues Dashboard.**

```properties
gpr.usr=InfibeamAvenues
gpr.key=xxxxxx
```

### 3. Update `android/app/build.gradle` (Optional)

Ensure dependencies are resolved correctly. The plugin should handle this automatically, but if you need to manually specify versions or configurations:

```gradle
dependencies {
    implementation("com.ccavenue.indiasdk:indiasdk-uat:0.0.21") {
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
import { payCCAvenue } from 'react-native-ccavenue-india-sdk-react-native';

// ...

const initiatePayment = async () => {
  // 1. Create the Order Model
  const order = {
    accessCode: "AVRF42ME06BS33FRSB", // Your Access Code
    amount: "170.00",
    currency: "INR",
    trackingId: "2130000002059981", // Unique Tracking ID
    requestHash: "08ed172268ab0c2cecb597784dd8c8a01b2f846b08d561e4d121b3d1f471a6910abf2fe99d532d1e1f9301bc46656dcfde7237b12bbb31dbc90e38f6b0d9f50a", // Calculated Hash
    
    // Customization
    appColor: "#164880",
    fontColor: "#FFFFFF",
    paymentType: "all",
    environment: "production", // "qa", "production", "uat"
    
    // Optional
    customerId: "customer@example.com",
    // ignorePaymentType: ["creditcard", "netbanking"],
    // displayPromo: "yes", // or "no"
    // promoCode: "PROMO123",
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

## License

MIT
