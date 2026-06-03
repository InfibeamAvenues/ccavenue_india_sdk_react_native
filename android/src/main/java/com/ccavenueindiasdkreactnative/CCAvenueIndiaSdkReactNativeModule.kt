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
            
           
            intent.putExtra("accessCode", if (params.hasKey("accessCode")) params.getString("accessCode") else "")
            intent.putExtra("encRequest", if (params.hasKey("encRequest")) params.getString("encRequest") else "")
            intent.putExtra("paymentEnvironment", if (params.hasKey("paymentEnvironment")) params.getString("paymentEnvironment") else if (params.hasKey("paymentEnvironment")) params.getString("paymentEnvironment") else "production")
            intent.putExtra("appColor", if (params.hasKey("appColor")) params.getString("appColor") else if (params.hasKey("appColor")) params.getString("appColor") else "#1F46BD")
            intent.putExtra("fontColor", if (params.hasKey("fontColor")) params.getString("fontColor") else if (params.hasKey("fontColor")) params.getString("fontColor") else "#FFFFFF")

            activity.startActivity(intent)
            
        } catch (e: Exception) {
            Log.e("CCAvenueModule", "Exception validating params or launching activity", e)
            promise.reject("INIT_ERROR", e.message)
        }
    }
}