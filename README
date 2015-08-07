# Custom Browser Without SDK Integration
Current version is 2.1  

***


1. Download [**iOS-CustomBrowser**](https://github.com/payu-intrepos/iOS-Custom-Browser) kit from github. You can also download the [sample app](https://github.com/payu-intrepos/iOS-SDK-Sample-App/tree/CBWithoutSDK) for reference  
2. Extract required compressed file. i.e. Release-iphoneos for running the app on iPhone and Release-iphonesimulator for simulator  
3. Drag and drop the extracted content (two items - a folder and a static lib) into your project
4. Add **_libz.dylib_** libraries into your project
5. Changes in your **UIWebView controller** (file where you are writing the logic for populating UIWebView for payment):  
 a. Make sure you have confirmed `UIWebViewDelegate` protocol in the webview controller  
 b. `#import "PayU_CB_SDK.h"`  
 c. Create property of `CBConnection`  
`@property (strong,nonatomic) CBConnection *CBC;`  
 d. **viewDidLoad:**
 * Initialize the object of `CBConnection` and call `loadPayuActivityIndicator` & `InitialSetup` method. While initializing object we are passing 2 parameters `self.view` and `_resultWebView` (pass object of your webview)  

          _CBC = [[CBConnection alloc]init:self.view webView:_resultWebView];  
          [_CBC InitialSetup];  
 * Add observer for `UIApplicationDidEnterBackgroundNotification`  

          [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appGoingInBackground:)  
            name:UIApplicationDidEnterBackgroundNotification object:nil];  
          if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {  
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;  
          }  
	
 e. Add the definition of `appGoingInBackground` selector:  

      - (void) appGoingInBackground:(NSNotification *) notification  
      {  
        [self.view endEditing:YES];  
      }  

 f. **viewWillDisappear** call `deallocHandler` method of `CBConnection`:  

      [_CBC deallocHandler];  

 g. **webViewDidFinishLoad**: call `payUWebViewDidFinishLoad:` method of `CBConnection`. Parameter `webview` is same as it coming from `webViewDidFinishLoad` delegate method:  

      [_CBC payUWebViewDidFinishLoad:webView];  
 h. **shouldStartLoadWithRequest**: call `payUWebView:webView shouldStartLoadWithRequest:request` method of `CBConnection`. Parameter `webview` & `request` is same as it coming from `shouldStartLoadWithRequest` delegate method:  

      if (_CBC) {  
        return [_CBC payUWebView:webView shouldStartLoadWithRequest:request];  
      }
      else {
        return true;
      }

6. Now compile and run your project. You will be able to see Custom Browser.
