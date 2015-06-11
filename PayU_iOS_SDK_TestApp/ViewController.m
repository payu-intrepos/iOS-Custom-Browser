//
//  ViewController.m
//  PayU_iOS_SDK_TestApp
//
//  Created by Suryakant Sharma on 04/12/14.
//  Copyright (c) 2014 PayU, India. All rights reserved.
//

#import "ViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "Constant.h"



@interface ViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *paymentModeTableView;
@property (nonatomic, strong) NSArray *optionList;
@property (nonatomic, strong) NSArray *headerNames;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationItem.title = @"PayU Test App";
    // setting up this class as delegate and dataSource for paymentModeTableView
    _paymentModeTableView.delegate = self;
    _paymentModeTableView.dataSource = self;
    
    //creating a array of option to display.
    _optionList = @[@"Start Payment"/*,@"CC DC NB CASH",@"DC CASH NB CC",@"PAYU_MONEY STORED_CARDS CC",@"Make payment CC",@"Make Payment Stored Card",@"Stored Card",@"Edit Card",@"Delete Card",@"Test Enforce",@"Test Drop Category",@"Test Offer",@"Back Button disabled"*/];
    
    _headerNames = @[@"Without user defined modes"/*,@"With user defined modes",@"Use payU fragments", @"Enforce method", @"Drop Category", @"With Offer"*/];
    
    //NSLog(@"Bundle Object = %@ Path = %@", [NSBundle mainBundle], [[NSBundle mainBundle] pathForResource:@"WebViewJavascriptBridge.js" ofType:@"txt"]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(success:) name:@"payment_success_notifications" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failure:) name:@"payment_failure_notifications" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancel:) name:@"payu_notifications" object:nil];
    
}

- (void) success:(NSDictionary *)info{
    NSLog(@"Sucess Dict: %@",info);
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) failure:(NSDictionary *)info{
    NSLog(@"failure Dict: %@",info);
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void) cancel:(NSDictionary *)info{
    NSLog(@"failure Dict: %@",info);
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (NSString *) createCheckSumString:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    // This is an iOS5-specific method.
    // It takes in the data, how much data, and then output format, which in this case is an int array.
    CC_SHA512(data.bytes, (int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    // Parse through the CC_SHA256 results (stored inside of digest[]).
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}
NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *) randomStringWithLength:(int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((u_int32_t)[letters length])]];
    }
    
    return randomString;
}

-(void) withoutUserDefinedModeBtnClick{
    
    PayUPaymentOptionsViewController *paymentOptionsVC = nil;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            paymentOptionsVC = [[PayUPaymentOptionsViewController alloc] initWithNibName:@"AllPaymentOprionsView" bundle:nil];
        }
        else
        {
            paymentOptionsVC = [[PayUPaymentOptionsViewController alloc] initWithNibName:@"PayUPaymentOptionsViewController" bundle:nil];
        }
    }

    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @"product",@"productinfo",
                                      @"username",@"firstname",
                                      [NSNumber numberWithFloat:1.6],@"amount",
                                      @"email@testsdk.com",@"email",
                                      @"9999999999", @"phone",
                                      @"https://dl.dropboxusercontent.com/s/y911hgtgdkkiy0w/success_iOS.html",@"surl",
                                      @"https://dl.dropboxusercontent.com/s/h6m11xr93mxhfvf/Failure_iOS.html",@"furl",
                                      [self randomStringWithLength:15],@"txnid",
                                      @"ra:ra",@"user_credentials", nil];
    paymentOptionsVC.parameterDict = paramDict;
    paymentOptionsVC.callBackDelegate = self;
    paymentOptionsVC.totalAmount  = 1.6;
    paymentOptionsVC.appTitle       = @"PayU test App";
    
    [self.navigationController pushViewController:paymentOptionsVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - TableView DataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return _headerNames.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _headerNames[section];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numberOfRow = 0;
    switch (section) {
        case 0:
            numberOfRow = 1;
            break;
        case 1:
            numberOfRow = 3;
            break;
        case 2:
            numberOfRow = 5;
            break;
        case 3:
            numberOfRow = 1;
            break;
        case 4:
            numberOfRow = 1;
            break;
        case 5:
            numberOfRow = 2;
            break;
        default:
            break;
    }
    return numberOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [_optionList objectAtIndex:indexPath.row];;
            break;
        case 1:
            //calculation of array index should be (rows in previos section + row)
            cell.textLabel.text = [_optionList objectAtIndex:(indexPath.row+1)];
            break;
        case 2:
            cell.textLabel.text = [_optionList objectAtIndex:(indexPath.row+3+1)];
            break;
        case 3:
            cell.textLabel.text = [_optionList objectAtIndex:(indexPath.row+5+3+1)];
            break;
        case 4:
            cell.textLabel.text = [_optionList objectAtIndex:(indexPath.row+1+5+3+1)];
            break;
        case 5:
            cell.textLabel.text = [_optionList objectAtIndex:(indexPath.row+1+1+5+3+1)];
            break;
        default:
            break;
    }

    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            [self withoutUserDefinedModeBtnClick];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            break;
        case 5:
            break;
        default:
            break;
    }

}


@end
