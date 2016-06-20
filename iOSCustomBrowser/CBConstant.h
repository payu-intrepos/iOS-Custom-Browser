//
//  CBConstant.h
//  iOSCustomeBrowser
//
//  Created by Suryakant Sharma on 15/04/15.
//  Copyright (c) 2015 PayU, India. All rights reserved.
//

#ifndef iOSCustomeBrowser_CBConstant_h
#define iOSCustomeBrowser_CBConstant_h

#define CB_RETRY_PAYMENT_OPTION_URL        @"https://secure.payu.in/_payment_options"

typedef NS_OPTIONS(NSUInteger, PUCBBankSimulator) {
    PUCBDefault = 0,
    PUCBBankSimulatorLocal = 1,
    PUCBBankSimulatorRemote = 2,
};

//Macros To prevent instantiation of class by standard methods
#define ATTRIBUTE_ALLOC __attribute__((unavailable("alloc not available, call sharedSingletonInstance instead")))
#define ATTRIBUTE_INIT __attribute__((unavailable("init not available, call sharedSingletonInstance instead")))
#define ATTRIBUTE_NEW __attribute__((unavailable("new not available, call sharedSingletonInstance instead")))
#define ATTRIBUTE_COPY __attribute__((unavailable("copy not available, call sharedSingletonInstance instead")))

// logging on/off
#ifdef DEBUG
#define PayULog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define PayULog(...)
#endif

#define     IPHONE_3_5    480
#define     IPHONE_4      568
#define     IPHONE_4_7    667
#define     IPHONE_5_5    736

// constants for CBConnection
#define  PG_URL_LIST            @"pgUrlList"

#pragma mark - JS Server Urls for CB

#define CB_PRODUCTION_URL_WKWEBVIEW        @"https://secure.payu.in/js/sdk_js/v3/"
#define CB_PRODUCTION_URL_UIWEBVIEW        @"https://secure.payu.in/js/sdk_js/v4/"
#define CB_MOBILE_DEV_URL_WKWEBVIEW        @"https://mobiledev.payu.in/js/sdk_js/v3/"
#define CB_MOBILE_DEV_URL_UIWEBVIEW        @"https://mobiledev.payu.in/js/sdk_js/v4/"
#define CB_TEST_URL_WKWEBVIEW              @"https://test.payu.in/js/sdk_js/v3/"
#define CB_TEST_URL_UIWEBVIEW              @"https://test.payu.in/js/sdk_js/v4/"
#define CB_MOBILE_TEST_URL_WKWEBVIEW       @"https://mobiletest.payu.in/js/sdk_js/v3/"
#define CB_MOBILE_TEST_URL_UIWEBVIEW       @"https://mobiletest.payu.in/js/sdk_js/v4/"
#define CB_SDK_TEST_URL_WKWEBVIEW          @"https://sdktest.payu.in/js/sdk_js/v3/"
#define CB_SDK_TEST_URL_UIWEBVIEW          @"https://sdktest.payu.in/js/sdk_js/v4/"
#define CB_CB_TEST_URL_WKWEBVIEW           @"https://cbtest.payu.in/js/sdk_js/v3/"
#define CB_CB_TEST_URL_UIWEBVIEW           @"https://cbtest.payu.in/js/sdk_js/v4/"
#define CB_DEMO_TEST_URL_WKWEBVIEW         @"https://demotest.payu.in/js/sdk_js/v3/"
#define CB_DEMO_TEST_URL_UIWEBVIEW         @"https://demotest.payu.in/js/sdk_js/v4/"

#pragma mark - Analytics Server Urls for CB

#define CB_ANALYTICS_TEST_URL              @"https://test.payu.in/merchant/"
#define CB_ANALYTICS_PRODUCTION_URL        @"https://info.payu.in/merchant/"
#define CB_ANALYTICS_MOBILE_DEV_URL        @"https://mobiledev.payu.in/merchant/"
#define CB_ANALYTICS_MOBILE_TEST_URL       @"https://mobiletest.payu.in/merchant/"
#define CB_ANALYTICS_SDK_TEST_URL          @"https://sdktest.payu.in/merchant/"
#define CB_ANALYTICS_CB_TEST_URL           @"https://cbtest.payu.in/merchant/"
#define CB_ANALYTICS_DEMO_TEST_URL         @"https://demotest.payu.in/merchant/"

#pragma mark - CB Option constants

#define ENTER_OTP                   @"enterOTP"
#define ENTER_PIN                   @"enterPIN"
#define APPROVE_OTP                 @"approveOTP"
#define CHOOSE                      @"choose"
#define OTP                         @"otp"
#define PIN                         @"pin"
#define INCORRECT_PIN               @"incorrectPIN"
#define INCORRECT_OTP               @"incorrectOTP"
#define CLOSE                       @"close"
#define REGISTER_OPTION             @"registerOption"

#define RETRY_OTP                   @"retryOTP"
#define REGERERATE                  @"regenerate"
#define REGERERATE_OTP              @"regenerate_otp"
#define OTP_LENGTH                  @"otp_length"
#define OTP_REGENERATE_TIMER        @"regen_timer"

//NB keys
#define POPULATE_USER_ID            @"populate_user_id"
#define BUTTON                      @"Button"
#define PWD_BTN                     @"pwd_btn"
#define CHECKBOX                    @"checkbox"
#define CHECKED                     @"checked"
#define BTN_TEXT                    @"btn_text"
#define BTN_ACTION                  @"btn_action"
#define TOGGLE_FIELD                @"toggle_field"

