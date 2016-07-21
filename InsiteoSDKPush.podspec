Pod::Spec.new do |s|

  s.name         = "InsiteoSDKPush"
  s.version      = "4.1.0"
  s.summary      = "Official Insiteo SDK for iOS to access Insiteo Platform's Push features"

  s.description  = <<-DESC
                    The Insiteo SDK for iOS Push framework provides proximity interactions:
                    * User notification, even when the app is not running,
                    * Content delivery (Web views, media content, etc.),
                    * Contextualization: use in-app deep linking to bring your user right to the valuable content,
                    * IoT and local interactions: control in-building devices or systems,
                    * Any other value-added action you may be thinking of.
                  DESC

  s.homepage     = "https://github.com/Insiteo/ios-v4"
  s.license      = "Copyright 2015-present Insiteo SAS - All Rights Reserved"
  s.author       = "Insiteo"

  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/Insiteo/ios-sdk-v4.git", :tag => s.version.to_s }
  s.vendored_frameworks = "InsiteoSDKPush.framework"
  s.frameworks = "CoreLocation", "CoreTelephony", "Foundation", "MobileCoreServices", "Security", "SystemConfiguration", "UIKit"
  s.library   = "sqlite3"

  s.requires_arc = true
  s.xcconfig = { "OTHER_LDFLAGS" => "-ObjC" }
  
  s.dependency 'InsiteoSDKCore'

end
