<p align="center" >
  <img src="https://raw.githubusercontent.com/Insiteo/ios-v4/assets/insiteo-logo.png" alt="Insiteo" title="Insiteo">
</p>

# Insiteo iOS SDK

Insiteo Proximity Interaction platform allows you to easily enable your Apps with:

- user Notifications, even when the app is not running,
- content delivery (webviews, media content...),
- contextualization: use in-app deep linking to bring your user right to the valuable content,
- IoT and local interactions: control in-building devices or systems,
- any other value-added action you may be thinking of.

To get started with our SDK, follow the steps below.

For a broader solution overview, [click here](http://insiteo.github.io/)


## Requirements

Insiteo iOS SDK is available for iOS 7.0 or higher.

For Push interaction related features:

- iOS 7.0 or higher (IOS 7.1.2 or iOS 8.0+ recommended)
- iPhone 4S / iPad 3rd generation / iPad mini / iPod touch 5th generation, or any more recent device


## Insiteo iOS SDK Class Reference

Insiteo iOS SDK class reference is available [here](http://insiteo.github.io/sdk/ios/latest/index.html).


## Installation

### Manual

You can install the Insiteo iOS SDK manually by following the steps below:

1. Clone or download the [Insiteo SDK](https://github.com/Insiteo/ios-v4/archive/master.zip).
2. Drag & drop the **InsiteoSDK.framework** into your Xcode project.
3. Add the following frameworks and librairies to your project (only if they are not already present):
	- `CoreLocation.framework` for internal location services.
	- `CoreTelephony.framework` for analytics services.
	- `SystemConfiguration.framework` for analytics services.
	- `MobileCoreServices.framework` for networking.
	- `libsqlite3.dylib` for cache storage (or add `-lsqlite3` to your **Other Linker Flags** project build settings).
	- `UIKit.framework`
	- `Foundation.framework`
4. Add `-Objc` to your **Other Linker Flags** project build settings.
5. Add `#import <InsiteoSDK/InsiteoSDK.h>` in your `AppDelegate.m` and type ⌘B to build your project.


### Swift: Add a Bridging Header

If you plan to use Swift instead of Objective-C for your project, you will need to add a **bridging header** in order to use our SDK (which is developed in Objective-C). This bridging header is automatically created by Xcode the first time you add an Objective-C file to your project. We are going to add a file called *Dummy* which can be deleted when your header will be generated.

1. Add a new file called *Dummy*: **File/New/File...** and select **iOS/Objective-C File**, choose **Empty File**, type *Dummy* and **Next** and **Create**.
2. Xcode will ask if you want to configure an Objective-C bridging header, type **YES**. Xcode will automatically create a file **<Project-Name>-Bridging-Header** and add it to your build settings in **Objective-C Bridging Header**.
3. You can now import the Insiteo required header `#import <InsiteoSDK/InsiteoSDK.h>` into this header file.

> **Compilation issues:** If the error `'InsiteoSDK/InsiteoSDK.h' file not found` occured, add a valid **Framework Search Paths** in your target build settings in order to help the compiler to find the framework.


### Location authorization iOS 8+

**Since iOS 8**, Apple requires you to ask user permission to use their location. You need to specify in your application *.plist* which location authorization is needed. Without any key, the SDK (and your application) will not have any access to location services.

- **Support both (Recommended)** : if you add the two keys to your *.plist*, the user will have the possibility to later change location authorizations through the application settings menu in iOS.

- Ask for **Always** authorization is required if you want to make use of background location services (such as iBeacon wake up). You must add the `NSLocationAlwaysUsageDescription` key.

- Ask for **When in use** authorization if you are not interested in background location services (your application will not be awaken by iBeacon, thus strongly reducing the benefits of using our SDK), add the `NSLocationWhenInUseUsageDescription`key

> **Advice:** When you define your description keys, the more the end-user will understand which value-add services are provided by your app, the more your user will be prone to accept the authorization.


## Where To Go From Here?

- Read the [Getting Started guide](https://github.com/Insiteo/ios-v4/blob/master/documentation/getting-started.md).
- Try out our [examples apps](https://github.com/Insiteo/ios-v4/tree/master/examples).
