//
//  GZip.h
//  iOSCustomBrowser
//
//  Created by Suryakant Sharma on 21/04/15.
//  Copyright (c) 2015 PayU, India. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (GZip)

- (NSData *)gzippedDataWithCompressionLevel:(float)level;
- (NSData *)gzippedData;
- (NSData *)gunzippedData;

@end