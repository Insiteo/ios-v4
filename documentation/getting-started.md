# Getting Started with Insiteo iOS SDK

This is a guide to help developers get up to speed with Insiteo SDK. It will present all basic steps to initialize and interact properly with the SDK.

> This guide suppose that you have followed the framework installation process described **[here](https://github.com/Insiteo/ios-v4/)**.
 

## 1. Initialization

> **Important:** We highly recommend to initialize and start the SDK into the `-application:didFinishLaunchingWithOptions:` delegate method from your `AppDelegate` in order to catch every event as soon as possible.

The first step to use Insiteo services is to initialize the SDK using your client `API-KEY` (available in 'My Profile' in your  Insiteo web interface).

This will be done using **[`Insiteo`](http://insiteo.github.io/sdk/ios/latest/Classes/Insiteo.html)** static class which provides a couple of methods to interact with the SDK. The **[`+initializeWithAPIKey:error:`](http://insiteo.github.io/sdk/ios/latest/Classes/Insiteo.html#//api/name/initializeWithAPIKey:error:)** static method which returns `YES` if the initialization succeed using last synchronized data, otherwise `NO`. You can specify a `NSError` to catch information initialization issues:

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	...
	NSError *error;
    BOOL initLocal = [Insiteo initializeWithAPIKey:@"API-KEY" error:&error];
    if (error) {
        NSLog(@"Init failed: %@", error.localizedDescription);
    }
    ...
}
```

## 2. Server synchronization

In order to start Insiteo services, the SDK needs to retrieve the latest configuration from our server.  You therefore need to force a server synchronization at least once by calling the **[`+synchronize:`](http://insiteo.github.io/sdk/ios/latest/Classes/Insiteo.html#//api/name/synchronize:)** method. The following example shows you how to catch if the SDK has never been synchronized:

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	...
	NSError *error;
    BOOL initLocal = [Insiteo initializeWithAPIKey:@"API-KEY" error:&error];
    // Init succeed but SDK never synchronized
    if (!error && !initLocal) {
    	// Synchronize SDK
        [Insiteo synchronize:^(BOOL success, NSError *error) {
            if (success) {
 				// Success !
            } else if (error) {
            	NSLog(@"Synchronization failed: %@", error.localizedDescription);
            }
        }];
    }
    ...
}    
```

### Keep Insiteo SDK up-to-date with your server client configuration

In order to keep the SDK up-to-date with the latest server configuration, server synchronizations need to be done on a regular basis. You can do a synchronization on application start up (in your AppDelegate for example) or in the background, which is important to make sure the application is always up to date, event if it has not been started by the user for a while.

If you want to silently synchronize  the SDK in the background, a convenient approach is to use *Background fetch* (see **[`Apple reference`](https://developer.apple.com/library/ios/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/BackgroundExecution/BackgroundExecution.html)**). The system will automatically wake up or launch your application in the background during ~30 seconds, to let you perform updates silently in the background.

Here are the steps to use Background fetch in your application:

- Enable **Background mode** in your project target **Capabilities** and check **Background fetch**. You can also add directly in your *.plist* the following keys:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
</array>
```

- Set the minimal fetch interval in order to inform the system into your AppDelegate `application:didFinishLaunchingWithOptions:` callback:

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	...
	// Configure the fetch interval for your application
	[[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
	...
}
```

- Implement in your AppDelegate the `application:performFetchWithCompletionHandler:` callback:

```objective-c
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
	...
    // Note: The SDK must be initialized in order to synchronize
    // You can init here or in application:didFinishLaunchingWithOptions:
    NSError *error;
    [Insiteo initializeWithAPIKey:@"API-KEY" error:&error];
    
    // Init succeed
    if (!error) {    
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
    } else {
        // An error occured
        completionHandler(UIBackgroundFetchResultFailed);
    }
    ...
}
```

> **Note:** Background fetch **depends on the system** If iOS decides to call your app just once a day or even just once a week than it won't be called more often regardless your `minimumBackgroundFetchInterval`.


## 3. Start Insiteo Services

After your successful initialization and server synchronization, you are now able to start your services. 

According to your client configuration, calling `Insiteo` **[`+start:`](http://insiteo.github.io/sdk/ios/latest/Classes/Insiteo.html#//api/name/start:)** method will start ALL your available modules. This method will return `NO` if an error occurred which can be catched specifying the `NSError` parameter:

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	...
    // Start
    NSError *error;
    BOOL success = [Insiteo start:&error];
    if (error) {
    	NSLog(@"Start failed: %@", error.localizedDescription);
    }
    ...
}
```

### Accessing services (modules)

The SDK provides a static interface for each module, in order to interact with them separately. Each interface provides a couple of methods to interact with the module (start, stop, etc.) and a method `+isModuleAvailable` which returns `YES` or `NO` if the module is available according to your client configuration:

- Analytics: **[`INSAnalytics`](http://insiteo.github.io/sdk/ios/latest/Classes/INSAnalytics.html)** which provides a couple of methods to interact with Analytics service.
- Push: **[`INSPush`](http://insiteo.github.io/sdk/ios/latest/Classes/INSPush.html)** which provides a couple of methods to interact with Push interaction service. 


## 4. Stop Insiteo services

To stop the Insiteo SDK, you can call the **[`+stop`](http://insiteo.github.io/sdk/ios/latest/Classes/Insiteo.html#//api/name/stop)** method which will stop all running services. As an alternative, you could stop each module separately (see Accessing services section above).

```objective-c
// Stop all your services
[Insiteo stop];
```
> **/!\ Push restrictions**: Stopping the Push module will stop all location proximity service and your application will not be waken in background by iBeacon proximity, unless you call the `Insiteo +start:` or `INSPush start:` method again.


## Where To Go From Here?

- [Push: Manage your Proximity Interactions](push.md).
- [Analytics: Track custom events](analytics.md).