//
//  Utility.swift
//  PaymentGateway
//
//  Created by iOS Dev on 17/03/19.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
import CommonCrypto



// MARK:- Variable have been outside of class to protect extraction of data from instance.

/* Delegate to call protocol methods on transaction completion or failure */
internal weak var paymentGatewayDelegate: PaymentGatewayDelegate!

/* Main payment URL */
internal var pgPaymentURL: String = ""

/* Return/Response URL to be observed in WebView, to track transaction status */
internal var pgReturnURL: String = ""

/* NavigationBar title for payment page (i.e. WebViewController) */
internal var pgScreenTitle: String = ""

/* Data to be sent in post body of URLRequest */
internal var pgPostData: Data = Data()



// MARK:- Utility class contains generic utility methods
internal class Utility {
    
    /* Returns ***> HASH <*** string created by applying ***> SHA256 Algo <*** on string */
    class func sha256(string: String) -> String {
        let rawString = string.replacingOccurrences(of: "&", with: "~")
        guard let data = rawString.data(using: .utf8, allowLossyConversion: false) else {
            return ""
        }
        
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(data.count), &digest)
        }
        let hashData = Data(bytes: digest)
        let hashString = hashData.map { String(format: "%02x", $0) }.joined()
        return hashString.uppercased()
    }
}
