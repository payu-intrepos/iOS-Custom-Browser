//
//  CBConnectionHandler.m
//  iOSCustomBrowser
//
//  Created by Suryakant Sharma on 20/04/15.
//  Copyright (c) 2015 PayU, India. All rights reserved.
//

#import "CBConnectionHandler.h"
#import "CBAllPaymentOption.h"
#import "CBApproveView.h"
#import "RegenerateOTPView.h"
#import "CBConstant.h"
#import "GZip.h"
#import "CBBankPageLoading.h"


#define INITIALIZEJS @"initializeios.js"

@interface CBConnectionHandler() <NSURLConnectionDelegate>{
    CGRect webViewFrame;
    JSContext *contextIOS;
    CGRect viewBounds;
}

@property (nonatomic,strong) NSOperationQueue *networkQueue;
//@property (nonatomic,assign) float  Version;
//@property (nonatomic,strong) RegenerateOTPView *regenOTPView;
//@property (nonatomic,strong) CBAllPaymentOption *choose;
@end


@implementation CBConnectionHandler

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        _Version = 1.0;
    }
    return self;
}

-(void) runJavaScript:(NSString *)js toWebView:(UIWebView *) webView{
    JSContext *context = nil;
//    if(webView){
//        context = [_resultWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    }
//    else{
        context = [_resultWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    }
    
    // enable error logging
    [context setExceptionHandler:^(JSContext *context, JSValue *value) {
        NSLog(@"WEB JS: %@", value);
    }];
    
    // give JS a handle to our PayUPaymentResultViewController(self) instance
    context[@"PayU"] = self;
    // POX
//    context[@"PayU"] = _connectionHandlerDelegate;
    
    NSLog(@"RunJSStr = %@",js);
    NSString *jsStr = [js stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    jsStr = [jsStr stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
    [jsStr stringByAppendingString:@";"];
    NSLog(@"RunJSStr = %@",[jsStr stringByAppendingString:@";"]);
    
    [context evaluateScript:jsStr];
    
}

-(void) runIntializeJSOnWebView{
    NSLog(@"");
    /****-------------Setting JavScript Context-----------***/
    if(!_isBankFound){
        // get JSContext from UIWebView instance
        JSContext *context = [_resultWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        
        // enable error logging
        [context setExceptionHandler:^(JSContext *context, JSValue *value) {
            NSLog(@"WEB JS: %@", value);
        }];
        
        // give JS a handle to our PayUPaymentResultViewController(self) instance
        // POX
        context[@"PayU"] = self;
//        context[@"PayU"] = _connectionHandlerDelegate;
        
        //        [context evaluateScript:[_handler.initializeJavascriptDict valueForKey:DETECT_BANK_KEY]];
        NSString *initializeJSStr = [[self.initializeJavascriptDict valueForKey:DETECT_BANK_KEY]
                                     stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        if(initializeJSStr){
            initializeJSStr = [initializeJSStr stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
            [initializeJSStr stringByAppendingString:@";"];
            NSLog(@"initializeJSStr = %@",[initializeJSStr stringByAppendingString:@";"]);
            [context evaluateScript:[initializeJSStr stringByAppendingString:@";"]];
        }
    }
    else if (_isBankFound){
        [self bankFound:_bankName];
    }
    
}

- (void) runBankSpecificJSOnWebView{
    NSLog(@"runBankSpecificJSOnWebView");
    
    // get JSContext from UIWebView instance
    JSContext *context = [_resultWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // enable error logging
    [context setExceptionHandler:^(JSContext *context, JSValue *value) {
        NSLog(@"WEB JS: %@", value);
    }];
    
    // give JS a handle to our PayUPaymentResultViewController(self) instance
    context[@"PayU"] = self;
    // POX
//    context[@"PayU"] = _connectionHandlerDelegate;
    
    //    [context evaluateScript:[_handler.bankSpecificJavaScriptDict valueForKey:DETECT_BANK_KEY]];
    
    NSString *initializeJSStr = [[self.bankSpecificJavaScriptDict valueForKey:INIT]
                                 stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    initializeJSStr = [initializeJSStr stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
    [initializeJSStr stringByAppendingString:@";"];
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        NSLog(@"iOS :7");
        //initializeJSStr = [initializeJSStr stringByReplacingOccurrencesOfString:@"[name=frmAcsOption]" withString:@""];
    }
    
    NSLog(@"BankSpecificPage = %@",[initializeJSStr stringByAppendingString:@";"]);
    [context evaluateScript:[initializeJSStr stringByAppendingString:@";"]];
}


-(void) downloadInitializeJS{
    NSLog(@"");
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CB_MOBILE_TEST_URL,INITIALIZEJS]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    _networkQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:_networkQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"data = %@",data);
        NSData *gunzipdata =  [data gunzippedData];
        
        NSUInteger len = [gunzipdata length];
        Byte *byteData = (Byte*)malloc(len);
        memcpy(byteData, [gunzipdata bytes], len);
        NSMutableString *jsonStr = [[NSMutableString alloc] init];
        //char *charactor = malloc(len);
        int c;
        int i = 0;
        while(len != i){
            c = byteData[i];
            if(i % 2 == 0) {
                [jsonStr appendFormat:@"%c",((char) (c - ((i % 5) + 1)))];
                //charactor[i] =  (char)(c - ((i % 5) + 1));
            } else {
                [jsonStr appendFormat:@"%c",((char) (c + ((i % 5) + 1)))];
                //charactor[i] =  ((char) (c + ((i % 5) + 1)));
            }
            i++;
        }
//        NSLog(@"Str = %@",jsonStr);
        
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        _initializeJavascriptDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"IinitializeJavascriptDict = %@",_initializeJavascriptDict);

    }];
    
}

- (NSString *) encriptDataToString:(NSData *) gunzipdata{
    NSLog(@"");
    NSUInteger len = [gunzipdata length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [gunzipdata bytes], len);
    NSMutableString *jsonStr = nil;
    //char *charactor = malloc(len);
    int c;
    int i = 0;
    while(len != i){
        if(nil == jsonStr)
        jsonStr = [[NSMutableString alloc] init];
        
        c = byteData[i];
        
        if(i % 2 == 0) {
            [jsonStr appendFormat:@"%c",((char) (c - ((i % 5) + 1)))];
            //charactor[i] =  (char)(c - ((i % 5) + 1));
        } else {
            [jsonStr appendFormat:@"%c",((char) (c + ((i % 5) + 1)))];
            //charactor[i] =  ((char) (c + ((i % 5) + 1)));
        }
        i++;
    }
    return jsonStr;
}

- (void) downloadBankSpecificJS:(NSString *)bankName{
    NSLog(@"");
    NSMutableString *bankJsFileName = [[_initializeJavascriptDict valueForKey:bankName] mutableCopy];
    [bankJsFileName appendString:@".js"];
//    NSLog(@"downloadBankSpecificJS with Bank Name : %@ URL = %@",bankName,[NSString stringWithFormat:@"%@%@",CB_PRODUCTION_URL,bankJsFileName]);

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CB_MOBILE_TEST_URL,bankJsFileName]];
    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CB_TEST_URL,@"fa5bb08e.js"]];
    NSLog(@"%@",url);
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    _networkQueue = [[NSOperationQueue alloc] init];
    
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:_networkQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"Bank Specfic JS = %@",data);
        NSData *gunzipdata =  [data gunzippedData];
        NSString *jsonStr = [self encriptDataToString:gunzipdata];
        
        NSLog(@"Bank Specfic String = %@",jsonStr);

        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        _bankSpecificJavaScriptDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"_bankSpecificJavaScriptDict = %@",_bankSpecificJavaScriptDict);
        if(_bankSpecificJavaScriptDict){
        [self runBankSpecificJSOnWebView];

        }
    }];
}

