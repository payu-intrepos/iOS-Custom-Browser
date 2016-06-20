Pod::Spec.new do |s|
  s.name                = "PayUIndia-Custom-Browser"
  s.version             = "5.1"
  s.license             = { :type => "MIT", :file => "LICENSE" }
  s.homepage            = "https://github.com/payu-intrepos/iOS-Custom-Browser"
  s.author              = { "PayUbiz" => "contact@payu.in"  }

  s.summary             = "Custom browser for iOS by PayUbiz"
  s.description         = "iOS custom browser by PayUbiz helps user in payment flow to pay in as few taps as possible. The bank pages are generally not optimised for mobiles. It simplifies the awkward looking bank page on mobiles for user and helps in completing the transaction quickly. iOS custom browser gives custom controls (native UIButtons) to user which work as shortcuts to generate/enter OTP and pin. It helps in increasing the success rate of transactions."

  s.source              = { :git => "https://github.com/payu-intrepos/iOS-Custom-Browser.git", 
                            :commit => "f712986a5334f86b660e906569fe3c495828acda" }
  s.documentation_url   = "https://github.com/payu-intrepos/Documentations/wiki/9.-iOS-Custom-Browser#si"
  s.platform            = :ios , "6.0"
  s.source_files        = "iOSCustomBrowser/*.{h}"
  s.resource_bundle     = { "PUCBRes" => "iOSCustomBrowser/*.{xib, plist, xcassets}"}
  s.public_header_files = "iOSCustomBrowser/*.{h}"
  s.preserve_paths      = "*.a"
  s.vendored_libraries  = "libiOSCustomBrowser.a"

  #Run time config
  s.compiler_flags = "-ObjC"
  s.library = "z"
  s.weak_frameworks = "Foundation", "UIKit"
  s.requires_arc     = true
end
