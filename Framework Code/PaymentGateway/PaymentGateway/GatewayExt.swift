//
//  GatewayExt.swift
//  PaymentGateway
//
//  Created by iOS Dev on 24/03/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import Foundation

public class Gateway {
    
    /* Abstract layer method */
    public class func initiateTransaction(request: PGRequest,
                                          delegate: PaymentGatewayDelegate,
                                          controller: UIViewController) {
        
        Gateway.startTransaction(pgRequest: request,
                                 pgDelegate: delegate,
                                 pgController: controller)
    }
}



fileprivate extension Gateway {
    
    /* Validate provided parameters & redirect user to payment page */
    class func startTransaction(pgRequest: PGRequest,
                                pgDelegate: PaymentGatewayDelegate,
                                pgController: UIViewController) {
        if let request = Gateway.urlRequest(pgExRequest: pgRequest) {
            paymentGatewayDelegate = pgDelegate
            
            let controller = Gateway.webController()
            controller.navigationItem.title = pgScreenTitle
            controller.urlRequest = request
            pgController.present(controller.navigationController!, animated: true, completion:  nil)
        } else {
            pgDelegate.transactionError(errorType: .UnableToCreateRequest, message: "There's some issue in loading payment page with the provided parameters")
        }
    }
    
    
    /* Returns ***> URLRequest <*** object if created successfully from parameters, else returns nil */
    private class func urlRequest(pgExRequest: PGRequest) -> URLRequest? {
        let urlString = pgPaymentURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30.0)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = pgPostData
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
    
    
    /* Returns ***> WebViewController <*** instance added on a UINavigationController's stack */
    private class func webController() -> WebViewController {
        let bundle = Bundle(for: WebViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let navCtrl = storyboard.instantiateViewController(withIdentifier: "WebNavigationController") as! UINavigationController
        return navCtrl.viewControllers.first as! WebViewController
    }
}