#define VAL_NB_CUSTOM_BROWSER       @"nb_custom_browser"
#define KEY_CB_USER_ID              @"cb_user_id"
#define VAL_CHKBOX_ENABLE           @"checkbox_enable"
#define VAL_CHKBOX_DISABLE          @"checkbox_disable"
#define VAL_BTN_CLICK               @"button_click_"
#define VAL_CHKBOX_CLICK_ENABLE     @"checkbox_click_enable"
#define VAL_CHKBOX_CLICK_DISABLE     @"checkbox_click_disable"

#define DETECT_BANK_KEY @"detectBank"
#define INIT  @"init"

#pragma mark - Analytics keys

//Device Analytics Keys

#define iOS_MANUFACTURER         @"apple"

#define KEY_SDK_VERSION_NAME @"sdk_version"
#define KEY_CB_VERSION_NAME @"cb_version"
#define KEY_IOS_VERSION @"os_version"
#define KEY_NETWORK_INFO @"network_info"
#define KEY_NETWORK_STRENGTH @"network_strength"
#define KEY_DEVICE_RESOLUTION @"resolution"
#define KEY_DEVICE_MANUFACTURER @"device_manufacturer"
#define KEY_DEVICE_MODEL @"device_model"
#define KEY_MERCHANT_ID @"merchant_key"
#define KEY_TXNID @"txnid"

#define DEVICE_ANALYTICS @"DeviceAnalytics"
#define EVENT_ANALYTICS @"EventAnalytics"
#define TEMP_EVENT_ANALYTICS @"TempEventAnalytics"
#define ANALYTICS_TIMEOUT_INTERVAL 5
#define DA_URL_PATH @"mobileWebService.php"
#define EA_URL_PATH @"postservice.php?form=2"
//#define KEY_DADATA_SENT @"deviceAnalyticsDataSent"

//Event Analytics Keys
#define KEY_USER_INPUT @"user_input"
#define KEY_CB_STATUS @"cb_status"
#define KEY_OTP_RECEIVED @"otp_received"
#define KEY_TRXN_STATUS @"trxn_status"
#define KEY_LAST_URL @"last_url"

#define KEY_BANK @"bank"
#define KEY_PACKAGE_NAME @"package_name"
#define KEY_NAME @"key"
#define KEY_VALUE_NAME @"value"

#pragma mark - Event Analytics values

//Event Analytics Values
#define VAL_PAYMENT_INITIATED @"payment_initiated"
#define VAL_CUSTOM_BROWSER @"custom_browser"
#define VAL_NON_CUSTOM_BROWSER @"non_custom_browser"
#define VAL_PASSWORD @"password_click"
#define VAL_OTP @"otp_click"
#define VAL_OTP_DIRECT @"received_otp_direct"
#define VAL_AUTOMATIC_OTP_SELECT @"auto_otp_select"
#define VAL_SUCCESS_TRANSACTION @"success_transaction"
#define VAL_FAILURE_TRANSACTION @"failure_transaction"
#define VAL_TERMINATE_TRANSACTION @"terminate_transaction"

#define VAL_ENTER_MANUALLY @"enter_manually_click" // When OTP is entered manually
#define VAL_APPROVED @"approved_otp"
#define VAL_ALL_OPTION_VIEW @"all_option_view"
#define VAL_REGENERATE_CLICKED @"regenerate_click"

#pragma mark - Server Environment constants

//CB_SERVER_ID Constants
#define CB_ENVIRONMENT_PRODUCTION              @"Production"
#define CB_ENVIRONMENT_MOBILETEST              @"MobileTest"
#define CB_ENVIRONMENT_MOBILEDEV               @"MobileDev"
#define CB_ENVIRONMENT_TEST                    @"Test"
#define CB_ENVIRONMENT_SDKTEST                 @"SDKTest"
#define CB_ENVIRONMENT_CBTEST                  @"CBTest"
#define CB_ENVIRONMENT_DEMOTEST                @"DemoTest"

//Back Button Events
#define PAYU_BACK_BUTTON_CLICK @"payu_back_button" // PAYU BACK BUTTON PRESSED
#define BACK_BUTTON_OK_CLICK @"back_button_ok" // OK PRESSED - BACK BUTTON CONFIRMATION DIALOG
#define BACK_BUTTON_CANCEL_CLICK @"back_button_cancel" // CANCEL PRESSED - BACK BUTTON CONFIRMATION

#pragma mark - Magic Retry constants

//Constants for Magic Retry
#define IS_MR_ENABLED @"isMREnabled"
#define IS_MR_WINDOW_SHOWN @"isMRWindowShown"
#define MR_ERROR_CODE @"mrErrorCode"

#define KEY_M_EURL @"m_retry_error"
#define KEY_MR_USER_INPUT @"m_retry_input"

#define VAL_SHOW_M_RETRY @"show_m_retry"
#define VAL_CLICK_M_RETRY @"click_m_retry"

//Constants for PUUICBViewController
#define kPUUINotiPaymentResponse  @"paymentResponse"

#pragma mark - System version identifier constants

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#pragma mark - View Tags

#define CB_TAG 500
#define MR_TAG 501

#pragma mark - NSLayout Contaraint constants
#define BOTTOM_CONSTRAINT @"bottomConstraint"

#endif
