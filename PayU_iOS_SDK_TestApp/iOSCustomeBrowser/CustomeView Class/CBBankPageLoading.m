//
//  CBBankPageLoading.m
//  PayU_iOS_SDK_TestApp
//
//  Created by Suryakant Sharma on 15/05/15.
//  Copyright (c) 2015 PayU, India. All rights reserved.
//

#import "CBBankPageLoading.h"
#import "CBConstant.h"


@interface CBBankPageLoading ()
{
    CGRect viewFrame;
}


@property(nonatomic,strong)  UIView *aView1;
@property(nonatomic,strong)  UIView *aView2;
@property(nonatomic,strong)  UIView *aView3;
@property(nonatomic,strong)  UIView *aView4;
@property(nonatomic,strong)  UIView *aView5;

@property (nonatomic,assign) NSInteger counter;

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *bankImage;
@property (strong, nonatomic) UISwipeGestureRecognizer* swipeUpGestureRecognizer;

@property(nonatomic,assign) BOOL flagForFifthDot;


@end


@implementation CBBankPageLoading


- (id)initWithFrame:(CGRect)frame andCBConnectionHandler:(CBConnectionHandler *)handler
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    CGFloat ScreenHeight = [[ UIScreen mainScreen] bounds].size.height;
    if(IPHONE_5_5 == ScreenHeight){
        loadViewWithName(@"CBBankPageLoading_iPhone6p");
    }
    else if(IPHONE_4_7 == ScreenHeight){
        loadViewWithName(@"CBBankPageLoading_iPhone6");
    }
    else{
        loadView();
    }
    
    viewFrame = frame;
    NSLog(@"frame = %@ ",NSStringFromCGRect(frame));
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


- (void) startCircleAnimation:(NSTimer *)timer{
    
    switch (_counter) {
        case 1:
            _aView1.backgroundColor = [UIColor blueColor];
            [self changeCircleFrame:_aView1 andFlag:YES];
            if(_flagForFifthDot){
                [self changeCircleFrame:_aView5 andFlag:NO];
            }
            else{
                _flagForFifthDot = YES;
            }
            
            _aView2.backgroundColor = [UIColor lightGrayColor];
            _aView3.backgroundColor = [UIColor lightGrayColor];
            _aView4.backgroundColor = [UIColor lightGrayColor];
            _aView5.backgroundColor = [UIColor lightGrayColor];
            
            break;
        case 2:
            _aView2.backgroundColor = [UIColor blueColor];
            [self changeCircleFrame:_aView1 andFlag:NO];
            [self changeCircleFrame:_aView2 andFlag:YES];
            
            
            
            _aView1.backgroundColor = [UIColor lightGrayColor];
            _aView3.backgroundColor = [UIColor lightGrayColor];
            _aView4.backgroundColor = [UIColor lightGrayColor];
            _aView5.backgroundColor = [UIColor lightGrayColor];
            
            break;
        case 3:
            _aView3.backgroundColor = [UIColor blueColor];
            [self changeCircleFrame:_aView3 andFlag:YES];
            [self changeCircleFrame:_aView2 andFlag:NO];
            
            _aView1.backgroundColor = [UIColor lightGrayColor];
            _aView2.backgroundColor = [UIColor lightGrayColor];
            _aView4.backgroundColor = [UIColor lightGrayColor];
            _aView5.backgroundColor = [UIColor lightGrayColor];
            
            break;
        case 4:
            _aView4.backgroundColor = [UIColor blueColor];
            [self changeCircleFrame:_aView3 andFlag:NO];
            [self changeCircleFrame:_aView4 andFlag:YES];
            _aView1.backgroundColor = [UIColor lightGrayColor];
            _aView2.backgroundColor = [UIColor lightGrayColor];
            _aView3.backgroundColor = [UIColor lightGrayColor];
            _aView5.backgroundColor = [UIColor lightGrayColor];
            break;
        case 5:
            _aView5.backgroundColor = [UIColor blueColor];
            [self changeCircleFrame:_aView4 andFlag:NO];
            [self changeCircleFrame:_aView5 andFlag:YES];
            _aView1.backgroundColor = [UIColor lightGrayColor];
            _aView3.backgroundColor = [UIColor lightGrayColor];
            _aView4.backgroundColor = [UIColor lightGrayColor];
            _aView2.backgroundColor = [UIColor lightGrayColor];
            break;
        default:
            break;
    }
    
    if(_counter < 5 ){
        _counter ++ ;
    }
    else{
        //_counter ++;
        _counter = 1;
        
    }
}

- (void)drawCircle: (NSInteger)number{
    
    _flagForFifthDot = NO;
    float xPos = 0.0f;
    CGFloat ScreenHeight = [[ UIScreen mainScreen] bounds].size.height;
    if(IPHONE_5_5 == ScreenHeight){
        xPos = 172.0f;
    }
    else if(IPHONE_4_7 == ScreenHeight){
        xPos = 152.0f;
    }
    else{
        xPos = 125.0f;
    }
    
    NSInteger viewNumber = 1;
    while(number != 0){
        
        switch (viewNumber) {
            case 1:
                _aView1 = [[UIView alloc] initWithFrame:CGRectMake(xPos,87,10,10)];
                _aView1.alpha = 0.5;
                _aView1.layer.cornerRadius = 5;
                _aView1.backgroundColor = [UIColor lightGrayColor];
                [self addSubview:_aView1];;
                break;
            case 2:
                _aView2 = [[UIView alloc] initWithFrame:CGRectMake(xPos,87,10,10)];
                _aView2.alpha = 0.5;
                _aView2.layer.cornerRadius = 5;
                _aView2.backgroundColor = [UIColor lightGrayColor];
                [self addSubview:_aView2];;
                break;
            case 3:
                _aView3 = [[UIView alloc] initWithFrame:CGRectMake(xPos,87,10,10)];
                _aView3.alpha = 0.5;
                _aView3.layer.cornerRadius = 5;
                _aView3.backgroundColor = [UIColor lightGrayColor];
                [self addSubview:_aView3];
                break;
            case 4:
                _aView4 = [[UIView alloc] initWithFrame:CGRectMake(xPos,87,10,10)];
                _aView4.alpha = 0.5;
                _aView4.layer.cornerRadius = 5;
                _aView4.backgroundColor = [UIColor lightGrayColor];
                [self addSubview:_aView4];
                break;
            case 5:
                _aView5 = [[UIView alloc] initWithFrame:CGRectMake(xPos,87,10,10)];
                _aView5.alpha = 0.5;
                _aView5.layer.cornerRadius = 5;
                _aView5.backgroundColor = [UIColor lightGrayColor];
                [self addSubview:_aView5];
                break;
            
            default:
                break;
        }
        number--;
        viewNumber++;
        xPos = xPos + 13;
    }
    _loadingTimer = [NSTimer scheduledTimerWithTimeInterval:0.40f target:self selector:@selector(startCircleAnimation:) userInfo:nil repeats:YES];
}

- (void) changeCircleFrame:(UIView *) aCircleView andFlag:(BOOL)aFlag{
    
    CGRect frame = aCircleView.frame;
    if(aFlag){
        frame.origin.y -=1;
        frame.size.height+=2;
        frame.size.width+= 2;
        aCircleView.layer.cornerRadius = 6;
        
    }
    else{
        frame.origin.y +=1;
        frame.size.height-=2;
        frame.size.width-= 2;
        aCircleView.layer.cornerRadius = 5;
        
    }
    aCircleView.frame = frame;
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
