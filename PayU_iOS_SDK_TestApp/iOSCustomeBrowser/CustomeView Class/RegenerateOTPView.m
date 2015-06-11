//
//  RegenerateOTPView.m
//  iOSCustomBrowser
//
//  Created by Suryakant Sharma on 22/04/15.
//  Copyright (c) 2015 PayU, India. All rights reserved.
//

#import "RegenerateOTPView.h"
#import "CBConstant.h"
#import "CBApproveView.h"


@interface RegenerateOTPView (){
    CGRect viewFrame;
}


@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *bankImage;
@property (strong, nonatomic) UISwipeGestureRecognizer* swipeUpGestureRecognizer;


@property (nonatomic,strong) CBApproveView  *approveOTP;



-(IBAction)smsOtpEnterManuallyButtonClicked:(UIButton *) aButton;
-(IBAction)regenerateOTPButtonClicked:(UIButton *) aButton;
-(IBAction)minimizeCB:(UIButton *) aButton;


@end

@implementation RegenerateOTPView


// POX
- (id)initWithFrame:(CGRect)frame andCBConnectionHandler:(CBConnectionHandler *)handler
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    _isRegenAvailable = YES;
    CGFloat ScreenHeight = [[ UIScreen mainScreen] bounds].size.height;
    if(IPHONE_5_5 == ScreenHeight){
        loadViewWithName(@"RegenerateOTPView_iPhone6p");
    }
    else if(IPHONE_4_7 == ScreenHeight){
        loadViewWithName(@"RegenerateOTPView_iPhone6");
    }
    else{
        loadView();
    }
    
    viewFrame = frame;
    NSLog(@"frame = %@ ",NSStringFromCGRect(frame));
    
    _smsOtpEnterManuallyBtn.layer.cornerRadius = 16;
    _regenerateOTPBtn.layer.cornerRadius = 16;
    _retryLbl.hidden = YES;
    _handler = handler;
    _bankImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.%@",_handler.bankName,@"png"]];
    
    CALayer *layer = self.layer;
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 4.0f;
    layer.shadowOpacity = 0.80f;
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
    
    _swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
    _swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self addGestureRecognizer:_swipeUpGestureRecognizer];
    
    return self;
}

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if(!self){
//        return nil;
//    }
//    
//    loadView()
//    viewFrame = frame;
//    NSLog(@"");
//    
//    _smsOtpEnterManuallyBtn.layer.cornerRadius = 16;
//    _regenerateOTPBtn.layer.cornerRadius = 16;
//    _retryLbl.hidden = YES;
//    _bankImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.%@",_handler.bankName,@"png"]];
//    
//    CALayer *layer = self.layer;
//    layer.shadowOffset = CGSizeMake(1, 1);
//    layer.shadowColor = [[UIColor blackColor] CGColor];
//    layer.shadowRadius = 4.0f;
//    layer.shadowOpacity = 0.80f;
//    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
//    
//    _swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
//    _swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
//    
//    [self addGestureRecognizer:_swipeUpGestureRecognizer];
//    
//    return self;
//}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    loadView()
    
    NSLog(@"");
    
    return self;
}

-(void) awakeFromNib{
    NSLog(@"");
}

- (void)dealloc {
    @try {
        //[[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception.reason);
    }
    
//    CGRect thisViewFrame = self.frame;
//    thisViewFrame.size.height = thisViewFrame.size.height +216;
    
    // Assign original center to your view
//    [UIView animateWithDuration:0.2
//                          delay:0
//                        options: UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         _resultView.frame = viewFrame;
//                         NSLog(@"frame = %@ ",NSStringFromCGRect(viewFrame));
//                     }
//                     completion:nil];
}

-(IBAction)smsOtpEnterManuallyButtonClicked:(UIButton *) aButton{
    NSLog(@"");
    if(_approveOTP){
        [_approveOTP removeFromSuperview];
        _approveOTP = nil;
    }
    
    // POX
    if (_handler) {
        if (_handler.approveOTP) {
            [_handler.approveOTP removeFromSuperview];
            _handler.approveOTP = nil;
        }
    }

    _regenerateOTPBtn.enabled = NO;
    _smsOtpEnterManuallyBtn.enabled = NO;

    [_handler.approveOTP removeFromSuperview];
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:_handler.approveOTP name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:_handler.approveOTP name:UIKeyboardDidHideNotification object:nil];
    }
    @catch (id exception) {
        NSLog(@"observer already removed");
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
    _handler.approveOTP = nil;
    
    // POX
    _approveOTP =  [[CBApproveView alloc] initWithFrame:CGRectMake(0,self.resultView.frame.size.height - 227,SCREEN_WIDTH,227) andCBConnectionHandler:_handler];
    _approveOTP.bankJS = _bankJS;
//    _approveOTP.handler = _handler;
//    NSLog(@"loadJavascript first view = %@ ResultView = %@",_approveOTP,_resultView);
    [_resultView addSubview:_approveOTP];
    [_approveOTP startCountDown];
    // view getting display late so call setNeedDisplay.
    //[_approveOTP setNeedsDisplay];
    _approveOTP.isViewOnScreen = YES;
    _handler.approveOTP = _approveOTP;
    [_resultView bringSubviewToFront:_approveOTP];
    [self removeFromSuperview];
    
}
-(IBAction)regenerateOTPButtonClicked:(UIButton *) aButton{
    NSLog(@"regenerateOTPButtonClicked : Regenerate JS = %@",[_bankJS valueForKey:REGERERATE_OTP]);
    [_handler addBankLoader];
    [_handler runJavaScript:[_bankJS valueForKey:REGERERATE_OTP] toWebView:nil];
    _regenerateOTPBtn.enabled = NO;
    _smsOtpEnterManuallyBtn.enabled = NO;
    [self removeFromSuperview];

}

// minimize custome browser
-(IBAction)minimizeCB:(UIButton *) aButton{
    NSLog(@"");
    
    if(_handler.connectionHandlerDelegate && [_handler.connectionHandlerDelegate respondsToSelector:@selector(adjustWebViewHeight:)]){
        [_handler.connectionHandlerDelegate adjustWebViewHeight:!_isViewOnScreen];
    }
    
    CGRect frame = self.frame;
    if(_isViewOnScreen){
        frame.origin.y = _handler.resultView.frame.size.height - 30;
        NSLog(@"frame = %@ ",NSStringFromCGRect(frame));
        _isViewOnScreen = NO;
    }
    else{
        frame = viewFrame;
        NSLog(@"frame = %@ ",NSStringFromCGRect(frame));
        _isViewOnScreen = YES;

    }
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)handleSwipeUpFrom:(UIGestureRecognizer*)recognizer {
    NSLog(@"minimizeCB");
    [self minimizeCB:nil];
}

#pragma mark - Keyboard Handling
- (void)keyboardDidShow:(NSNotification *)notification
{
    CGRect thisViewFrame = self.frame;
    thisViewFrame.size.height = thisViewFrame.size.height - 216;
    
    
    // Assign new center to your view
    [UIView animateWithDuration:0.2
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _resultView.frame = thisViewFrame;
                         NSLog(@"frame = %@ ",NSStringFromCGRect(thisViewFrame));
                     }
                     completion:^(BOOL finished) {
                     }];
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    CGRect thisViewFrame = self.frame;
    thisViewFrame.size.height = thisViewFrame.size.height +216;
    
    // Assign original center to your view
    [UIView animateWithDuration:0.2
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _resultView.frame = thisViewFrame;
                         NSLog(@"frame = %@ ",NSStringFromCGRect(thisViewFrame));
                     }
                     completion:nil];
}




@end
