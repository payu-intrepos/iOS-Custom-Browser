//
//  PUUIViewController.h
//  PayUNonSeamlessTestApp
//
//  Created by Vipin Aggarwal on 11/03/16.
//  Copyright © 2016 PayU. All rights reserved.
//

#import "PayU_CB_SDK.h"
#import <WebKit/WebKit.h>
#import "PUCBConfiguration.h"

NS_ENUM(NSInteger) {
    PUCBNilArgument = 100,
    PUCBInvalidMerchantKey = 101,
    PUCBBankSimulatorNotSupported = 102
};


@protocol PUCBWebVCDelegate <NSObject>

@required
/*!
 * This method gets called when transaction is successfull. It logs txn_success event.
 * @param [response]            [id type]
 */
- (void)PayUSuccessResponse:(id)response;

/*!
 * This method gets called when transaction fails. It logs txn_fail event.
 * @param [response]            [id type]
 */
- (void)PayUFailureResponse:(id)response;

/*!
 * This method gets called in case of network error
 * @param [notification]            [NSDictionary type]
 */
- (void)PayUConnectionError:(NSDictionary *)notification;

/*!
 * This method gets called in case of transaction is cancelled by Back press
 */
- (void)PayUTransactionCancel;

@optional
/*!
 * This method gets called when user presses back button
 * You must return NO from this if you want to show your own view (like alert)
 */
- (void)shouldDismissVCOnBackPress;

@end


@interface PUCBWebVC : UIViewController <UIWebViewDelegate, WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate>

@property (strong, nonatomic) UIWebView *vwWebView;
@property (strong, nonatomic) WKWebView *vwWKWebView;
@property (weak, nonatomic) id <PUCBWebVCDelegate> cbWebVCDelegate;

/*!
 * Following initializers are not available for this class.
 * To create instance, use designated initializers
 */
-(instancetype) init ATTRIBUTE_INIT;
+(instancetype) new ATTRIBUTE_NEW;


/*!
 * This method is the designated initializer of this class
 * @param [postParam]            [NSMutableURLRequest type]
 * @param [url]                  [NSURL type]
 */
- (instancetype)initWithPostParam:(NSString*)postParam
                        url:(NSURL*)url
                merchantKey:(NSString*)key
                            error:(NSError**)error;

- (instancetype)initWithNSURLRequest:(NSURLRequest*)request
                         merchantKey:(NSString*)key
                               error:(NSError**)error;

@end
