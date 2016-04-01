//
//  AppDelegate.m
//  Basic
//
//  Created by Lionel Rossignol on 17/03/2016.
//  Copyright © 2016 Insiteo. All rights reserved.
//

#import "AppDelegate.h"

#import <InsiteoSDK/InsiteoSDK.h>

@interface AppDelegate () <INSPushDelegate, NSURLSessionDataDelegate> {
    UIWebView *_basicWebView;
    NSURLSession *_basicSession;
}

@end

@implementation AppDelegate

////////
#pragma mark - Insiteo SDK
////////

- (void)startInsiteoSDK {
    NSError *error;
    BOOL success = [Insiteo start:&error];
    
    if (success) {
        // Register for Push delegation if I can use this service
        if ([INSPush isModuleAvailable]) {
            NSLog(@"Push service is available");
            [INSPush registerPushDelegate:self];
        }
        
    } else if (error) {
        NSLog(@"Insiteo SDK start error: %@", error.localizedDescription);
    }
}

////////
#pragma mark - UIApplicationDelegate
////////

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Background fetch: minimal fetch interval
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    // Insiteo Logging
    [INSLogger setLogLevel:INSLogLevelInfo];
    
    // Analytics debug mode
    // [INSAnalytics setDebugMode:YES];
    
    // Init Insiteo SDK
    NSError *error;
    [Insiteo initializeWithAPIKey:@"API-KEY" error:&error];
    
    if (!error) {
        // Check if SDK has already be synchronized at least once
        if ([Insiteo lastSynchronizationDate] == nil) {
            // Never synchonized
            [Insiteo synchronize:^(BOOL success, NSError *error) {
                if (success) {
                    // Start
                    [self startInsiteoSDK];
                    
                } else if (error) {
                    NSLog(@"Insiteo SDK synchronization error: %@", error.localizedDescription);
                }
            }];
            
        } else {
            // Start
            [self startInsiteoSDK];
        }
        
    } else {
        // Init error
        NSLog(@"Insiteo SDK init error: %@", error.localizedDescription);
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

////////
#pragma mark - Background Fetch
////////

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Note Insiteo SDK MUST be initialized first, here, +initializeWithAPIKey: is called in
    // application:didFinishLaunchingWithOptions which is called before this method.
    
    // Synchronize Insiteo SDK in background
    [Insiteo synchronize:^(BOOL success, NSError *error) {
        if (success) {
            // Everything has been synchronized successfully
            completionHandler(UIBackgroundFetchResultNewData);
        } else {
            // An error occured
            completionHandler(UIBackgroundFetchResultFailed);
        }
    }];
}

////////
#pragma mark - Notifications Acknowledgements
////////

// iOS 8+ only (otherwise use application:didReceiveLocalNotification: and check the application state)
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void(^)())completionHandler {
    // Let Insiteo SDK handle the notification
    [INSPush executeActionFromLocalNotification:notification];
}

////////
#pragma mark - INSPushDelegate
////////

/*
 This method will help you to override default SDK behaviors, and will let you do your own stuff with an action
 triggered by our system. You can imagine disable notification presentation when application is active or simply do
 logging, or even present a Web View when application is active.
 */
- (BOOL)shouldExecuteAction:(INSPushAction *)action triggeredBy:(INSTriggerSource)triggerSource {
    // Do stuff according to action type
    INSActionType type = action.type;
    switch (type) {
        case INSActionTypeNotification:
            // Notification
            break;
        case INSActionTypeWebView: {
            // Web View with an URL as a NSString as action.content
            if (action.content) {
                NSURL *url = [NSURL URLWithString:action.content];
                if (url) {
                    // Create a UIWebView, always on main thread ;-)
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (_basicWebView) {
                            [_basicWebView removeFromSuperview];
                        }
                        _basicWebView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                        // Customize your webview...
                        // webView.delegate = self; // To be notified on page loaded for example.
                        
                        // Create a Request
                        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                        // Add what you want to your request (HTTP header fields, user agent etc.)
                        // Finally load the request
                        [_basicWebView loadRequest:request];
                        // Add the view
                        [self.window addSubview:_basicWebView];
                    });
                }
            }
            break;
        } case INSActionTypeCustom: {
            // Custom action with your custom content as a NSString in action.content
            if (action.content) {
                // Example call a webservices with configuration as a JSON string in action.content
                //                if (action.filters && [action.filters isEqualToString:@"webservice"]) {
                // My action.content is a valid JSON string that looks like (minified):
                /*
                 {
                 "url": "https://httpbin.org/post",
                 "method": "POST",
                 "content-type": "application/json",
                 "body": "{ \"foo\": \"bar\" }"
                 }
                 */
                NSData *data = [action.content dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (json) {
                    NSString *urlString = json[@"url"];
                    NSString *methodString = json[@"method"];
                    NSString *contentType = json[@"content-type"];
                    NSString *bodyString = json[@"body"];
                    
                    if (urlString && methodString) {
                        NSURL *url = [NSURL URLWithString:urlString];
                        if (url) {
                            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                            [request setHTTPMethod:methodString];
                            
                            if (bodyString && contentType) {
                                NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
                                if (bodyData) {
                                    [request setHTTPBody:bodyData];
                                    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
                                }
                            }
                            
                            if (!_basicSession) {
                                _basicSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                            }
                            
                            NSURLSessionDataTask *task = [_basicSession dataTaskWithRequest:request
                                                                          completionHandler:^(NSData *data,
                                                                                              NSURLResponse *response,
                                                                                              NSError *error) {
                                                                              if (!error) {
                                                                                  NSLog(@"Custom request succeed !");
                                                                              } else {
                                                                                  // Handle error
                                                                              }
                                                                          }];
                            [task resume];
                        }
                    }
                }
            }
            break;
        } default:
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
    
    // Specific each time
    NSLog(@"Action triggered: %@", action.label);
    
    // Do stuff according to your action filters
    NSString *filters = action.filters;
    if ([filters isEqualToString:@"My-Filter"]) {
        NSLog(@"Very special stuff !");
        // I don't whant to execute this really specific one
        return NO;
    }
    
    // Never present notification when application is active
    UILocalNotification *notification = action.notification;
    if (notification) {
        // Check if application is active or not
        BOOL isActive = ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive);
        if (isActive) {
            // Disable default behavior
            return NO;
        }
    }
    
    // Return YES if you let the SDK executes its default behavior
    return YES;
}

@end
