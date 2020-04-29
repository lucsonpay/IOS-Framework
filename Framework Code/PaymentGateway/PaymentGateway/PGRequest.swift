//
//  PGRequest.swift
//  PaymentGateway
//
//  Created by iOS Dev on 24/03/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation

public class PGRequest {
    
    /* Required initializer, to make sure that user is passing valid parameters to SDK */
    public required init(gatewayURL: String,
                         merchantKey: String,
                         merchantName: String,
                         paymentID: String,
                         paymentMode: PGPaymentMode,
                         currencyCode: String,
                         amount: Int,
                         orderID: String,
                         transactionType: String,
                         productDesc: String,
                         customerName: String,
                         customerEmail: String,
                         customerPhone: String,
                         customerAddress: String,
                         customerZip: String,
                         screenTitle: String,
                         returnURL: String) throws {
        
        func customError(message: String) -> Error {
            let errorInfo = [NSLocalizedDescriptionKey: message]
            return NSError(domain: "PaymentGateway.framework", code: -1, userInfo: errorInfo) as Error
        }
        
        if gatewayURL.isEmpty || merchantKey.isEmpty || merchantName.isEmpty
            || paymentID.isEmpty || currencyCode.isEmpty || orderID.isEmpty
            || transactionType.isEmpty || productDesc.isEmpty || customerName.isEmpty
            || customerEmail.isEmpty || customerPhone.isEmpty || customerAddress.isEmpty
            || customerZip.isEmpty || screenTitle.isEmpty || returnURL.isEmpty {
            throw customError(message: "Some of the parameters are blank/empty.")
        }
        
        guard URL(string: gatewayURL) != nil else {
            throw customError(message: "Gateway URL is invalid")
        }
        
        guard URL(string: returnURL) != nil else {
            throw customError(message: "Return URL is invalid")
        }
        
        pgPaymentURL = gatewayURL
        pgReturnURL = returnURL
        
        let bundle = Bundle(for: PGRequest.self)
        let version = (bundle.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "Unknown"
        
        var dict: JSON = ["MERCHANTNAME" : merchantName,
                          "PAY_ID" : paymentID,
                          "CURRENCY_CODE" : currencyCode,
                          "AMOUNT" : amount,
                          "ORDER_ID" : orderID,
                          "TXNTYPE" : transactionType,
                          "PRODUCT_DESC" : productDesc,
                          "CUST_NAME" : customerName,
                          "CUST_EMAIL" : customerEmail,
                          "CUST_PHONE" : customerPhone,
                          "CUST_STREET_ADDRESS1" : customerAddress,
                          "CUST_ZIP" : customerZip,
                          "RETURN_URL" : pgReturnURL,
                          "App_Model" : "iOSSDK {\(version)}"]
        
        if paymentMode != .None {
            dict.updateValue(paymentType(paymentMode: paymentMode), forKey: "MERCHANT_PAYMENT_TYPE")
        }
        
        let postString = JSONUtility.jsonToString(dictionary: dict)
        let hashKey = Utility.sha256(string: postString + merchantKey)
        let postHashString = postString + "&HASH=" + hashKey
        
        guard let data = postHashString.data(using: .utf8) else {
            throw customError(message: "Some of the parameters are invalid.")
        }
        
        pgPostData = data
        pgScreenTitle = screenTitle
    }
    
    
    /* Returns parameter value for key 'MERCHANT_PAYMENT_TYPE' on the basis of provided payment mode */
    private func paymentType(paymentMode: PGPaymentMode) -> String {
        switch paymentMode {
        case .CreditCard:
            return "CC"
        case .DebitCard:
            return "DC"
        case .NetBanking:
            return "NB"
        case .Wallet:
            return "WL"
        default:
            return "NA"
        }
    }
}
