//
//  PUCBSharedDataManager.h
//  PayUNonSeamlessTestApp
//
//  Created by Sharad Goyal on 10/03/16.
//  Copyright © 2016 PayU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBConstant.h"

/*!
 * This class is used to store some data that is available for all classes.
 */
@interface PUCBConfiguration : NSObject

/*!
 * This method returns singleton object.
 * @return [obj]                [PUCBSharedDataManager Type]
 * @see    [initUniqueInstance]
 */
+(instancetype)getSingletonInstance;

+(instancetype) alloc ATTRIBUTE_ALLOC;
-(instancetype) init  ATTRIBUTE_INIT;
+(instancetype) new   ATTRIBUTE_NEW;
+(instancetype) copy  ATTRIBUTE_INIT;

@property (nonatomic, strong) NSString *merchantKey;
@property (nonatomic, strong) NSString *transactionId;
@property (nonatomic, assign) BOOL isMagicRetry;
@property (nonatomic, assign) BOOL isAutoOTPSelect;
@property (nonatomic, assign) BOOL shouldShowPayULoader;
@property (nonatomic, assign) PUCBBankSimulator bankSimulatorType;

@end