- (void) populateRegenerateOption:(UIView *)aView{
    NSLog(@"");
    if(aView){
        [aView removeFromSuperview];
        aView = nil;
    }
    if(_choose){
        [_choose removeFromSuperview];
        _choose = nil;
    }
    if(_approveOTP){
        [_approveOTP removeFromSuperview];
        _approveOTP = nil;
    }
    if(_regenOTPView){
        [_regenOTPView removeFromSuperview];
        _regenOTPView = nil;
    }
    
    // POX
    _regenOTPView = [[RegenerateOTPView alloc] initWithFrame:CGRectMake(0,self.resultView.frame.size.height - 227,SCREEN_WIDTH,227) andCBConnectionHandler:self];
    
    _regenOTPView.bankJS = _bankSpecificJavaScriptDict;
    _regenOTPView.isViewOnScreen = YES;
    _regenOTPView.resultView = _resultView;
    _regenOTPView.retryLbl.hidden = YES;
    _regenOTPView.msgLbl.hidden = NO;
    _regenOTPView.msgLbl.textColor = [UIColor colorWithRed:143.0/255 green:141.0/255 blue:141.0/255 alpha:1];
    _regenOTPView.msgLbl.text = @"Received OTP? You may…";
    [_resultView addSubview:_regenOTPView];
    
    /*
     set webview frames
     */
    if(_connectionHandlerDelegate && [_connectionHandlerDelegate respondsToSelector:@selector(adjustWebViewHeight:)]){
        [_connectionHandlerDelegate adjustWebViewHeight:YES];
    }
}

