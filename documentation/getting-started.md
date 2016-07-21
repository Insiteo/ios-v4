# Getting Started with Insiteo iOS SDK

This is a guide to help developers get up to speed with Insiteo SDK. It will present all basic steps to initialize and interact properly with the SDK.

> This guide suppose that you have followed the framework installation process described [here](https://github.com/Insiteo/ios-v4/#installation).


## 1. SDK Initialization

> **Important:** We highly recommend to initialize and start the SDK into the `-application:didFinishLaunchingWithOptions:` delegate method from your `AppDelegate` class in order to catch every events as soon as possible.

The first step to use Insiteo services is to initialize the SDK using your client `API-KEY` (available in your account in the Insiteo web interface) and define which modules will be used.

This will be done using [`Insiteo`](http://insiteo.github.io/sdk/ios/latest/Classes/Insiteo.html) class which provides a couple of methods to interact with the SDK. The [`+initializeWithAPIKey:modules:error:`](http://insiteo.github.io/sdk/ios/latest/Classes/Insiteo.html#//api/name/initializeWithAPIKey:modules:error:) method which returns `YES` if the initialization succeed using last synchronized data, otherwise `NO` need your client API key and an array of class module. You can specify a `NSError` to catch information initialization issues:

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	...
    NSError *error;
    BOOL success = [Insiteo initializeWithAPIKey:@"API-Key"
                                         modules:@[ /* ex: [INSAnalytics class], [INSPush class] */ ]
                                           error:&error];
    if (success) {
		// Success
    } else {
        NSLog(@"Init error: %@", error.localizedDescription);
    }
    ...
}
```

Insiteo SDK modules are conforming to the [`INSSDKModule`](http://insiteo.github.io/sdk/ios/latest/Protocols/INSSDKModule.html) protocol which defines usage methods such as start, stop and clean methods. The current available modules are:

- [`INSAnalytics`](http://insiteo.github.io/sdk/ios/latest/Classes/INSAnalytics.html) which provides SDK analytics tracking and let you the possibility to track custom events (read more details [here](analytics.md)).
- [`INSPush`](http://insiteo.github.io/sdk/ios/latest/Classes/INSPush.html) which provides an interactivity system based on location services detection (beacon and geofencing) by triggering actions (read more details [here](push.md)).

## 2. SDK Server Synchronization

In order to start Insiteo services, the SDK needs to retrieve the latest configuration from our server.  You therefore need to force a server synchronization at least once by calling the [`+synchronize:`](http://insiteo.github.io/sdk/ios/latest/Classes/Insiteo.html#//api/name/synchronize:) method. The following example shows you how to catch if the SDK has never been synchronized:

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	...
	// Init SDK
    NSError *error;
    BOOL success = [Insiteo initializeWithAPIKey:@"API-Key"
                                         modules:@[ /* Modules class here */ ]
                                           error:&error];
    if (success) {
        // Check if SDK has never been synchronized
        if ([Insiteo lastSynchronizationDate] == nil) {
            // Synchronize
            [Insiteo synchronize:^(BOOL success, NSError *error) {
                if (success) {
                    // Success you can start now
                } else if (error) {
                    NSLog(@"Synchronization failed: %@", error.localizedDescription);
                }
            }];
        } else {
        	// Already synchronized, you can start using last synchronized configuration
        }
    }    ...
}    
```

### Keep SDK up-to-date with your server client configuration

In order to keep the SDK up-to-date with the latest server configuration, server synchronizations need to be done on a regular basis. You can do a synchronization on application start up (in your `AppDelegate` for example) or in the background, which is important to make sure the application is always up-to-date, event if it has not been started by the user for a while.

If you want to silently synchronize the SDK in the background, a convenient approach is to use *Background fetch* (see [`Apple reference`](https://developer.apple.com/library/ios/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/BackgroundExecution/BackgroundExecution.html)). The system will automatically wake up or launch your application in the background during ~30 seconds, to let you perform updates silently in the background.

Here are the steps to use Background fetch in your application:

- Enable **Background mode** in your project target **Capabilities** and check **Background fetch**. You can also add directly in your *Info.plist* the following keys:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
</array>
```

- Set the minimal fetch interval in order to inform the system into `-application:didFinishLaunchingWithOptions:` method from your `AppDelegate` class:

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	...
	// Configure the fetch interval for your application
	[application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
	...
}
```

- Implement the `-application:performFetchWithCompletionHandler:` method:

```objective-c
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
	...
    // Note: The SDK must be initialized before trying to synchronize to not fail. If
    // you have added the SDK initialization in the application:didFinishLaunchingWithOptions:
    // it will succeed.
    
    // Synchronize
    [Insiteo synchronize:^(BOOL success, NSError *error) {
        if (success) {
            // Everything has been synchronized successfully
            completionHandler(UIBackgroundFetchResultNewData);
        } else {
            // An error occured
            completionHandler(UIBackgroundFetchResultFailed);
        }
    }];
    ...
}
```

> **Note:** Background fetch **depends on the system**. If iOS decides to call your app just once a day or even just once a week than it won't be called more often regardless your `minimumBackgroundFetchInterval`.


## 3. Start SDK

After your successful initialization and server synchronization, you are now able to start SDK common services and modules. Calling [`+start:`](http://insiteo.github.io/sdk/ios/latest/Classes/Insiteo.html#//api/name/start:) method from `Insiteo` class will start automatically your available modules (if module *auto-start* is checked in your configuration). This method will return `NO` if an error occurred which can be catched specifying the `NSError` parameter:

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	...
    // Init SDK
    NSError *error;
    BOOL success = [Insiteo initializeWithAPIKey:@"API-Key"
                                         modules:@[ /* Modules class here */ ]
                                           error:&error];
    if (success) {
        // Already synchronized
        if ([Insiteo lastSynchronizationDate] != nil) {
            // Start
            success = [Insiteo start:&error];
            if (error) {
                NSLog(@"Start failed: %@", error.localizedDescription);
            }
        }
    }
    ...
}
```

### Force Module Start

If you have disabled *auto-start* for a specific module, you are able to force start by calling its own `start:` method. The following example force the Analytics module to start:

```objective-c
// Check availability
if ([INSAnalytics isAvailable]) {
	// Start
	NSError *error;
	BOOL success = [INSAnalytics start:&error];
	if (success) {
		// Success !
	} else {
		NSLog(@"Analytics start failed: %@", error.localizedDescription);
	}
}
```

> **Note:** 

> 1. You must have call `[Insiteo synchronize:]` method at least once before trying to start anything or it will failed.
> 2. Even you have disable the *auto-start* and want to start manually your module, you MUST call `[Insiteo start:]` method at first (to start location services and common features).

## 4. Stop SDK

To stop the Insiteo SDK, you can call the [`+stop`](http://insiteo.github.io/sdk/ios/latest/Classes/Insiteo.html#//api/name/stop) method which will stop all running services (location services and modules).

```objective-c
// Stop all your services
[Insiteo stop];
```
> **Warning**: Stopping the SDK will stop all location services and your application will not be waken in background by beacon proximity, unless you call the `[Insiteo start:]` method again.


### Reset SDK

You are also able to reset everything from Insiteo SDK by calling the [`+resetSDK`](http://insiteo.github.io/sdk/ios/latest/Classes/Insiteo.html#//api/name/resetSDK) method which will reset everything (stop everything + clean modules and reset your configuration). You will need to call `+synchronize` method again to retrieve your data.

### Module Specific Stop & Clean

As the `+start` method, each module can be stopped or clean individually by calling its own `+clean` or `+stop` method.


## 5. Subscribe to Location Services Events

The Insiteo SDK provides a delegate to easily be informed when a location detection event appears. To be notified on beacon regions entry/exit, beacons proximity detection or even geofencing regions boundarie crossing, you can implement a class that respond to the [`INSCoreLocationDelegate`](http://insiteo.github.io/sdk/ios/latest/Protocols/INSCoreLocationDelegate.html) protocol and call the [`+registerLocationEventsDelegate:`](http://insiteo.github.io/sdk/ios/latest/Protocols/INSCoreLocationDelegate.html#//api/name/registerLocationEventsDelegate:) method from `Insiteo` class:

```objective-c
#import <InsiteoSDKCore/InsiteoSDKCore.h>

@interface AppDelegate () <INSCoreLocationDelegate>

@end

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	...
	[Insiteo registerLocationEventsDelegate:self];
	...
}

#pragma mark - INSCoreLocationDelegate

- (void)onBeaconRegionEnter:(INSBeaconRegion *)beaconRegion {
    // On beacon region enter
}

// See INSCoreLocationDelegate.h for more callbacks

```


## Where To Go From Here?

- [Analytics: Track Custom Events](analytics.md).
- [Push: Add Location Based Interactions To Your App](push.md).