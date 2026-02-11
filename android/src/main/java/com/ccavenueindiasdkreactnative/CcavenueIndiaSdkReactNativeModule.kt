package com.ccavenueindiasdkreactnative

import android.app.Activity
import android.content.Intent
import android.util.Log
import com.facebook.react.bridge.*
import java.io.Serializable
import java.util.HashMap

// Alias class for static access
class CcavenueIndiaSdkPlugin {
    companion object {
        var onSuccess: ((String) -> Unit)? = null
        var onError: ((String) -> Unit)? = null
    }
}

class CcavenueIndiaSdkReactNativeModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String = "CCAvenueModule"

    @ReactMethod
    fun payCCAvenue(params: ReadableMap, promise: Promise) {
        Log.d("CCAvenueModule", "payCCAvenue called with params: $params")
        
        val activity: Activity? = getCurrentActivity()
        if (activity == null) {
            Log.e("CCAvenueModule", "Activity is null")
            promise.reject("ACTIVITY_ERROR", "Activity doesn't exist")
            return
        }

        // Set static callbacks
        CcavenueIndiaSdkPlugin.onSuccess = { response ->
            promise.resolve(response)
        }
        CcavenueIndiaSdkPlugin.onError = { error ->
            promise.reject("TRANSACTION_ERROR", error)
        }

        try {
            val intent: Intent = Intent(activity, CCAvenueWrapperActivity::class.java)
            
            // 1. Core Parameters
            intent.putExtra("accessCode", if (params.hasKey("accessCode")) params.getString("accessCode") else "")
            intent.putExtra("amount", if (params.hasKey("amount")) params.getString("amount") else "")
            intent.putExtra("currency", if (params.hasKey("currency")) params.getString("currency") else "INR")
            intent.putExtra("trackingId", if (params.hasKey("trackingId")) params.getString("trackingId") else "")
            intent.putExtra("requestHash", if (params.hasKey("requestHash")) params.getString("requestHash") else "")
            
            // 2. Optional UI & Logic Parameters
            intent.putExtra("customer_id", if (params.hasKey("customer_id")) params.getString("customer_id") else if (params.hasKey("customerId")) params.getString("customerId") else "")
            intent.putExtra("payment_type", if (params.hasKey("payment_type")) params.getString("payment_type") else if (params.hasKey("paymentType")) params.getString("paymentType") else "all")
            intent.putExtra("ignore_payment_type", if (params.hasKey("ignore_payment_type")) params.getString("ignore_payment_type") else if (params.hasKey("ignorePaymentType")) params.getString("ignorePaymentType") else "")
            
            // Handle display_promo as String. Check for boolean or string input.
            var displayPromoStr = "yes"
            if (params.hasKey("display_promo")) {
                if (params.getType("display_promo") == ReadableType.Boolean) {
                    displayPromoStr = if (params.getBoolean("display_promo")) "yes" else "no"
                } else {
                    displayPromoStr = params.getString("display_promo") ?: "yes"
                }
            } else if (params.hasKey("displayPromo")) {
                if (params.getType("displayPromo") == ReadableType.Boolean) {
                    displayPromoStr = if (params.getBoolean("displayPromo")) "yes" else "no"
                } else {
                    displayPromoStr = params.getString("displayPromo") ?: "yes"
                }
            }
            intent.putExtra("display_promo", displayPromoStr)

            intent.putExtra("promo_code", if (params.hasKey("promo_code")) params.getString("promo_code") else if (params.hasKey("promoCode")) params.getString("promoCode") else "")
            intent.putExtra("promo_sku_code", if (params.hasKey("promo_sku_code")) params.getString("promo_sku_code") else if (params.hasKey("promoSkuCode")) params.getString("promoSkuCode") else "")
            intent.putExtra("displayDialog", if (params.hasKey("display_dialog")) params.getString("display_dialog") else if (params.hasKey("displayDialog")) params.getString("displayDialog") else "FULL")
            
            // 3. Environment & Styling
            intent.putExtra("payment_environment", if (params.hasKey("payment_environment")) params.getString("payment_environment") else if (params.hasKey("environment")) params.getString("environment") else "production")
            intent.putExtra("app_color", if (params.hasKey("app_color")) params.getString("app_color") else if (params.hasKey("appColor")) params.getString("appColor") else "#1F46BD")
            intent.putExtra("font_color", if (params.hasKey("font_color")) params.getString("font_color") else if (params.hasKey("fontColor")) params.getString("fontColor") else "#FFFFFF")

            // 4. Handle Nested SIInfo
            if (params.hasKey("si_info") && !params.isNull("si_info")) {
                val siInfoMap = params.getMap("si_info")
                val siHashMap = HashMap<String, String?>()
                
                val iterator = siInfoMap!!.keySetIterator()
                while (iterator.hasNextKey()) {
                    val key = iterator.nextKey()
                    siHashMap[key] = siInfoMap.getString(key)
                }
                intent.putExtra("si_info", siHashMap as Serializable)
            } else if (params.hasKey("siInfo") && !params.isNull("siInfo")) {
                 val siInfoMap = params.getMap("siInfo")
                 val siHashMap = HashMap<String, String?>()
                 
                 val iterator = siInfoMap!!.keySetIterator()
                 while (iterator.hasNextKey()) {
                     val key = iterator.nextKey()
                     siHashMap[key] = siInfoMap.getString(key)
                 }
                 intent.putExtra("si_info", siHashMap as Serializable)
            }
            
            activity.startActivity(intent)
            
        } catch (e: Exception) {
            Log.e("CCAvenueModule", "Exception validating params or launching activity", e)
            promise.reject("INIT_ERROR", e.message)
        }
    }
}