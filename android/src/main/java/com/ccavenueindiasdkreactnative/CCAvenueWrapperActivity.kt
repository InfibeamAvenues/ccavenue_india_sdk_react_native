package com.ccavenueindiasdkreactnative

import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.ccavenue.indiasdk.CCAvenueOrder
import com.ccavenue.indiasdk.CCAvenueSDK
import com.ccavenue.indiasdk.CCAvenueTransactionCallback
import com.ccavenue.indiasdk.model.CCAvenueResponseCallback

class CCAvenueWrapperActivity : AppCompatActivity(), CCAvenueTransactionCallback {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // No custom UI
        handleIntent()
    }

    private fun handleIntent() {
        val amount = intent.getStringExtra("amount") ?: ""
        val currency = intent.getStringExtra("currency") ?: "INR"
        val trackingId = intent.getStringExtra("trackingId") ?: ""
        val requestHash = intent.getStringExtra("requestHash") ?: ""
        val accessCode = intent.getStringExtra("accessCode") ?: ""
        // val merchantId = intent.getStringExtra("mId") ?: "" // If used by SDK in future
        val orderId = intent.getStringExtra("order_id") ?: ""
        val customerId = intent.getStringExtra("customer_id") ?: ""

        val paymentType = intent.getStringExtra("payment_type") ?: "all"
        val rawEnv = intent.getStringExtra("payment_environment") ?: "app_local"
        val paymentEnvironment = when (rawEnv.uppercase()) {
            "LOCAL" -> "app_local"
            "STAGING" -> "test"
            "LIVE" -> "live"
            else -> rawEnv
        }
        Log.d("CCAvenueWrapper", "Mapped Environment: $rawEnv -> $paymentEnvironment")
        val appColor = intent.getStringExtra("app_color") ?: ""
        val fontColor = intent.getStringExtra("font_color") ?: ""
        val displayPromo = intent.getBooleanExtra("display_promo", true)

        Log.d("CCAvenueWrapper", "Launching Payment for TrackingID: $trackingId")

        try {
            val orderDetails = CCAvenueOrder()
            orderDetails.accessCode = accessCode
            orderDetails.currency = currency
            orderDetails.amount = amount
            orderDetails.trackingId = trackingId
            orderDetails.requestHash = requestHash
            orderDetails.customerId = customerId
            orderDetails.paymentType = paymentType
            orderDetails.paymentEnvironment = paymentEnvironment
            
            if (appColor.isNotEmpty()) {
                orderDetails.appColor = appColor
            }
            if (fontColor.isNotEmpty()) {
                orderDetails.fontColor = fontColor
            }
           
           CCAvenueSDK.initTransaction(this, orderDetails)

        } catch (e: Exception) {
            Log.e("CCAvenueWrapper", "Init Error", e)
            CcavenueIndiaSdkPlugin.onError?.invoke(e.toString())
            finish()
        }
    }

    override fun onTransactionResponse(response: CCAvenueResponseCallback) {
        Log.d("CCAvenueWrapper", "Response: $response")
        CcavenueIndiaSdkPlugin.onSuccess?.invoke(response.toString())
        finish()
    }
}
