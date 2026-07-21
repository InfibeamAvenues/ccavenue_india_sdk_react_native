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
        handleIntent()
    }

    private fun handleIntent() {
        // 1. Core Parameters
        val accessCode = intent.getStringExtra("accessCode") ?: ""
        val encRequest = intent.getStringExtra("encRequest") ?: ""
        val appColor = intent.getStringExtra("appColor") ?: "#1F46BD"
        val fontColor = intent.getStringExtra("fontColor") ?: "#FFFFFF"
        val envString = intent.getStringExtra("paymentEnvironment") ?: "production"
        val encryptionMode = intent.getStringExtra("encryptionMode") ?: ""
        try {
            val orderDetails = CCAvenueOrder()
            // Core Data
            orderDetails.accessCode = accessCode
            orderDetails.encRequest = encRequest
            orderDetails.appColor = appColor
            orderDetails.fontColor = fontColor
            orderDetails.paymentEnvironment =  envString
            orderDetails.encryptionMode =  encryptionMode
 
            CCAvenueSDK.initTransaction(this, orderDetails)

        } catch (e: Exception) {
            Log.e("CCAvenueWrapper", "Initialization Error", e)
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