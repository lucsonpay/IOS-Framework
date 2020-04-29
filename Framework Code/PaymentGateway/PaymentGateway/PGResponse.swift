//
//  PGResponse.swift
//  PaymentGateway
//
//  Created by iOS Dev on 24/03/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation

public class PGResponse {
    
    public private(set) var responseCode: String?
    public private(set) var responseMessage: String?
    public private(set) var responseDateTime: String?
    public private(set) var customerName: String?
    public private(set) var customerEmail: String?
    public private(set) var customerPhone: String?
    public private(set) var status: String?
    public private(set) var amount: Int?
    public private(set) var orderID: String?
    public private(set) var paymentID: String?
    public private(set) var productDesc: String?
    public private(set) var currencyCode: String?
    public private(set) var transactionID: String?
    public private(set) var transactionType: String?
    public private(set) var hash: String?
    public private(set) var returnURL: String?
    
    
    
    /* Required initializer to parse response in a data-model */
    internal required init(response: JSON) {
        self.responseCode = JSONUtility.stringValue(response["RESPONSE_CODE"])
        self.responseMessage = JSONUtility.stringValue(response["RESPONSE_MESSAGE"])
        self.responseDateTime = JSONUtility.stringValue(response["RESPONSE_DATE_TIME"])
        self.customerName = JSONUtility.stringValue(response["CUST_NAME"])
        self.customerEmail = JSONUtility.stringValue(response["CUST_EMAIL"])
        self.customerPhone = JSONUtility.stringValue(response["CUST_PHONE"])
        self.status = JSONUtility.stringValue(response["STATUS"])
        self.amount = JSONUtility.intValue(response["AMOUNT"])
        self.orderID = JSONUtility.stringValue(response["ORDER_ID"])
        self.paymentID = JSONUtility.stringValue(response["PAY_ID"])
        self.productDesc = JSONUtility.stringValue(response["PRODUCT_DESC"])
        self.currencyCode = JSONUtility.stringValue(response["CURRENCY_CODE"])
        self.transactionID = JSONUtility.stringValue(response["TXN_ID"])
        self.transactionType = JSONUtility.stringValue(response["TXNTYPE"])
        self.hash = JSONUtility.stringValue(response["HASH"])
        self.returnURL = JSONUtility.stringValue(response["RETURN_URL"])
    }
}
