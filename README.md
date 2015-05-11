Current version is 1.0.  

##Steps to enable CUSTOM BROWSER with PayU iOS SDK

###Changes to PayUPaymentResultViewController.m  
####1) Add these imports and defines

	#import "PayU_CB_SDK.h"
	#define DETECT_BANK_KEY @"detectBank"
	#define INIT  @"init"

####2) Conform “CBConnectionHandlerDelegate”  delegate
	
	@interface PayUPaymentResultViewController () <UIWebViewDelegate,CBConnectionHandlerDelegate>

####3) Create following properties

    @property (nonatomic,strong) CBConnectionHandler *handler;
    @property (nonatomic,assign) BOOL isBankFound;
    @property (nonatomic,assign) BOOL isWebViewLoadFirstTime;

####4) Add to ViewDidLoad method

    _isBankFound = NO;
    [self loadJavascript];
    _resultWebView.scalesPageToFit = YES;

####5) Add to webViewDidFinishLoad method
    
    _resultWebView.scalesPageToFit = NO;
    [self startStopIndicator:NO];

    if(!_isBankFound){
        [_handler runIntializeJSOnWebView];
    }
    else{
        [_handler runBankSpecificJSOnWebView];
    }

####6) Add to webView: shouldStartLoadWithRequest
    
    if (_handler) {
            [_handler closeCB];
        } else {
            NSLog(@"Error: _handler NIL");
        }

####7) Add following methods

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
    }
    
    - (void) bankNameFound:(NSString *) bankName{
        _isBankFound = YES;
    }
    
    - (void) adjustWebViewHeight:(BOOL) upOrDown
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(upOrDown){
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
            }
        });
    }
    
    - (void) addViewInResultView:(UIView *) aView{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:aView];
            [aView setNeedsDisplay];
        });
    
    }
