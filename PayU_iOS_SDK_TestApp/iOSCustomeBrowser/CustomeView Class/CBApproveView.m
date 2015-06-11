//
//  CBApproveView.m
//  iOSCustomBrowser
//
//  Created by Suryakant Sharma on 21/04/15.
//  Copyright (c) 2015 PayU, India. All rights reserved.
//

#import "CBApproveView.h"
#import "CBConstant.h"

#define PROCESS_OTP @"process_otp"

@interface CBApproveView () <UITextFieldDelegate>{
    CGRect viewFrame;
    CFTimeInterval _ticks;
    int secondsLeft;
    int seconds;
    int totalSec;
    int kbHeight;
}
@property (unsafe_unretained, nonatomic) BOOL isCBTestFieldEditing;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *approveOtpBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *bankImage;
@property (strong, nonatomic) UISwipeGestureRecognizer* swipeUpGestureRecognizer;


-(IBAction)approveOtp:(UIButton *) aButton;
-(IBAction)minimizeCB:(UIButton *) aButton;



@end

@implementation CBApproveView

// POX
- (id)initWithFrame:(CGRect)frame andCBConnectionHandler:(CBConnectionHandler *)handler
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    secondsLeft = 60;
    totalSec = 60;
    //if([handler.bankName isEqualToString:@"sc"] &&)
    if(nil != [handler.bankSpecificJavaScriptDict valueForKey:OTP_REGENERATE_TIMER]){
        secondsLeft = [[handler.bankSpecificJavaScriptDict valueForKey:OTP_REGENERATE_TIMER] intValue];
        totalSec    = [[handler.bankSpecificJavaScriptDict valueForKey:OTP_REGENERATE_TIMER] intValue];
    }
    kbHeight = 216;
    CGFloat ScreenHeight = [[ UIScreen mainScreen] bounds].size.height;
    if(IPHONE_5_5 == ScreenHeight){
        loadViewWithName(@"CBApproveView_iPhone6p");
        kbHeight = 226;
    }
    else if(IPHONE_4_7 == ScreenHeight){
        loadViewWithName(@"CCBApproveView_iPhone6");
    }
    else{
        loadView();
    }
    
    _otpTextField.delegate = self;
    _approveOtpBtn.layer.cornerRadius = 16;
    viewFrame = frame;
    _handler = handler;
    _timerLabel.text = [NSString stringWithFormat:@"%02d%@", totalSec,@" secs to request new OTP"];
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
    
    
    // add notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowCB:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideCB:) name:UIKeyboardDidHideNotification object:nil];
    // --------
    
    return self;
}


- (void)dealloc {
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
   }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception.reason);
    }
    
//    [UIView animateWithDuration:0.2
//                          delay:0
//                        options: UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         _resultView.frame = CGRectMake(0, viewFrame.origin.y, _resultView.frame.size.width, viewFrame.size.height);
//                         NSLog(@"frame = %@ ",NSStringFromCGRect(_resultView.frame));
//                     }
//                     completion:nil];
}

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if(!self){
//        return nil;
//    }
//    secondsLeft = 60;
//    _otpTextField.delegate = self;
//    loadView()
//    _approveOtpBtn.layer.cornerRadius = 16;
//    NSLog(@"");
//    viewFrame = frame;
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
//    
//    // add notification
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowCB:) name:UIKeyboardDidShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideCB:) name:UIKeyboardDidHideNotification object:nil];
//    // --------
//
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
    _approveOtpBtn.layer.cornerRadius = 5;
    
    return self;
}

-(void) awakeFromNib{
    _approveOtpBtn.layer.cornerRadius = 5;
}

// Approve OTP
-(IBAction)approveOtp:(UIButton *) aButton{
    if([_otpTextField isFirstResponder]){
        [_otpTextField resignFirstResponder];
        [self keyboardDidHideCB:nil];
    }
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }

    if(![_handler.bankName isEqualToString:@"sbi"]){
        [_handler addBankLoader];
    }
    [self removeFromSuperview];
    _approveOtpBtn.enabled = NO;
    NSString *processOTP = [_bankJS valueForKey:PROCESS_OTP];
    [_handler runJavaScript:[NSString stringWithFormat:@"%@('%@')",processOTP,_otpTextField.text] toWebView:nil];
    if(_handler.connectionHandlerDelegate && [_handler.connectionHandlerDelegate respondsToSelector:@selector(adjustWebViewHeight:)]){
        [_handler.connectionHandlerDelegate adjustWebViewHeight:NO];
    }
    //[self removeFromSuperview];
    //NSLog(@"Process_otp = %@",[NSString stringWithFormat:@"%@(%@);",processOTP,_otpTextField.text]);
}

