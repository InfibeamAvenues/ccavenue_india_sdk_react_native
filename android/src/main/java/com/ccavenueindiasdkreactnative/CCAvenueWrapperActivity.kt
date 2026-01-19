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
        val amount = intent.getStringExtra("amount") ?: ""
        val currency = intent.getStringExtra("currency") ?: "INR"
        val trackingId = intent.getStringExtra("trackingId") ?: ""
        val requestHash = intent.getStringExtra("requestHash") ?: ""
        val accessCode = intent.getStringExtra("accessCode") ?: ""
        
        // 2. Optional / UI Parameters
        val customerId = intent.getStringExtra("customer_id") ?: ""
        val paymentType = intent.getStringExtra("payment_type") ?: "all"
        val ignorePaymentOption = intent.getStringExtra("ignore_payment_option") ?: ""
        val promoCode = intent.getStringExtra("promo_code") ?: ""
        val promoSkuCode = intent.getStringExtra("promo_sku_code") ?: ""
        val displayDialog = intent.getStringExtra("display_dialog") ?: "FULL"
        val displayPromo = intent.getBooleanExtra("display_promo", true)
        val appColor = intent.getStringExtra("app_color") ?: "#1F46BD"
        val fontColor = intent.getStringExtra("font_color") ?: "#FFFFFF"

        // 3. Environment Mapping
        val rawEnv = intent.getStringExtra("payment_environment") ?: "LIVE"
        val paymentEnvironment = when (rawEnv.uppercase()) {
            "LOCAL" -> "app_local"
            "STAGING" -> "test"
            "LIVE" -> "live"
            else -> "live"
        }

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
            
            // New Fields
            orderDetails.ignorePaymentType = ignorePaymentOption
            orderDetails.promoCode = promoCode
            orderDetails.promoSkuCode = promoSkuCode
            orderDetails.displayPromo = if (displayPromo) "true" else "false"
            orderDetails.displayDialog = displayDialog
            orderDetails.appColor = appColor
            orderDetails.fontColor = fontColor

            // 4. Handle Nested SIInfo
            val siMap = intent.getSerializableExtra("si_info") as? Map<String, String?>
            if (siMap != null) {
                orderDetails.siStartDate = siMap["si_start_date"]
                orderDetails.siEndDate = siMap["si_end_date"]
                orderDetails.siType = siMap["si_type"]
                orderDetails.siAmount = siMap["si_amount"]
                orderDetails.siMerRefNo = siMap["si_merchant_ref_no"]
                orderDetails.siIsSetupAmt = siMap["si_setup_amount"]
                orderDetails.siBillCycle = siMap["si_bill_cycle"]
                orderDetails.siFrequency = siMap["si_frequency"]
                orderDetails.siFrequencyType = siMap["si_frequency_type"]
                orderDetails.SI_UpIMandateExecute = siMap["si_upi_mandate"]
                orderDetails.SI_UpiDebitRule = siMap["si_upi_debit_rule"]
                
            }

            Log.d("CCAvenueWrapper", "Launching Payment Environment: $paymentEnvironment")
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