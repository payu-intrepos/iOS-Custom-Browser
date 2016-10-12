Pod::Spec.new do |s|
  s.name                = "PayUIndia-Custom-Browser"
  s.version             = "5.2.1"
  s.license             = "MIT"
  s.homepage            = "https://github.com/payu-intrepos/iOS-Custom-Browser"
  s.author              = { "PayUbiz" => "contact@payu.in"  }

  s.summary             = "Custom browser for iOS by PayUbiz"
  s.description         = "iOS custom browser by PayUbiz helps user in payment flow to pay in as few taps as possible. The bank pages are generally not optimised for mobiles. It simplifies the awkward looking bank page on mobiles for user and helps in completing the transaction quickly. iOS custom browser gives custom controls (native UIButtons) to user which work as shortcuts to generate/enter OTP and pin. It helps in increasing the success rate of transactions."

  s.source              = { :git => "https://github.com/payu-intrepos/iOS-Custom-Browser.git", 
                            :tag => "v5.2.1" }
  s.documentation_url   = "https://github.com/payu-intrepos/Documentations/wiki/9.-iOS-Custom-Browser#si"
  s.platform            = :ios , "6.0"
  s.source_files        = "iOSCustomBrowser/*.{h}"
  s.resources           = ['iOSCustomBrowser/PUCBImages.xcassets', 'iOSCustomBrowser/*.{xib,plist,html}']
  s.public_header_files = "iOSCustomBrowser/*.{h}"
  s.preserve_paths      = "*.a"
  s.vendored_libraries  = "libiOSCustomBrowser.a"
  s.pod_target_xcconfig = {'OTHER_LDFLAGS' => '-lObjC'} 

  #Run time config
  s.framework           = 'WebKit'
  s.library             = "z"
  s.requires_arc        = true
end
