//
//  CBAllPaymentOption.m
//  iOSCustomeBrowser
//
//  Created by Suryakant Sharma on 17/04/15.
//  Copyright (c) 2015 PayU, India. All rights reserved.
//

#import "CBAllPaymentOption.h"
#import "CBConstant.h"


@interface CBAllPaymentOption(){
    CGRect viewFrame;
}


@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *bankImage;
@property (strong, nonatomic) UISwipeGestureRecognizer* swipeUpGestureRecognizer;


-(IBAction)smsOtpButtonClicked:(UIButton *) aButton;
-(IBAction)passwordButtonClicked:(UIButton *) aButton;
-(IBAction)minimizeCB:(UIButton *) aButton;


@end

@implementation CBAllPaymentOption

- (id)initWithFrame:(CGRect)frame andCBConnectionHandler:(CBConnectionHandler *)handler
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    CGFloat ScreenHeight = [[ UIScreen mainScreen] bounds].size.height;
    if(IPHONE_5_5 == ScreenHeight){
        loadViewWithName(@"CBAllPaymentOption_iPhone6p");
    }
    else if(IPHONE_4_7 == ScreenHeight){
        loadViewWithName(@"CBAllPaymentOption_iPhone6");
    }
    else{
        loadView();
    }
    viewFrame = frame;
    CALayer *layer = self.layer;
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 4.0f;
    layer.shadowOpacity = 0.80f;
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
    _bankImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.%@",handler.bankName,@"png"]];
    _handler = handler;
    _swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
    _swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    _retryLabel.hidden = YES;
    [self addGestureRecognizer:_swipeUpGestureRecognizer];
    
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    loadView()
    
    return self;
}



-(IBAction)smsOtpButtonClicked:(UIButton *) aButton{
    
    [_handler addBankLoader];
    _smsotpBtn.enabled = NO;
    _passwordBtn.enabled = NO;
//    NSString *processOTP = [_bankJS valueForKey:OTP];
    [_handler runJavaScript:[_bankJS valueForKey:OTP] toWebView:nil];

}
-(IBAction)passwordButtonClicked:(UIButton *) aButton{
    _smsotpBtn.enabled = NO;
    _passwordBtn.enabled = NO;
//    NSString *processPassWord = [_bankJS valueForKey:PIN];
    [_handler runJavaScript:[_bankJS valueForKey:PIN] toWebView:nil];
    if(_handler.connectionHandlerDelegate && [_handler.connectionHandlerDelegate respondsToSelector:@selector(adjustWebViewHeight:)]){
        [_handler.connectionHandlerDelegate adjustWebViewHeight:NO];
    }
    [self removeFromSuperview];
       dispatch_async(dispatch_get_main_queue(), ^{
           CGRect frame = _handler.resultView.bounds;
           frame.origin.y = frame.origin.y + 64;
           _handler.resultWebView.frame = frame;
       });

}

// minimize custome browser
-(IBAction)minimizeCB:(UIButton *) aButton{
    
    if(_handler.connectionHandlerDelegate && [_handler.connectionHandlerDelegate respondsToSelector:@selector(adjustWebViewHeight:)]){
        [_handler.connectionHandlerDelegate adjustWebViewHeight:!_isViewOnScreen];
    }

    CGRect frame = self.frame;
    if(_isViewOnScreen){
        frame.origin.y = _handler.resultView.frame.size.height - 30;
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

- (void)handleSwipeUpFrom:(UIGestureRecognizer*)recognizer {
    [self minimizeCB:nil];
}



@end
