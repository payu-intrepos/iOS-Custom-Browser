### Important Update - CB versions 5.7.2 and below are deprecated
*On iOS 12 and above versions of iOS, Older CB UI (versions 5.7.2 and below) will not appear on the app. The app users will still be able to complete transaction with CB's webview, but they will not be able to use any of its great features.*

*This has been done to prevent crashes. We identified some uncommon keyboard notifications on tapping OTP suggestion above keyboard in iOS 12. This has been handled in CB 5.8.*

*There is almost no additional integration required to update from CB 5.x to 5.8.*

### iOS Custom Browser's compelling Features:
#### Auto fill SMS into bank pages' OTP fields (Available on iOS 12)

CB helps by presenting OTP as suggestion over keyboard on bank page. With this feature, iOS users can now transact as fast as Android users as mannual entry of OTP is no longer required.

With CB engineering, OTP suggestion will be visible on all bank pages, irrespective of the fact that CB UI is visible there or not. For illustration, see below. OTP suggestion is visible even when user taps on Citi Bank's OTP field.

<p align="center">
  <img src ="https://media.giphy.com/media/kG16kdfY2N9oizUeTL/giphy.gif" />
</p>

#### SurePay - In case of flaky internet connection, help users to restore otherwise failing transaction

SurePay can recover the failing transaction due to internet connectivity issues. It can recover the transantion from any failing hop. If the case of no-internet-connection, we display a screen which gives user 3 options:

'Try later': We will reinitiate the transaction when the internet becomes available.

'Retry Now': We will attempt to reinitiate the transaction immediately. If the internet is unavailable, we notify the user.

'Cancel': Let the user cancel transaction.

In such cases, if internet goes-off, SurePay screen will appear n times (value set by the merchant, max value 3). SurePay will not come into the picture after n attempts. 

<p align="center">
  <img src ="https://media.giphy.com/media/MuE9Qkn4ENNKGtQhJb/giphy.gif" />
</p>

#### Review Order - Help in making critical information of the transaction available throughout the payment journey

With Review Order merchant can display an ongoing transaction’s information to the user on bank page. This will help the user to verify transaction related critical information while making a payment, and prevents users from pressing back button, cancelling the transaction, just to review or re-check their order details.

This features can be boon for merchants who have to charge penalty for changing the order details, like flight dates, hotel booking dates, movie show timings etc. With RO, customer can verify these details on bank page itself and make payment with confidence.

<p align="center">
  <img src ="https://thumbs.gfycat.com/CleverSmallFanworms-size_restricted.gif" />
</p>


#### Mobile optimized experience
CB optimizes bank pages for easier interaction and minimizes the chances of accidental clicks on transaction abort buttons. 

It HTML pages of most popular net banks (SBI, HDFC, PNB etc.)

#### Reduces total transaction time 
CB offers to save userid of net banking users. If opted for, it auto fills the userid from next transaction onwards on same bank (Password is never saved)

#### Full WKWebView support
Reduce your apps memory foot print by using CB's WKWebView as default WebView. UIWebView is deprecated from iOS 12. So, WKWebView is the way going forward and CB already has support for it.


### 

### Integration document of iOS custom browser can be found [here](https://github.com/payu-intrepos/Documentations/wiki/9.-iOS-Custom-Browser#si)

