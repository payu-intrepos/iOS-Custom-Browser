//
//  CBConnection.h
//  PayUTestApp
//
//  Created by Umang Arya on 20/07/15.
//  Copyright (c) 2015 PayU, India. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CBConstant.h"
#import "PayUCBWebViewResponseDelegate.h"

#define kNavBarHeight 64.0

/*!
 * This class is used provide CB functionality to the merchant.
 */
@interface CBConnection : NSObject

//@property (nonatomic, assign) BOOL isWKWebView;
@property (nonatomic, assign) BOOL isMagicRetry;
@property (nonatomic, copy) NSString *cbServerID;
@property (nonatomic, copy) NSString *analyticsServerID;
@property (nonatomic, copy) NSString *txnID;
@property (nonatomic, copy) NSString *merchantKey;
@property (weak, nonatomic) id <PayUCBWebViewResponseDelegate> cbWebViewResponseDelegate;
@property (nonatomic, assign) BOOL isAutoOTPSelect;
@property (nonatomic, assign) PUCBBankSimulator bankSimulatorType;

/*!
 * calling init on this class is not allowed
 */
- (instancetype) init ATTRIBUTE_INIT;
- (instancetype) new ATTRIBUTE_NEW;

/*!
 * This method is called from Merchant's App to initialize CB.
 * @param  [view]    [UIView type]
 * @param  [webView] [UIWebView type]
 * @return [obj]     [CBConnection type]
 */
- (instancetype)init:(UIView *)view webView:(UIWebView *) webView;

/*!
 * This method initializes the required properties of CBConnection and setUp the CB to run.
 */
- (void)initialSetup;

/*!
 * This method is used to show the payUActivityIndicator.
 */
- (void)payUActivityIndicator;

/*!
 * This method must be called from UIWebView delegate method from Merchant's App.
 * @param  [webView] [UIWebView type]
 * @param  [request] [NSURLRequest type]
 */
- (void)payUwebView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request;

/*!
 * This method must be called from UIWebView delegate method from Merchant's App.
 * @param  [webView] [UIWebView type]
 * @param  [error]   [NSError type]
 */
- (void)payUwebView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

/*!
 * This method must be called from UIWebView delegate method from Merchant's App.
 * @param  [webView] [UIWebView type]
 */
- (void)payUwebViewDidFinishLoad:(UIWebView *)webView;

@end