// minimize custome browser
-(IBAction)minimizeCB:(UIButton *) aButton{
    
    if(_handler.connectionHandlerDelegate && [_handler.connectionHandlerDelegate respondsToSelector:@selector(adjustWebViewHeight:)]){
        [_handler.connectionHandlerDelegate adjustWebViewHeight:!_isViewOnScreen];
    }

    CGRect frame = self.frame;
    if(_isViewOnScreen){
        frame.origin.y = _handler.resultView.frame.size.height - 30;
//        NSLog(@"frame = %@ ",NSStringFromCGRect( _handler.resultView.frame));
        _isViewOnScreen = NO;
    }
    else{
        _isViewOnScreen = YES;
        frame = viewFrame;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        
    }];

    
}

- (void) RegenerateOTP:(UIButton *) aButton{
    NSString *regenrateOTP = [_bankJS valueForKey:REGERERATE_OTP];
    [_handler runJavaScript:[NSString stringWithFormat:@"%@",regenrateOTP] toWebView:nil];
    NSLog(@"Process_otp = %@",[NSString stringWithFormat:@"%@",regenrateOTP]);
}

-(void) startCountDown{
//    secondsLeft = totalSec;
    seconds = 0;
    [_timer invalidate];
    _timer = nil;

    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    //start a new runloop for timer so that it won't stop if case of main runloop gets bussy in some other opration.
    //[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

}
- (void)timerTick:(NSTimer *)timer
{
    // Timers are not guaranteed to tick at the nominal rate specified, so this isn't technically accurate.
    // However, this is just an example to demonstrate how to stop some ongoing activity, so we can live with that inaccuracy.
    if(secondsLeft > 0 ){
        secondsLeft -- ;
        seconds = (secondsLeft %3600) % totalSec;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.timerLabel.text = [NSString stringWithFormat:@"%02d%@", seconds,@" secs to request new OTP"];
        if(0 == seconds){
            [_timer invalidate];
            _timer = nil;
            if([_otpTextField isFirstResponder]){
                [_otpTextField resignFirstResponder];
                [self keyboardDidHideCB:nil];
            }
            [_handler populateRegenerateOption:self];
//            [self removeFromSuperview];
        }
    });
    }
}


- (void)handleSwipeUpFrom:(UIGestureRecognizer*)recognizer {
    [self minimizeCB:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_otpTextField resignFirstResponder];
}

-(void)minimizeKb:(UIGestureRecognizer*)recognizer{
    [_otpTextField resignFirstResponder];
}

#pragma mark - Keyboard Handling
- (void)keyboardDidShowCB:(NSNotification *)notification
{
    if([_otpTextField isFirstResponder]){
        
        _handler.resultWebView.scalesPageToFit = NO;
        CGRect thisViewFrame = _handler.resultView.frame;
        thisViewFrame.origin.y = thisViewFrame.origin.y - kbHeight;
        // Assign new center to your view
        [UIView animateWithDuration:0.2
                              delay:0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _handler.resultView.frame = thisViewFrame;
                             //NSLog(@"frame = %@ ",NSStringFromCGRect(thisViewFrame));
                         }
                         completion:^(BOOL finished) {
                         }];
        }
}

-(void)keyboardDidHideCB:(NSNotification *)notification
{
    if(_isCBTestFieldEditing){
        _isCBTestFieldEditing = NO;
    CGRect thisViewFrame = _handler.resultView.frame;
    thisViewFrame.origin.y = thisViewFrame.origin.y + kbHeight;
    
    // Assign original center to your view
    [UIView animateWithDuration:0.2
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _handler.resultView.frame = thisViewFrame;
                         //NSLog(@"frame = %@ ",NSStringFromCGRect(thisViewFrame));
                     }
                     completion:nil];
    }
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [_timer invalidate];
    _timer = nil;
    if([textField isEqual:_otpTextField]){
        _isCBTestFieldEditing = YES;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *trimmedText;
    if([string isEqualToString:@""]){
        trimmedText = [textField.text substringToIndex:textField.text.length-1];
    }
    else{
        trimmedText  = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    
    if(6 < trimmedText.length && ![_handler.bankName isEqualToString:@"sc"]){
        
        if(8 < trimmedText.length)
            return NO;
        _approveOtpBtn.enabled = YES;
        _approveOtpBtn.alpha = 1.0f;
        return YES;
    }
    else if(6 == trimmedText.length){
        _approveOtpBtn.enabled = YES;
        _approveOtpBtn.alpha = 1.0f;
        return YES;
    }
    if([_handler.bankName isEqualToString:@"sc"] && ([[_handler.bankSpecificJavaScriptDict valueForKey:OTP_LENGTH] intValue] < trimmedText.length )){
        return NO;
    }
    else{
        _approveOtpBtn.enabled = NO;
        _approveOtpBtn.alpha = 0.5f;
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if([_otpTextField isEqual:textField] && [_otpTextField.text isEqualToString:@""] && _isRegenAvailable)
    [self startCountDown];
    
//    if([textField isEqual:_otpTextField]){
//        _isCBTestFieldEditing = NO;
//    }
}




@end
