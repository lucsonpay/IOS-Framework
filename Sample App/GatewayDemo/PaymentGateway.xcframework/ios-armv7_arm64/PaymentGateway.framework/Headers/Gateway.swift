//
//  Gateway.swift
//  PaymentGateway
//
//  Created by iOS Dev on 17/03/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import Foundation



// MARK:- Mode Of Payment
public enum PGPaymentMode {
    case None // This is default one.
    // NOTE: ***> USE / KEEP / DON'T CHANGE <*** it until your merchant configuration allows/supports below mentioned options
    
    
    // NOTE: You can choose following option, only if that is supported by your merchant's configuration.
    
    case All // Use this if you want the user to select their option on the payment page
    
    case CreditCard // Use this if you want to directly open "Credit Card" payment only mode on payment page
    
    case DebitCard // Use this if you want to directly open "Debit Card" payment only mode on payment page
    
    case NetBanking // Use this if you want to directly open "Net Banking" payment only mode on payment page
    
    case Wallet // Use this if you want to directly open "Wallet" payment only mode on payment page
}



// MARK:- Categorization of error based on its nature/source
public enum PGErrorType {
    case DismissedByUser // User tapped on "Cancel" button
    
    case InvalidResponse // Unable to parse final response JSON
    
    case UnableToCreateRequest // Unable to create request to initiate transaction with the provided parameters
    
    case UnableToLoadPage // Technical/Network error due to which page failed to load
}



// MARK:- Protocol interface to provide call-backs on transaction completion or failures
public protocol PaymentGatewayDelegate: class {
    
    /* Implement this to get response model, which is retrieved from ***> ReturnURL <*** */
    func transactionResponse(response: PGResponse)
    
    /* Implement this to handle all the error/failure cases */
    func transactionError(errorType: PGErrorType, message: String)
}
