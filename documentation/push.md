# Push: Manage your Proximity Interactions

This page indicates how to start and manage Push/Interaction services with the **Push framework**.

For a broader solution overview, [click here](http://insiteo.github.io/)


## Requirements

1. Valid Push framework installation (see [Installation](https://github.com/Insiteo/ios-v4#installation)).
2. iOS 8+: Ask for location authorization (see [General Requirements](https://github.com/Insiteo/ios-v4#location-authorization-ios-8)).
3. Successful SDK initialization and synchronization with `[INSPush class]` module added (see [SDK Initialization](https://github.com/Insiteo/ios-v4/blob/master/documentation/getting-started.md#1-sdk-initialization)).
4. Auto-start or manually start (see [SDK Start](https://github.com/Insiteo/ios-v4/blob/master/documentation/getting-started.md#3-sdk-start))


## Usage

To interact with the Insiteo Push module, you will need to take a look at the [`INSPush`](http://insiteo.github.io/sdk/ios/latest/Classes/INSPush.html) class.


## Intercept Triggered Actions

Proximity interactions action will be triggered whenever required based on iBeacon proximity or Geofencing, according to the rules configured on the server. These actions can be triggered when your application is in the foreground or even in background or killed.

To properly intercept all triggered actions, we provide a delegate protocol [`INSPushDelegate`](http://insiteo.github.io/sdk/ios/latest/Protocols/INSPushDelegate.html) which allows you to intercept the action just before its default behavior is executed by our SDK. You can register a Push delegate through the [`+registerPushDelegate:`](http://insiteo.github.io/sdk/ios/latest/Classes/INSPush.html#//api/name/registerPushDelegate:) method from `INSPush` class.

```objective-c
// Register a Push module delegate to intercept action triggering
[INSPush registerPushDelegate:self];
```

Then, if you attempt to override default behaviors or if you want to do your own stuff when an action is triggered (custom analytics, custom webservice call, etc.), you should implement the [`-shouldExecuteAction:triggeredBy:triggerType:`](http://insiteo.github.io/sdk/ios/latest/Protocols/INSPushDelegate.html#//api/name/shouldExecuteAction:triggeredBy:triggerType:) method. This method is called just before an action is "executed" by the SDK according to its type and content (see the [Examples section below](https://github.com/Insiteo/ios-v4/blob/master/documentation/push.md#examples)). You can access to action information through the [`INSPushAction`](http://insiteo.github.io/sdk/ios/latest/Classes/INSPushAction.html) parameter, the trigger source (which could be an object of type [`INSBeacon`](http://insiteo.github.io/sdk/ios/latest/Classes/INSBeacon.html), [`INSBeaconRegion`](http://insiteo.github.io/sdk/ios/latest/Classes/INSBeaconRegion.html) or [`INSGeofenceArea`](http://insiteo.github.io/sdk/ios/latest/Classes/INSGeofenceArea.html) according to the trigger type parameter ([INSTriggerType](http://insiteo.github.io/sdk/ios/latest/Constants/INSTriggerType.html)).

### Action Types

By default, our SDK will execute default behavior according to action type and content:

- `INSActionTypeNotification`: This action can be represented as a notification banner with a title, a body message and custom user information as a dictionary (see [`UILocalNotification`](https://developer.apple.com/library/ios/documentation/iPhone/Reference/UILocalNotification_Class/) reference for more information). The SDK will present the notification immediately through the `-UIApplication presentLocalNotificationNow:` method.

- `INSActionTypeWebView`: This action can be represented as a physical Web view with an URL (`action.content`). For now, the SDK does not automatically trigger a `UIWebView`: in order for you to perfectlly integrate it in your application layout and design rules, we let you implement the few lines of code to display a Web view.

- `INSActionTypeCustom`: This action type is a generic container and can be used to trigger whatever you want. No default code behavior will be executed, you **must** implement the delegate method to intercept this action and do what you intend to.

> **Note:** If your action is configured with a notification, whatever its type, the SDK will create and present a `UILocalNotification`.

If a user has opened the application through a presented action notification, you may want the SDK to execute related action default behavior code (other than `INSActionTypeNotification`) or simply track the user acknowledgements. You will need to implement the following code into your `AppDelegate`:

```objective-c
// Lower than iOS 8
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
	// The application received the notification from an inactive state, i.e. the user tapped the notification
	if (application.applicationState == UIApplicationStateInactive) {
		// Let Insiteo SDK handle the notification
    	[INSPush executeActionFromLocalNotification:notification];
    }
}

// iOS 8+
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void(^)())completionHandler {
    // Let Insiteo SDK handle the notification
    [INSPush executeActionFromLocalNotification:notification];
    ...
    // Finalize
    if (completionHandler) {
        completionHandler();
    }
}
```

The following section will present you some best practises to manage triggered actions, some ways to override default behaviors or simply show you the power of custom generic actions.

### Examples

The following examples suppose that you have a class which is registered as `INSPushDelegate` and which implements the `-shouldExecuteAction:triggeredBy:triggerType:` method.

#### 1. Override default SDK behaviors

You could imagine to override some default behavior or only do one thing each time an action is triggered:

```objective-c
- (BOOL)shouldExecuteAction:(INSPushAction *)action triggeredBy:(id)triggerSource triggerType:(INSTriggerType)triggerType {    
    // Do stuff according to trigger type
    switch (triggerType) {
        case INSTriggerTypeBeacon: {
            // Beacon proximity
            INSBeacon *beacon = (INSBeacon *)triggerSource;
            break;
        } case INSTriggerTypeBeaconRegion: {
            // Beacon region enter / exit
            INSBeaconRegion *region = (INSBeaconRegion *)triggerSource;
            break;
        } case INSTriggerTypeGeofencing: {
            // Geofencing enter / exit
            INSGeofenceArea *geofence = (INSGeofenceArea *)triggerSource;
            break;
        } default:
            break;
    }
    
        // Do stuff according to action type
    switch (action.type) {
        case INSActionTypeNotification:
            // Notification
            break;
       case INSActionTypeWebView:
        	// Web View with an URL as a NSString in action.content
            break;
        case INSActionTypeCustom:
        	// Custom action with your custom content as a NSString in action.content
            break;
        default:
            break;
    }
    
    // Do stuff according to your action filters
    NSString *filters = action.filters;
    if (filters && [filters isEqualToString:@"My-Filter"]) {
    	NSLog(@"Very special stuff !");
    	// I don't want to execute this really specific one
    	return NO;
    }
    
    // Disable notification presentation
    action.notification = nil;
    
    // Return YES if you let the SDK executes its default behavior, otherwise NO
    return YES;
 }
```

#### 2. Present a UIWebView

Actually, the SDK does not implement code to present `UIWebView` (too much specific to be generic for every client). Here is an example of how you can proceed:

```objective-c
- (BOOL)shouldExecuteAction:(INSPushAction *)action triggeredBy:(id)triggerSource triggerType:(INSTriggerType)triggerType {    
    // Check if the action type is WebView
	if (action.type == INSActionTypeWebView) {
		// Get your URL
		if (action.content) {
			NSURL *url = [NSURL URLWithString:action.content];
			if (url) {
				// Create a UIWebView, always on main thread ;-)
				dispatch_async(dispatch_get_main_queue(), ^{
    				UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    				// Customize your webview...
    				// webView.delegate = self; // To be notified on page loaded for example.
    
    				// Create a Request
    				NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    				// Add what you want to your request (HTTP header fields, user agent etc.)
    				// Finally load the request
    				[webView loadRequest:request];
    				[self.window addSubview:webView];
				});
			}
		}
				
		// If you want to present the notification by yourself
		if (action.notification) {
			[[UIApplication sharedApplication] presentLocalNotificationNow:action.notification];
		}
		return NO;
	}
	// Let SDK do other stuff for you (other action or notification presentation if exists)
    return YES;
 }
```

#### 3. Handle Custom Actions

With the custom action you can do whatever you want. The only thing you we recommend is to fill the `action.content` property with a well formatted string (`JSON` for example) and use the `action.filters` to easily retrieve which action specific information.
In order to configure such kind of actions, you input the proper `JSON` in the action properties in our web interface, and interpret that `JSON`  file in your application whenever the action is triggered.

##### Web Service Call

A good example of the custom action utilisation is a web service call. In your application, you can call a server to retrieve dynamic information you want to show or execute in your app. The following code snippet provides an example.

> **Note:** This simple example can be adapted to use third party API like [`IFTTT Maker Channel`](https://ifttt.com/) or any other online API.

```objective-c
- (BOOL)shouldExecuteAction:(INSPushAction *)action triggeredBy:(id)triggerSource triggerType:(INSTriggerType)triggerType {
    // Check if the action type is Custom
    if (action.type == INSActionTypeCustom) {
        // Get your filters
        NSString *filters = action.filters;
        
        // Web service filter
        if ([filters isEqualToString:@"webservice"]) {
            // My action.content is a valid JSON string that looks like (minified):
            /*
             {
             "url": "https://my-custom-webservice-url.com",
             "method": "POST",
             "content-type": "application/json",
             "body": "{ \"foo\": \"bar\" }"
             }
             */
            
            // Parse action.content string to JSON NSDictionary to retrieve your data
            NSData *data = [action.content dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            // Create the request
            NSURL *url = [NSURL URLWithString:json[@"url"]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            
            // Configure the request
            [request setValue:json[@"content-type"] forHTTPHeaderField:@"Content-Type"];
            NSData *bodyData = [json[@"body"] dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:bodyData];
            
            // Send it asynchronous for example
            NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              // Catch the response
                                                              if (!error) {
                                                                  NSLog(@"Request success !");
                                                              }
                                                          }];
            [task resume];
        }
    }
    // Let SDK do other stuff for you (other action or notification presentation if exists)
    return YES;
}
```

## Where To Go From Here?

- Take a look at our [examples](https://github.com/Insiteo/ios-v4/tree/master/examples) for more details.