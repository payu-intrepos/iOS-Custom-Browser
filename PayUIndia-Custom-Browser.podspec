Pod::Spec.new do |s|
  s.name                = "PayUIndia-Custom-Browser"
  s.version             = "6.1.1"
  s.license             = "MIT"
  s.homepage            = "https://github.com/payu-intrepos/iOS-Custom-Browser"
  s.author              = { "PayUbiz" => "contact@payu.in"  }

  s.summary             = "Custom browser for iOS by PayUbiz"
  s.description         = "iOS custom browser by PayUbiz helps user in payment flow to pay in as few taps as possible. The bank pages are generally not optimised for mobiles. It simplifies the awkward looking bank page on mobiles for user and helps in completing the transaction quickly. iOS custom browser gives custom controls (native UIButtons) to user which work as shortcuts to generate/enter OTP and pin. It helps in increasing the success rate of transactions."

  s.source              = { :git => "https://github.com/payu-intrepos/iOS-Custom-Browser.git", 
                            :tag => "#{s.name}_#{s.version}" }
  
  s.ios.deployment_target = "8.0"
  s.vendored_frameworks = 'PayUCustomBrowser.framework'

  s.pod_target_xcconfig = {'OTHER_LDFLAGS' => '-lObjC'} 

  #Run time config
  s.framework           = 'WebKit'
  s.library             = "z"
  s.requires_arc        = true
end
