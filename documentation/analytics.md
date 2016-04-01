# Analytics: Track custom events

Insiteo Proximity Interaction platform allows you to easily enable your Apps with:

- user Notifications, even when the app is not running,
- content delivery (webviews, media content...),
- contextualization: use in-app deep linking to bring your user right to the valuable content,
- IoT and local interactions: control in-building devices or systems,
- any other value-added action you may be thinking of.

When the analytics module is started in our SDK, default events will be reported without you having to do anything. On the monitoring end, our platform will derive indicators such as : number of actions executed per user/type/date, action conversions, location analysis and dwell times.

This page indicates how to start he analytics component and how to report your own custom analytics events if you wish.

For a broader solution overview, [click here](http://insiteo.github.io/)


## Pre-requisites

- Successful SDK initialization and synchronization [SDK Initialization Readme](https://github.com/Insiteo/ios-v4/).


## Usage

To interact with the Insiteo Analytics module, you will need to take a look at the **[`INSAnalytics`](http://insiteo.github.io/sdk/ios/latest/Classes/INSAnalytics.html)** interface.


### Start the Analytics Module

In order to start the Analytics module, the SDK should be properly initialized. If you haven't synchronized the SDK with the server yet, you need to synchronize your server client configuration through **[`+synchronize:`](http://insiteo.github.io/sdk/ios/latest/Classes/Insiteo.html#//api/name/synchronize:)** method. You can check module availability thanks to **[`+isModuleAvailable:`](http://insiteo.github.io/sdk/ios/latest/Classes/INSAnalytics.html#//api/name/isModuleAvailable)** method. You can start the module thanks to the **[`+start:`](http://insiteo.github.io/sdk/ios/latest/Classes/INSAnalytics.html#//api/name/start:)** method:

```objective-c
// Insiteo SDK MUST be initialized (in your AppDelegate)

...

// Check module availability
BOOL canIUseAnalytics = [INSAnalytics isModuleAvailable];
if (canIUseAnalytics) {
	NSLog(@"Yes, you can !");
}

...

// Start
NSError *error;
BOOL success = [INSAnalytics start:&error];
if (error) {
	NSLog(@"Analytics start failed: %@", error.localizedDescription);
}

...
    
```

### Stop the Analytics Module

To stop the Analytics module manually, you can call the **[`+stop:`](http://insiteo.github.io/sdk/ios/latest/Classes/INSAnalytics.html#//api/name/stop)** method:

```objective-c
...
// Stop Analytics module
[INSAnalytics stop];  
...
```

> **Note:** It will only stop sending tracked events to the server. If you want to retrieve all messages later, you will need to call `+start:` method again.


## Track Custom Events

The SDK provides you the possibility to track custom analytics events. Your custom events will be treated like every other SDK events and will be sent to the server if the module is started.

To track custom events you must call the **[`+trackCustomEvent:metadata:debug:error:`](http://insiteo.github.io/sdk/ios/latest/Classes/INSAnalytics.html#//api/name/trackCustomEvent:metadata:debug:error:)**. This method will create an internal custom event with a name as a string and optional metadata as a dictionary of string keys/values that will be send to the server. The debug parameter is used to flag the message in debug mode, and the error, if not nil, will provide information if an error occured:

```objective-c
...
// Ex: my user logged in successfully with Facebook
NSError *error;
[INSAnalytics trackCustomEvent:@"login_success" // Required
                      metadata:@{ @"user_id": @"1234", @"account_type": @"facebook" } // Optional
                         debug:NO
                         error:&error];
if (error) {
	NSLog(@"Custom event creation failed: %@", error.localizedDescription);
}
...
```

## Debug Mode

If you decide to flag every messages in debug mode (you are debugging your application and you do not want to track events), you can call the **[`+setDebugMode:`](http://insiteo.github.io/sdk/ios/latest/Classes/INSAnalytics.html#//api/name/setDebugMode:)** method, every new created messages will be flagged according to the boolean parameter.

> **Note:** Your custom events will not be affected by this method because the debug mode value is set on creation.

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	...    
    // You must call this method each time you want to enable debug mode on startup (disabled by default)
    [INSAnalytics setDebugMode:YES];
    ...
    // Other Insiteo stuff
	NSError *error;
    [Insiteo initializeWithAPIKey:@"API-KEY" error:&error];
    ...
}
```

 
## Where To Go From Here?

- [Push: Manage your Proximity Interactions](push.md).
