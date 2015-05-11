Current version is 1.0.

Method declaration in .h file.
-(void) loadJavascript;


Now in .h file

// ------------------- CB Import ----------------
#import "PayU_CB_SDK.h"
#define DETECT_BANK_KEY @"detectBank"
#define INIT  @"init"


Conform “CBConnectionHandlerDelegate”  delegate


Create following properties

@property (nonatomic,strong) CBConnectionHandler *handler;
@property (nonatomic,assign) BOOL isBankFound;
@property (nonatomic,assign) BOOL isWebViewLoadFirstTime;


in ViewDidLoad method

    _isBankFound = NO;
    [self loadJavascript];
    _resultWebView.scalesPageToFit = YES;



in webViewFinishedLoad method

   _resultWebView.scalesPageToFit = NO;
    [self startStopIndicator:NO];
    
    if(!_isBankFound){
        [_handler runIntializeJSOnWebView];
    }
    else{
        [_handler runBankSpecificJSOnWebView];
    }

In webView: shouldStartLoadWithRequest 
if (_handler) {
        NSLog(@"_handler closeCB");
        [_handler closeCB];
    } else {
        NSLog(@"Error: _handler NIL");
    }





Add following methods


#pragma mark - JavaScript delegate

-(void) runIntializeJSOnWebView{
 
   /****-------------Setting JavaScript Context-----------***/
       if(!_isBankFound)
    [_handler runIntializeJSOnWebView];   
}

-(void) loadJavascript{
    
    // create Connection handler
    if(!_handler){
        _handler = [[CBConnectionHandler alloc] init];
        _handler.connectionHandlerDelegate = self;
        _handler.resultView = self.view;
        _handler.resultWebView = _resultWebView;
        _handler.resultViewController = self;
    }
    [_handler downloadInitializeJS];
}

#pragma mark - CBConnectionHandler Delegate

- (void) bankSpecificJSDownloded{
    NSLog(@"");
}

- (void) bankNameFound:(NSString *) bankName{
    NSLog(@"BankName = %@ ",bankName);
    _isBankFound = YES;
}

- (void) adjustWebViewHeight:(BOOL) upOrDown
{
    NSLog(@"upOrDown: %d",upOrDown);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(upOrDown){
            
            NSLog(@"WebViewFrame without updates = %@",NSStringFromCGRect(_resultWebView.frame));
            [_resultWebView removeConstraints:_resultWebView.constraints];

            _resultWebView.scalesPageToFit = YES;
            CGRect webViewFrame = _resultWebView.frame;
            webViewFrame.size.height = webViewFrame.size.height - 237;
            _resultWebView.frame = webViewFrame;
            NSLog(@"WebViewFrame when CB is on Screen = %@",NSStringFromCGRect(_resultWebView.frame));
        }
        else{
            [_resultWebView removeConstraints:_resultWebView.constraints];
            _resultWebView.scalesPageToFit = NO;
            CGRect webViewFrame = _resultWebView.frame;
            webViewFrame.size.height = webViewFrame.size.height + 237;
            _resultWebView.frame = webViewFrame;
            NSLog(@"WebViewFrame when CB is off Screen = %@",NSStringFromCGRect(_resultWebView.frame));

        }
    });
}

- (void) addViewInResultView:(UIView *) aView{
    NSLog(@"");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:aView];
        [aView setNeedsDisplay];
    });

}