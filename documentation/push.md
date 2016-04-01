# Push: Manage your Proximity Interactions

Insiteo Proximity Interaction platform allows you to easily enable your Apps with:

- user Notifications, even when the app is not running,
- content delivery (webviews, media content...),
- contextualization: use in-app deep linking to bring your user right to the valuable content,
- IoT and local interactions: control in-building devices or systems,
- any other value-added action you may be thinking of.


This page indicates how to start and manage Push/Interaction services with the SDK.

For a broader solution overview, [click here](http://insiteo.github.io/)

## Requirements

- iOS 8+: Ask for location authorization (see **[`General requirements`](https://github.com/Insiteo/ios-v4#location-authorization-ios-8)**).
- Successful SDK initialization and synchronization.

## Usage

To interact with the Insiteo Push module, you will need to take a look at the **[`INSPush`](http://insiteo.github.io/sdk/ios/latest/Classes/INSPush.html)** interface.

### Start the Push Module

In order to start the Push module, the SDK needs to be properly initialized. If you haven't synchronized the SDK with the server yet, you need to synchronize your server client configuration through **[`+synchronize:`](http://insiteo.github.io/sdk/ios/latest/Classes/Insiteo.html#//api/name/synchronize:)** method. You can check module availability thanks to **[`+isModuleAvailable:`](http://insiteo.github.io/sdk/ios/latest/Classes/INSPush.html#//api/name/isModuleAvailable)** method. You can start the module thanks to the **[`+start:`](http://insiteo.github.io/sdk/ios/latest/Classes/INSPush.html#//api/name/start:)** method:

```objective-c
// Insiteo SDK MUST be initialized (in your AppDelegate)

...

// Check module availability
BOOL canIUsePush = [INSPush isModuleAvailable];
if (canIUsePush) {
	NSLog(@"Yes, you can !");
}

...

// Start
NSError *error;
BOOL success = [INSPush start:&error];
if (error) {
	NSLog(@"Push start failed: %@", error.localizedDescription);
}

...
    
```

> **Note:** The first time you start the Push Module, iBeacon management will configure iOS accordingly and your user will be prompted to authorize *Always location usage* (or *When in use location usage*). If you plan to use *Notification* action types, your user will also be prompted to authorize *notifications presentation*.

### Reset the Push Module Cache

The `INSPush` interface provides a **[`+clean`](http://insiteo.github.io/sdk/ios/latest/Classes/INSPush.html#//api/name/clean)** method to clean up and reset cache module. This will reset all triggers, actions and groups states and counters. This is more intended for development and test purposes than for an app in production.

```objective-c
...
// Reset Push module
[INSPush clean];  
...
```

### Stop the Push Module

> **/!\ Important note:** If you decide to manually stop the Push module, keep in mind that all background location services (iBeacon and Geofence) will be turned off. This means your application will not receive any location proximity events anymore until you call the `start:` method again.

To stop the Push module manually, call the **[`+stop:`](http://insiteo.github.io/sdk/ios/latest/Classes/INSPush.html#//api/name/stop)** method:

```objective-c
...
// Stop Push module
[INSPush stop];  
...
```

## Intercept Triggered Actions

Proximity interactions action will be triggered whenever required based on iBeacon proximity, according to the rules configured on the server. These actions can be triggered when your application is in the foreground or even in background or killed.

To properly intercept all triggered actions, we provide a delegate protocol **[`INSPushDelegate`](http://insiteo.github.io/sdk/ios/latest/Protocols/INSPushDelegate.html)** which allows you to intercept the action just before its default behavior is executed by our SDK. You can register a Push delegate through the **[`+registerPushDelegate:`](http://insiteo.github.io/sdk/ios/latest/Classes/INSPush.html#//api/name/registerPushDelegate:)** method.

```objective-c
...
// Register a Push module delegate to intercept action triggering
[INSPush registerPushDelegate:self];  
...
```

Then, if you attempt to override default behaviors or if you want to do your own stuff when an action is triggered (custom analytics, custom webservice call, etc.), you should implement the **[`-shouldExecuteAction:triggeredBy`](http://insiteo.github.io/sdk/ios/latest/Protocols/INSPushDelegate.html#//api/name/shouldExecuteAction:triggeredBy:)** method. This method is called just before an action is "executed" by the SDK according to its type and content. You could access to action information through the **[`INSPushAction`](http://insiteo.github.io/sdk/ios/latest/Classes/INSPushAction.html)** parameter and the trigger source **[`INSTriggerSource`](http://insiteo.github.io/sdk/ios/latest/Constants/INSTriggerSource.html)**.

### Action types

By default, our SDK will execute default behavior according to action type and content:

- `INSActionTypeNotification`: This action can be represented as a notification banner with a title, a body message and custom user information as a dictionary (see **[`UILocalNotification`](https://developer.apple.com/library/ios/documentation/iPhone/Reference/UILocalNotification_Class/)** reference for more information). The SDK will present the notification immediately through the `-UIApplication presentLocalNotificationNow:` method.

- `INSActionTypeWebView`: This action can be represented as a physical Web view with an URL (`action.content`). For now, the SDK does not automatically trigger a `UIWebView`: in order for you to perfectlly integrate it in your application layout and design rules, we let you implement the few lines of code to display a Web view.

- `INSActionTypeCustom`: This action type is a generic container and can be used to trigger whatever you want. No default code behavior will be executed, you **must** implement the delegate method to intercept this action and do what you intend to.

If a user has opened the application through a presented action notification, you may want the SDK to execute related action default behavior code (other than `INSActionTypeNotification`) or simply track the user acknowledgements. You will need to implement the following code into your `AppDelegate`:

```objective-c
// iOS 7+
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
}
 
```

The following section will present you some best practises to manage triggered actions, some ways to override default behaviors or simply show you the power of custom generic actions.

### Examples

The following examples suppose that you have a class which is registered as `INSPushDelegate` and which implements the `-shouldExecuteAction:triggeredBy` method.

#### 1. Override default SDK behaviors

You could imagine to override some default behavior or only do one thing each time an action is triggered:

```objective-c
- (BOOL)shouldExecuteAction:(INSPushAction *)action triggeredBy:(INSTriggerSource)triggerSource {
    // Do stuff according to action type
	INSActionType type = action.type;
	
    switch (type) {
        case INSActionTypeNotification:
            // Notification
            break;
       case INSActionTypeWebView:
        	// Web View with an URL as a NSString as action.content
            break;
        case INSActionTypeCustom:
        	// Custom action with your custom content as a NSString in action.content
            break;
        default:
            break;
    }
    
    // Do stuff according to trigger source
    switch (triggerSource) {
        case INSTriggerSourceIBeacon:
            // iBeacon proximity
            break;
        case INSTriggerSourceIBeaconRegion:
            // iBeacon region enter / exit
            break;
        default:
            break;
    }
    
    // Do stuff according to your action filters
    NSString *filters = action.filters;
    if ([filters isEqualToString:@"My-Filter"]) {
    	NSLog(@"Very special stuff !");
    	// I don't whant to execute this really specific one
    	return NO;
    }
    
    // Specific each time
    NSLog(@"Action triggered: %@", action.label);
    
    // Return YES if you let the SDK executes its default behavior, otherwise NO
    return YES;
 }

```

#### 2. Disable notification presentation when application is active

By default, when an action has a notification configured on the server, the SDK will always present the notification even the application is active (the notification will be presented in user notification center). You can easy disable the default presentation:

```objective-c
- (BOOL)shouldExecuteAction:(INSPushAction *)action triggeredBy:(INSTriggerSource)triggerSource {
    // Default to YES
    BOOL couldPresentNotification = YES;
                
    // Check if a notification is available for the action
    UILocalNotification *notification = action.notification;  
    if (notification != nil) {
    	// Check if application is active or not
    	BOOL isActive = ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive);
    	if (isActive) {
    		// Disable default behavior
    		couldPresentNotification = NO;
    	}
    }
    
    // Do custom stuff here
    
    // Inform SDK
    return couldPresentNotification;
 }

```

#### 3. Present a UIWebView

Actually, the SDK does not implement code to present `UIWebView` (too much specific to be generic for every client). Here is an example of how you can proceed:

```objective-c
- (BOOL)shouldExecuteAction:(INSPushAction *)action triggeredBy:(INSTriggerSource)triggerSource {    
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
				
		// If you do not want the SDK present the notification for you, present yourself
		// if (action.notification) {
        //	[[UIApplication sharedApplication] presentLocalNotificationNow:action.notification];
        // }
		// return NO;
	}
	// Let SDK do other stuff for you (other action or notification presentation if exists)
    return YES;
 }

```

#### 4. Handle Custom Actions

With the custom action you can do whatever you want. The only thing you we recommend is to fill the `action.content` property with a well formatted string (`JSON` for example) and use the `action.filters` to easily retrieve which action specific information.
In order to configure such kind of actions, you input the proper `JSON` in the action properties in our web interface, and interpret that `JSON`  file in your application whenever the action is triggered.

##### Web Service Call

A good example of the custom action utilisation is a web service call. In your application, you can call a server to retrieve dynamic information you want to show or execute in your app. The following code snippet provides an example.

> **Note:** This simple example can be adapted to use third party API like **[`IFTTT Maker Channel`](https://ifttt.com/)** or any other online API.

```objective-c
- (BOOL)shouldExecuteAction:(INSAction *)action
          localNotification:(UILocalNotification *)notification
                triggeredBy:(INSTriggerType)triggerSource {    
    // Check if the action type is Custom
	if (action.type == INSActionTypeCustom) {
		// Get your filters
		NSString *filters = action.filters;
		
		// Web service filter
		if ([filters isEqualToString:@"webservice"]) {
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
    		NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:0 error:nil];
		
			// Create the request
			NSURL *url = [NSURL URLWithString:json[@"url"]];
			NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
			
			// Configure the request
			[request setValue:json[@"content-type"] forHTTPHeaderField:@"Content-Type"];
			
			//Transform body to JSON data
            NSData *bodyData = [json[@"body"] dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:bodyData];
            
            // Send it asynchronous for example
            NSURLSession *basicSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLSessionDataTask *task = [_basicSession dataTaskWithRequest:request
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

- [Analytics: Track custom events](analytics.md).
