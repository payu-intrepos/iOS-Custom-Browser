require 'httparty'
require 'colorize'

# Supress warning messages.
original_verbose, $VERBOSE = $VERBOSE, nil

# Make the API request
url = "https://api.github.com/repos/payu-intrepos/payu-params-iOS/contents/Version.txt"
response = HTTParty.get(url)

# Check if the request was successful
if response.code == 200
  # Extract the content from the response
  content = Base64.decode64(response['content'])
  # Evaluate the content of the file
  eval(content)
else
  puts "\n==> Failed to retrieve Version.txt file. HTTP status code: #{response.code}".red
end

# Activate warning messages again.
$VERBOSE = original_verbose

#Pod

Pod::Spec.new do |s|
  s.name                = "PayUIndia-Custom-Browser"
  s.version             = CUSTOM_BROWSER_POD_VERSION
  s.license             = "MIT"
  s.homepage            = "https://github.com/payu-intrepos/iOS-Custom-Browser"
  s.author              = { "PayUbiz" => "contact@payu.in"  }

  s.summary             = "Custom browser for iOS by PayUbiz"
  s.description         = "iOS custom browser by PayUbiz helps user in payment flow to pay in as few taps as possible. The bank pages are generally not optimised for mobiles. It simplifies the awkward looking bank page on mobiles for user and helps in completing the transaction quickly. iOS custom browser gives custom controls (native UIButtons) to user which work as shortcuts to generate/enter OTP and pin. It helps in increasing the success rate of transactions."

  s.source              = { :git => "https://github.com/payu-intrepos/iOS-Custom-Browser.git", 
                            :tag => "#{s.version}" }
  
  s.ios.deployment_target = "11.0"
  s.vendored_frameworks = 'PayUCustomBrowser.xcframework'

  s.pod_target_xcconfig = {'OTHER_LDFLAGS' => '-lObjC'} 

  #Run time config
  s.framework           = 'WebKit'
  s.library             = "z"
  s.requires_arc        = true
  s.dependency            'PayUIndia-Analytics', '3.0'
 
  CUSTOM_BROWSER_PODSPEC_DEPENDENCIES.each do |dependency|
    dependency
  end
  
end
