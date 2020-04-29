//
//  WebViewController.swift
//  PaymentGateway
//
//  Created by iOS Dev on 17/03/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import WebKit

internal class WebViewController: UIViewController {
    
    // MARK:- Properties declaration
    
    /* URLRequest to load initial transaction page */
    var urlRequest: URLRequest!
    
    /* WebView instance for loading transaction pages */
    private let webKitView: WKWebView = WKWebView(frame: CGRect.zero)
    
    /* Spinner/Loader which starts when page is loading */
    @IBOutlet fileprivate weak var loaderView: UIActivityIndicatorView!
    
    
    
    // MARK:- Controller's life-cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding WebView on controller programatically because of a known WKWebView's compatiblity issue on previous iOS versions
        webKitView.frame = self.view.bounds
        self.view.addSubview(webKitView)
        webKitView.translatesAutoresizingMaskIntoConstraints = false
        webKitView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webKitView.navigationDelegate = self
        
        // Bring loaderView on top, so that it won't hide behind WebView
        self.view.bringSubviewToFront(loaderView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Set WebView frames to cover whole screen
        webKitView.frame = self.view.bounds
        loaderView.startAnimating()
        
        // Start loading payment page
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
            self.webKitView.load(self.urlRequest)
        })
    }
    
    
    
    // MARK:- Functionalities & Actions
    
    /* "Cancel" button action */
    @IBAction func cancelAction() {
        // Dismiss payment screen
        dismissWithError(errorType: .DismissedByUser, message: "Controller dismissed by user")
    }
    
    /* Dismiss payment page in case error/failure occured */
    func dismissWithError(errorType: PGErrorType, message: String) {
        // Stop loading
        webKitView.navigationDelegate = nil
        webKitView.stopLoading()
        if loaderView.isAnimating {
            loaderView.stopAnimating()
        }
        
        // Dismiss payment screen
        self.navigationController?.dismiss(animated: true, completion: {
            paymentGatewayDelegate.transactionError(errorType: errorType, message: message)
        })
    }
    
    /* Dismiss payment page in case response recieved */
    func dismissWithResponse(response: PGResponse) {
        // Stop loading
        webKitView.navigationDelegate = nil
        webKitView.stopLoading()
        if loaderView.isAnimating {
            loaderView.stopAnimating()
        }
        
        // Dismiss payment screen
        self.navigationController?.dismiss(animated: true, completion: {
            paymentGatewayDelegate.transactionResponse(response: response)
        })
    }
}



// MARK:- Extension containig WebView's delegate methods
extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let statusCode = (navigationResponse.response as? HTTPURLResponse)?.statusCode {
            if (statusCode >= 200) && (statusCode < 300) {
                decisionHandler(.allow)
                return
            }
        }
        
        decisionHandler(.cancel)
        dismissWithError(errorType: .UnableToLoadPage, message: "Response status code is not within range 200~299")
    }
    
    
    // Request page did Start Loading
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        loaderView.startAnimating()
    }
    
    
    // Request page did Finish Loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loaderView.stopAnimating()
        
        if let url = webView.url?.absoluteString, url == pgReturnURL {
            // Getting response by evaluating JavaScript in WebView body
            webView.evaluateJavaScript("document.getElementById(\"parameters\").innerHTML", completionHandler: { (jsonString, error) in
                
                if let dict = JSONUtility.stringToJSON(string: jsonString as! String) {
                    self.dismissWithResponse(response: PGResponse(response: dict))
                } else {
                    self.dismissWithError(errorType: .InvalidResponse, message: "Either response is not a valid JSON, or it is corrupt")
                }
            })
        }
    }
    
    
    // Request page failed to Load
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        dismissWithError(errorType: .UnableToLoadPage, message: error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        dismissWithError(errorType: .UnableToLoadPage, message: error.localizedDescription)
    }
}
