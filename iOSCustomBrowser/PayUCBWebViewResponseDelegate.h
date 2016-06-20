//
//  PayUCBWebViewResponseDelegate.h
//  PayUNonSeamlessTestApp
//
//  Created by Vipin Aggarwal on 13/05/16.
//  Copyright © 2016 PayU. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * This protocol defines methods to get callback for transaction status.
 */
@protocol PayUCBWebViewResponseDelegate <NSObject>

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

@end