- (void) addBankLoader{
    
    _loader = [[CBBankPageLoading alloc] initWithFrame:CGRectMake(0,self.resultView.frame.size.height - 227,SCREEN_WIDTH,227) andCBConnectionHandler:self];
    _loader.handler = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_resultView addSubview:_loader];
        [_loader drawCircle:5];
    });

}

- (void) removeIntermidiateLoader{
    
    NSLog(@"removeIntermidiateLoader");
    if(_loader){
        
        [_loader.loadingTimer invalidate];
        _loader.loadingTimer = nil;
        [_loader removeFromSuperview];
        _loader = nil;
    }

}

#pragma mark - JS callbacks

-(void) bankFound:(NSString *)bankName{
    NSLog(@"BankName = %@",bankName);
    if(bankName){
        _bankName = bankName;
        _isBankFound = YES;
        [self downloadBankSpecificJS:bankName];
        if(_connectionHandlerDelegate && [_connectionHandlerDelegate respondsToSelector:@selector(bankNameFound:)]){
            [_connectionHandlerDelegate bankNameFound:bankName];
        }
    }

}

- (void) convertToNative:(NSString *)paymentOption :(NSString *)otherPaymentOptipon{
    dispatch_async(dispatch_get_main_queue(), ^{
    NSLog(@"Payment Option = %@ otherPaymentOptions = %@",paymentOption,otherPaymentOptipon);
    NSData *jsonData = [otherPaymentOptipon dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *optionsDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
//    NSLog(@"optionsDict = %@",optionsDict);
        NSLog(@"Width hgfhfh = %f",SCREEN_WIDTH);
        
    if(NSOrderedSame == [paymentOption caseInsensitiveCompare:ENTER_OTP]){
        NSLog(@"ENTER_OTP");
        if(_approveOTP){
            //[[NSNotificationCenter defaultCenter] removeObserver:_approveOTP];
            // POX
            @try {
                [[NSNotificationCenter defaultCenter] removeObserver:_approveOTP name:UIKeyboardDidShowNotification object:nil];
                [[NSNotificationCenter defaultCenter] removeObserver:_approveOTP name:UIKeyboardDidHideNotification object:nil];
            }
            @catch (id exception) {
                NSLog(@"observer already removed");
                //do nothing, obviously it wasn't attached because an exception was thrown
            }
            NSLog(@"_approveOTP removeFromSuperview");
            [_approveOTP.timer invalidate];
            _approveOTP.timer = nil;
            [_approveOTP removeFromSuperview];
            _approveOTP = nil;
            
        }
        if(_regenOTPView){
            [_regenOTPView removeFromSuperview];
            NSLog(@"_regenOTPView removeFromSuperview");
            _regenOTPView = nil;
        }
        if(_choose){
            [_choose removeFromSuperview];
            NSLog(@"_choose removeFromSuperview");
            _choose = nil;
        }
        
        if(_loader){
            
            [_loader.loadingTimer invalidate];
            _loader.loadingTimer = nil;
            [_loader removeFromSuperview];
            _loader = nil;
        }
        
        // POX
        _approveOTP =  [[CBApproveView alloc] initWithFrame:CGRectMake(0,self.resultView.bounds.size.height - 227,SCREEN_WIDTH,227) andCBConnectionHandler:self];
        
        _approveOTP.bankJS = _bankSpecificJavaScriptDict;
//        CGRect webVFrame = _resultWebView.frame;
//        webViewFrame.size.height= webViewFrame.size.height - 227;
//        _resultWebView.frame = webVFrame;
        [_resultView addSubview:_approveOTP];

//        NSLog(@"loadJavascript first view = %@ ResultView = %@",_approveOTP,_resultView);
        NSLog(@"_approveOTP for ENTER_OTP");
        [_approveOTP startCountDown];
        [_resultView bringSubviewToFront:_approveOTP];
        
        _approveOTP.isViewOnScreen = YES;
        _approveOTP.isRegenAvailable = YES;
        if([[optionsDict valueForKey:@"regenerate"] boolValue] == false && ![_bankName isEqualToString:@"sc"]){
            [_approveOTP.timer invalidate];
            _approveOTP.timer = nil;
            _approveOTP.timerLabel.hidden = YES;
            _approveOTP.isRegenAvailable = NO;
        }
        
        /*
         set webview frams
         */
        if(_connectionHandlerDelegate && [_connectionHandlerDelegate respondsToSelector:@selector(adjustWebViewHeight:)]){
            [_connectionHandlerDelegate adjustWebViewHeight:YES];
        }

    }
    else if (NSOrderedSame == [paymentOption caseInsensitiveCompare:RETRY_OTP]){
        NSLog(@"RETRY_OTP");
        if([optionsDict valueForKey:REGERERATE] && ![_approveOTP.timer isValid]){
            if(_choose){
                [_choose removeFromSuperview];
                NSLog(@"_choose removeFromSuperview");
                _choose = nil;
            }
            if(_approveOTP){
//                [[NSNotificationCenter defaultCenter] removeObserver:_approveOTP];
                // POX
                @try {
                    [[NSNotificationCenter defaultCenter] removeObserver:_approveOTP name:UIKeyboardDidShowNotification object:nil];
                    [[NSNotificationCenter defaultCenter] removeObserver:_approveOTP name:UIKeyboardDidHideNotification object:nil];
                }
                @catch (id exception) {
                    NSLog(@"observer already removed");
                    //do nothing, obviously it wasn't attached because an exception was thrown
                }
                NSLog(@"_approveOTP removeFromSuperview");
                [_approveOTP.timer invalidate];
                _approveOTP.timer = nil;

                [_approveOTP removeFromSuperview];
                _approveOTP = nil;
            }
            if(_regenOTPView){
                [_regenOTPView removeFromSuperview];
                NSLog(@"_regenOTPView removeFromSuperview");
                _regenOTPView = nil;
            }
            
            if(_loader){
                
                [_loader.loadingTimer invalidate];
                _loader.loadingTimer = nil;
                [_loader removeFromSuperview];
                _loader = nil;
            }
            
            _regenOTPView = [[RegenerateOTPView alloc] initWithFrame:CGRectMake(0,self.resultView.bounds.size.height - 227,SCREEN_WIDTH,227) andCBConnectionHandler:self];
            _regenOTPView.bankJS = _bankSpecificJavaScriptDict;
//            _regenOTPView.handler = self;
            _regenOTPView.resultView = _resultView;
            _regenOTPView.retryLbl.hidden = NO;
            _regenOTPView.msgLbl.hidden = NO;
            _regenOTPView.isViewOnScreen = YES;
            [_resultView addSubview:_regenOTPView];
            NSLog(@"_regenOTPView for RETRY_OTP");

            if([[optionsDict valueForKey:REGERERATE] intValue] == 0 || !_regenOTPView.isRegenAvailable)
            {
                _regenOTPView.regenerateOTPBtn.enabled = NO;
                _regenOTPView.regenerateOTPBtn.alpha = 0.5;
            }
            /*
             set webview frames
             */
            if(_connectionHandlerDelegate && [_connectionHandlerDelegate respondsToSelector:@selector(adjustWebViewHeight:)]){
                NSLog(@"webview adjusted");
                [_connectionHandlerDelegate adjustWebViewHeight:YES];
            }
        }
        else{
            _regenOTPView.isRegenAvailable = [optionsDict valueForKey:REGERERATE];
        }
    }
    else if(NSOrderedSame == [paymentOption caseInsensitiveCompare:CHOOSE]){
        NSLog(@"CHOOSE");
        if(_choose){
            [_choose removeFromSuperview];
            NSLog(@"_choose removeFromSuperview");
            _choose = nil;
        }
        
        if(_loader){
            
            [_loader.loadingTimer invalidate];
            _loader.loadingTimer = nil;
            [_loader removeFromSuperview];
            _loader = nil;
        }
        
        if(_approveOTP){
            //[[NSNotificationCenter defaultCenter] removeObserver:_approveOTP];
            // POX
            @try {
                [[NSNotificationCenter defaultCenter] removeObserver:_approveOTP name:UIKeyboardDidShowNotification object:nil];
                [[NSNotificationCenter defaultCenter] removeObserver:_approveOTP name:UIKeyboardDidHideNotification object:nil];
            }
            @catch (id exception) {
                NSLog(@"observer already removed");
                //do nothing, obviously it wasn't attached because an exception was thrown
            }
            [_approveOTP.timer invalidate];
            _approveOTP.timer = nil;

            [_approveOTP removeFromSuperview];
            NSLog(@"_approveOTP removeFromSuperview");
            _approveOTP = nil;
        }
        if(_regenOTPView){
            [_regenOTPView removeFromSuperview];
            NSLog(@"_regenOTPView removeFromSuperview");
            _regenOTPView = nil;
        }

        // POX
        _choose = [[CBAllPaymentOption alloc] initWithFrame:CGRectMake(0,self.resultView.bounds.size.height - 227,self.resultView.frame.size.width,227) andCBConnectionHandler:self];
        
        _choose.bankJS = _bankSpecificJavaScriptDict;
        _choose.retryLabel.hidden = YES;
        
        if([[optionsDict valueForKey:PIN] intValue] == 0)
        {
            _choose.passwordBtn.enabled = NO;
        }
        if([[optionsDict valueForKey:OTP] intValue] == 0){
            _choose.smsotpBtn.enabled = NO;
        }

//        NSLog(@"loadJavascript AllOptionView view = %@ ResultView = %@",_choose,_resultView);
        NSLog(@"_resultView for CHOOSE");
        [_resultView addSubview:_choose];
        if(_connectionHandlerDelegate && [_connectionHandlerDelegate respondsToSelector:@selector(adjustWebViewHeight:)]){
            [_connectionHandlerDelegate adjustWebViewHeight:YES];
        }
        [_resultView bringSubviewToFront:_choose];
        // view getting display late so call setNeedDisplay.
        _choose.isViewOnScreen = YES;
        
    }
    else if(NSOrderedSame == [paymentOption caseInsensitiveCompare:INCORRECT_PIN]){
        
//        if([[optionsDict valueForKey:PIN] intValue] == 0)
//        {
//            _choose.passwordBtn.enabled = NO;
//        }
        NSLog(@"INCORRECT_PIN");
        if(_choose){
            [_choose removeFromSuperview];
            NSLog(@"_choose removeFromSuperview");
            _choose = nil;
        }
        
        if(_loader){
            
            [_loader.loadingTimer invalidate];
            _loader.loadingTimer = nil;
            [_loader removeFromSuperview];
            _loader = nil;
        }
        
        if(_approveOTP){
            //[[NSNotificationCenter defaultCenter] removeObserver:_approveOTP];
            // POX
            @try {
                [[NSNotificationCenter defaultCenter] removeObserver:_approveOTP name:UIKeyboardDidShowNotification object:nil];
                [[NSNotificationCenter defaultCenter] removeObserver:_approveOTP name:UIKeyboardDidHideNotification object:nil];

            }
            @catch (id exception) {
                NSLog(@"observer already removed");
                //do nothing, obviously it wasn't attached because an exception was thrown
            }
            [_approveOTP.timer invalidate];
            _approveOTP.timer = nil;

            [_approveOTP removeFromSuperview];
            NSLog(@"_approveOTP removeFromSuperview");
            _approveOTP = nil;
        }
        if(_regenOTPView){
            [_regenOTPView removeFromSuperview];
            NSLog(@"_regenOTPView removeFromSuperview");
            _regenOTPView = nil;
        }
        
        //POX
        _choose = [[CBAllPaymentOption alloc] initWithFrame:CGRectMake(0,self.resultView.bounds.size.height - 227,self.resultView.frame.size.width,227) andCBConnectionHandler:self];
        
        _choose.bankJS = _bankSpecificJavaScriptDict;
//        _choose.handler = self;
        _choose.msgLabel.text = @"Incorrect Pin!";
        _choose.retryLabel.hidden = NO;
        _choose.msgLabel.textColor = [UIColor redColor];
//        NSLog(@"loadJavascript AllOptionView view = %@ ResultView = %@",_choose,_resultView);
        NSLog(@"_choose for INCORRECT_PIN");
        [_resultView addSubview:_choose];
        if(_connectionHandlerDelegate && [_connectionHandlerDelegate respondsToSelector:@selector(adjustWebViewHeight:)]){
            [_connectionHandlerDelegate adjustWebViewHeight:YES];
        }
        [_resultView bringSubviewToFront:_choose];
        _choose.isViewOnScreen = YES;

        
    }
    else if(NSOrderedSame == [paymentOption caseInsensitiveCompare:INCORRECT_OTP]){
        NSLog(@"ENTER_OTP");
        if(_approveOTP){
            //[[NSNotificationCenter defaultCenter] removeObserver:_approveOTP];
            // POX
            @try {
                [[NSNotificationCenter defaultCenter] removeObserver:_approveOTP name:UIKeyboardDidShowNotification object:nil];
                [[NSNotificationCenter defaultCenter] removeObserver:_approveOTP name:UIKeyboardDidHideNotification object:nil];
            }
            @catch (id exception) {
                NSLog(@"observer already removed");
                //do nothing, obviously it wasn't attached because an exception was thrown
            }
            NSLog(@"_approveOTP removeFromSuperview");
            [_approveOTP.timer invalidate];
            _approveOTP.timer = nil;
            [_approveOTP removeFromSuperview];
            _approveOTP = nil;
            
        }
        if(_regenOTPView){
            [_regenOTPView removeFromSuperview];
            NSLog(@"_regenOTPView removeFromSuperview");
            _regenOTPView = nil;
        }
        if(_choose){
            [_choose removeFromSuperview];
            NSLog(@"_choose removeFromSuperview");
            _choose = nil;
        }
        
        if(_loader){
            
            [_loader.loadingTimer invalidate];
            _loader.loadingTimer = nil;
            [_loader removeFromSuperview];
            _loader = nil;
        }
        
        // POX
        _approveOTP =  [[CBApproveView alloc] initWithFrame:CGRectMake(0,self.resultView.bounds.size.height - 227,SCREEN_WIDTH,227) andCBConnectionHandler:self];
        
        _approveOTP.bankJS = _bankSpecificJavaScriptDict;
//        CGRect webVFrame = _resultWebView.frame;
//        webViewFrame.size.height= webViewFrame.size.height - 227;
//        _resultWebView.frame = webVFrame;
        [_resultView addSubview:_approveOTP];
        
        //        NSLog(@"loadJavascript first view = %@ ResultView = %@",_approveOTP,_resultView);
        NSLog(@"_approveOTP for ENTER_OTP");
        [_approveOTP startCountDown];
        [_resultView bringSubviewToFront:_approveOTP];
        
        _approveOTP.isViewOnScreen = YES;
        _approveOTP.isRegenAvailable = YES;
        
        if([[optionsDict valueForKey:@"regenerate"] boolValue] == false && ![_bankName isEqualToString:@"sc"]){
            [_approveOTP.timer invalidate];
            _approveOTP.timer = nil;
            _approveOTP.timerLabel.hidden = NO;
            _approveOTP.timerLabel.text = @"Incorrect OPT! try again.";
            _approveOTP.timerLabel.textColor = [UIColor redColor];
            _approveOTP.isRegenAvailable = NO;
        }
        
        /*
         set webview frams
         */
        if(_connectionHandlerDelegate && [_connectionHandlerDelegate respondsToSelector:@selector(adjustWebViewHeight:)]){
            [_connectionHandlerDelegate adjustWebViewHeight:YES];
        }

    }
        /*to handle a case where user click on webpage */
    else {
        NSLog(@"DEFAULT");
        @try {
            if(_choose){
                [_choose removeFromSuperview];
                NSLog(@"_choose removeFromSuperview");
                _choose = nil;
            }
            if(_approveOTP){
                
//                if([_approveOTP.otpTextField isFirstResponder]){
//                    NSLog(@"_approveOTP.otpTextField resignFirstResponder");
//                    [_approveOTP.otpTextField resignFirstResponder];
//                }
                if([_approveOTP endEditing:YES])
                [_approveOTP keyboardDidHideCB:nil];

                //[[NSNotificationCenter defaultCenter] removeObserver:_approveOTP];
                // POX
                @try {
                    [[NSNotificationCenter defaultCenter] removeObserver:_approveOTP name:UIKeyboardDidShowNotification object:nil];
                    [[NSNotificationCenter defaultCenter] removeObserver:_approveOTP name:UIKeyboardDidHideNotification object:nil];
                }
                @catch (id exception) {
                    NSLog(@"observer already removed");
                    //do nothing, obviously it wasn't attached because an exception was thrown
                }
                [_approveOTP.timer invalidate];
                _approveOTP.timer = nil;

                [_approveOTP removeFromSuperview];
                NSLog(@"_approveOTP removeFromSuperview");
                _approveOTP = nil;
            }
            if(_regenOTPView){
                [_regenOTPView removeFromSuperview];
                NSLog(@"_regenOTPView removeFromSuperview");
                _regenOTPView = nil;
            }
            
/*            if(_loader){
                [_loader.loadingTimer invalidate];
                _loader.loadingTimer = nil;
                [_loader removeFromSuperview];
                _loader = nil;
            }*/

        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.reason);
        }
        CGRect frame = _resultWebView.frame;
        NSLog(@"webviewFrame when CB closes : %@",NSStringFromCGRect(frame));
//        if(frame.size.height != (IPHONE_5_5-64) || frame.size.height != (IPHONE_3_5-64) || frame.size.height != (IPHONE_4-64) || frame.size.height != (IPHONE_4_7-64)){
//            frame.size.height = frame.size.height  + 227;
//            frame.origin.y = 64;
//            _resultWebView.frame = frame;
//            NSLog(@"webviewFrame when CB closes After set: %@",NSStringFromCGRect(_resultWebView.frame));
//        }
        CGFloat screenHeight = [[ UIScreen mainScreen] bounds].size.height;
        
        if(screenHeight == IPHONE_3_5){
            frame.size.height = IPHONE_3_5 - 64;
        }
        else if (screenHeight == IPHONE_4){
            frame.size.height = IPHONE_4 - 64;
        }
        else if (screenHeight == IPHONE_4_7){
            frame.size.height = IPHONE_4_7 - 64;
        }
        else if (screenHeight == IPHONE_5_5){
            frame.size.height = IPHONE_5_5 - 64;
        }
        _resultWebView.frame = frame;
        NSLog(@"webviewFrame when CB closes After set: %@",NSStringFromCGRect(_resultWebView.frame));
    }
    });

}

- (void) closeCB {
    [self convertToNative:CLOSE :@""];
}
//
//#pragma mark - Keyboard Handling
//- (void)keyboardDidShowCB:(NSNotification *)notification
//{
//    _resultWebView.scalesPageToFit = NO;
//    CGRect thisViewFrame = _resultView.frame;
//    thisViewFrame.origin.y = thisViewFrame.origin.y - 216;
//    NSLog(@"Handler : keyboardDidShowCB");
//    
//    // Assign new center to your view
//    [UIView animateWithDuration:0.2
//                          delay:0
//                        options: UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         _resultView.frame = thisViewFrame;
//                     }
//                     completion:^(BOOL finished) {
//                     }];
//}
//
//-(void)keyboardDidHideCB:(NSNotification *)notification
//{
//    CGRect thisViewFrame = _resultView.frame;
//    thisViewFrame.origin.y = thisViewFrame.origin.y + 216;
//    NSLog(@"Handler : keyboardDidHideCB");
//    
//    // Assign original center to your view
//    [UIView animateWithDuration:0.2
//                          delay:0
//                        options: UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         _resultView.frame = thisViewFrame;
//                     }
//                     completion:nil];
//}


@end
