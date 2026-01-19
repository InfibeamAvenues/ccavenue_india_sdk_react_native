package com.ccavenueindiasdkreactnative

import android.app.Activity
import android.content.Intent
import android.util.Log
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.Promise

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
        
        val currentActivity = getCurrentActivity()
        if (currentActivity == null) {
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
            val intent = Intent(currentActivity, CCAvenueWrapperActivity::class.java)
            
            // Required fields
            intent.putExtra("accessCode", params.getString("accessCode") ?: "")
            intent.putExtra("amount", params.getString("amount") ?: "")
            intent.putExtra("currency", params.getString("currency") ?: "INR")
            intent.putExtra("trackingId", params.getString("trackingId") ?: "")
            intent.putExtra("requestHash", params.getString("requestHash") ?: "")
            
            // Optional fields
            intent.putExtra("payment_type", params.getString("paymentType") ?: "all")
            intent.putExtra("payment_environment", params.getString("environment") ?: "app_local")
            intent.putExtra("customer_id", if (params.hasKey("customerId")) params.getString("customerId") ?: "" else "")
            
            // Customization
            intent.putExtra("app_color", if (params.hasKey("appColor")) params.getString("appColor") ?: "" else "")
            intent.putExtra("font_color", if (params.hasKey("fontColor")) params.getString("fontColor") ?: "" else "")
            
            currentActivity.startActivity(intent)
            
        } catch (e: Exception) {
            Log.e("CCAvenueModule", "Exception validating params or launching activity", e)
            promise.reject("INIT_ERROR", e.message)
        }
    }
}
