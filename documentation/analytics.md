# Analytics: Track Custom Events

When the analytics module is started in our SDK, default events will be reported without you having to do anything. On the monitoring end, our platform will derive indicators such as : number of actions executed per user/type/date, action conversions, location analysis and dwell times.

This page indicates how to start the analytics component and how to report your own custom analytics events if you wish.

For a broader solution overview, [click here](http://insiteo.github.io/)


## Requirements

1. Successful SDK initialization and synchronization with `[INSAnalytics class]` module added (see [SDK Initialization](https://github.com/Insiteo/ios-v4/blob/master/documentation/getting-started.md#1-sdk-initialization)).
2. Auto-start or manually start (see [SDK Start](https://github.com/Insiteo/ios-v4/blob/master/documentation/getting-started.md#3-sdk-start))


## Usage

To interact with the Insiteo Analytics module, you will need to take a look at the [`INSAnalytics`](http://insiteo.github.io/sdk/ios/latest/Classes/INSAnalytics.html) class.


## Track Custom Events

The SDK provides you the possibility to track custom analytics events. Your custom events will be treated like every other SDK events and will be sent to the server if the module is started.

To track custom events you must call the [`+trackCustomEvent:metadata:debug:error:`](http://insiteo.github.io/sdk/ios/latest/Classes/INSAnalytics.html#//api/name/trackCustomEvent:metadata:debug:error:). This method will create an internal custom event with a name as a string and optional metadata as a dictionary of string keys/values that will be send to the server. The debug parameter is used to flag the message in debug mode, and the error, if not nil, will provide information if an error occured:

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

If you decide to flag every messages in debug mode (you are debugging your application and you do not want to track events), you can call the [`+setDebugMode:`](http://insiteo.github.io/sdk/ios/latest/Classes/INSAnalytics.html#//api/name/setDebugMode:) method, every new created messages will be flagged according to the boolean parameter.

> **Note:** Your custom events will not be affected by this method because the debug mode value is set on creation.

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	...    
    // You must call this method each time you want to enable debug mode on startup (disabled by default)
    [INSAnalytics setDebugMode:YES];
    ...
}
```

 
## Where To Go From Here?

- Take a look at our [examples](https://github.com/Insiteo/ios-v4/tree/master/examples) for more details.
