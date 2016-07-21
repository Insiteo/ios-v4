Pod::Spec.new do |s|

  s.name         = "InsiteoSDKCore"
  s.version      = "4.1.0"
  s.summary      = "Official Insiteo SDK for iOS to access Insiteo Platform's core features"

  s.description  = <<-DESC
                    The Insiteo SDK for iOS Core framework provides:
                    * API usage
                    * Analytics tracking
                    * Location services (iBeacon, geofencing)
                  DESC

  s.homepage     = "https://github.com/Insiteo/ios-v4"
  s.license      = "Copyright 2015-present Insiteo SAS - All Rights Reserved"
  s.author       = "Insiteo"
  s.social_media_url = "https://twitter.com/Insiteo"

  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/Insiteo/ios-v4.git", :tag => 'v' + s.version.to_s }
  s.vendored_frameworks = "InsiteoSDKCore.framework"
  s.frameworks = "CoreLocation", "CoreTelephony", "Foundation", "MobileCoreServices", "Security", "SystemConfiguration", "UIKit"
  s.library   = "sqlite3"

  s.requires_arc = true
  s.xcconfig = { "OTHER_LDFLAGS" => "-ObjC" }

end
