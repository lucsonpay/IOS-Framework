//
//  ViewController.swift
//  GatewayDemo
//
//  Created by iOS Dev on 17/03/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import PaymentGateway

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var paymentModeSegment: UISegmentedControl!
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.makePayement()
        return true
    }
    
    @IBAction func makePayement() {
        self.view.endEditing(true)
        
        var mode: PGPaymentMode = .All

        switch paymentModeSegment.selectedSegmentIndex {
        case 0:
            mode = .All
        case 1:
            mode = .CreditCard
        case 2:
            mode = .DebitCard
        case 3:
            mode = .NetBanking
        case 4:
            mode = .Wallet
        default:
            mode = .None
        }
        
        let amount = Int(amountTextField.text ?? "200") ?? 200
        
        // Switch ON for LIVE environment //
        let gatewayURL = "https://uat.bhartipay.com/crm/jsp/paymentrequest"
        let returnURL = "https://uat.bhartipay.com/crm/jsp/sdkResponse.jsp"
        let merchantKey = "8535b0d335e545d4"
        let paymentID = "2001141020561000"
        // Switch ON for LIVE environment //
        
        do {
            let request = try PGRequest(
                gatewayURL: gatewayURL,
                merchantKey: merchantKey,
                merchantName: "BHARTIPAY Live",
                paymentID: paymentID,
                paymentMode: mode,
                currencyCode: "356",
                amount: amount,
                orderID: "\(Int(Date().timeIntervalSince1970))",
                transactionType: "SALE",
                productDesc: "BHARTIPAY Demo Transaction",
                customerName: "BHARTIPAY LIVE",
                customerEmail: "neeeeeraj.kumar@bhartipay.com",
                customerPhone: "9999999999",
                customerAddress: "Gurgaon",
                customerZip: "122016",
                screenTitle: "BhartiPayPG",
                returnURL: returnURL)
            
            Gateway.initiateTransaction(request: request, delegate: self, controller: self)
        } catch {
            print(error)
        }
    }
}



extension ViewController: PaymentGatewayDelegate {
    
    func transactionError(errorType: PGErrorType, message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func transactionResponse(response: PGResponse) {
        let alert = UIAlertController(title: response.status, message: response.responseMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
