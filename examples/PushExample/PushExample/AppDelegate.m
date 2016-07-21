//
//  AppDelegate.m
//  PushExample
//
//  Created by Lionel Rossignol on 18/07/2016.
//  Copyright © 2016 Insiteo. All rights reserved.
//

#import "AppDelegate.h"

#import "WebViewController.h"

#import <InsiteoSDKCore/InsiteoSDKCore.h>
#import <InsiteoSDKPush/InsiteoSDKPush.h>

@interface AppDelegate () <INSPushDelegate>

@end

@implementation AppDelegate

/* Only synchronize SDK once a day, for example */
#define kMaxSynchroOnStartupInterval 86400

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Enable Insiteo SDK logs
    [Insiteo setSDKLogLevel:INSLogLevelInfo];
    // Enable analytics debug mode
    [INSAnalytics setDebugMode:YES];
    // Subscribe to Push action trigger events
    [INSPush registerPushDelegate:self];
    
    // Initialization
    NSError *error;
    if ([Insiteo initializeWithAPIKey:@"API-KEY" modules:@[ [INSAnalytics class], [INSPush class] ] error:&error]) {
        // Synchronization
        NSDate *lastSynchronization = [Insiteo lastSynchronizationDate];
        if (!lastSynchronization ||
            (lastSynchronization && [[NSDate date] timeIntervalSinceDate:lastSynchronization] >= kMaxSynchroOnStartupInterval)) {
            // Synchronization
            [Insiteo synchronize:^(BOOL success, NSError *error) {
                if (!success) {
                    NSLog(@"Synchro failed: %@", error.localizedDescription);
                } else if (success || lastSynchronization) {
                    // Start if synchro succeed or synchro has already been successful once
                    NSError *startError;
                    if (![Insiteo start:&error]) {
                        NSLog(@"Start failed: %@", startError.localizedDescription);
                    }
                }
            }];
        } else {
            // Start directly
            NSError *startError;
            if (![Insiteo start:&error]) {
                NSLog(@"Start failed: %@", startError.localizedDescription);
            }
        }
    } else {
        NSLog(@"Init failed: %@", error.localizedDescription);
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

#pragma mark - Notification Acknowledments

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void(^)())completionHandler {
    // Let Insiteo SDK handle the notification to execute action
    [INSPush executeActionFromLocalNotification:notification];
    
    // Do what you want like custom analytics according to action identifier
    if (identifier) {
        NSError *error;
        if (![INSAnalytics trackCustomEvent:@"notification_ack_action"
                                   metadata:@{ @"action_id": identifier }
                                      debug:YES
                                      error:&error]) {
            NSLog(@"Analytics custom tracking failed: %@", error.localizedDescription);
        }
    }
    
    // Finalize
    if (completionHandler) {
        completionHandler();
    }
}

#pragma mark - INSPushDelegate

- (BOOL)shouldExecuteAction:(INSPushAction *)action triggeredBy:(id)triggerSource triggerType:(INSTriggerType)triggerType {
    // Do stuff according to trigger type
    switch (triggerType) {
        case INSTriggerTypeBeacon: {
            // Beacon proximity
            INSBeacon *beacon = (INSBeacon *)triggerSource;
            NSLog(@"Beacon: %@", beacon.label);
            break;
        } case INSTriggerTypeBeaconRegion: {
            // Beacon region enter / exit
            INSBeaconRegion *region = (INSBeaconRegion *)triggerSource;
            NSLog(@"Beacon region: %@", region.label);
            break;
        } case INSTriggerTypeGeofencing: {
            // Geofencing enter / exit
            INSGeofenceArea *geofence = (INSGeofenceArea *)triggerSource;
            NSLog(@"Geofence area: %@", geofence.label);
            break;
        } default:
            break;
    }
    
    // Do stuff according to action type
    switch (action.type) {
        case INSActionTypeNotification:
            // Notification
            NSLog(@"Notification");
            break;
        case INSActionTypeWebView:
            // Web View with an URL as a NSString in action.content
            NSLog(@"Web View");
            if (action.content && ![action.content isEqualToString:@""]) {
                // Present Web view
                NSURL *url = [NSURL URLWithString:action.content];
                [self presentWebViewWithURL:url];
            }
            break;
        case INSActionTypeCustom:
            NSLog(@"Custom");
            // Custom action with your custom content as a NSString in action.content
            if (action.content && ![action.content isEqualToString:@""]) {
                NSData *data = [action.content dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (jsonDic) {
                    NSString *type = jsonDic[@"type"];
                    if (type && [type isEqualToString:@"webservice"]) {
                        /* Suppose we have a JSON like:
                         {
                         "type": "webservice",
                         "url": "http://my-ws-url.com",
                         "method": "GET",
                         "content-type": "application/json",
                         "body": "{ \"some-key\": \"some-value\" }"
                         } */
                        [self executeWebserviceWithJSON:jsonDic];
                    } else {
                        // Other custom
                    }
                }
            }
            break;
        default:
            break;
    }
    
    // Do stuff according to your action filters
    NSString *filters = action.filters;
    if (filters && [filters isEqualToString:@"action-analytics-only"]) {
        NSLog(@"Only track analytics custom");
        // Track analytics
        NSError *error;
        if (![INSAnalytics trackCustomEvent:@"action_analytics_only" metadata:nil debug:NO error:&error]) {
            NSLog(@"Analytics action_analytics_only tracking failed: %@", error.localizedDescription);
        }
        // Don't execute anything for me
        return NO;
    }
    
    // To disable default notification presentation, simply set to `nil`
    // action.notification = nil;
    // To edit title or body of the generated notification, update its properties
    // UILocalNotification *notification = action.notification;
    // notification.alertBody = [NSString stringWithFormat:@"Happy Birthday %@ !", @"John Doe"];
    
    // Default
    return YES;
}

- (void)presentWebViewWithURL:(NSURL *)url {
    static NSString *webViewControllerId = @"WebViewController";
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *webViewController = [mainStoryboard instantiateViewControllerWithIdentifier:webViewControllerId];
    webViewController.providesPresentationContextTransitionStyle = YES;
    webViewController.definesPresentationContext = YES;
    [webViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    // Present view on top of current
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.window.rootViewController presentViewController:webViewController animated:NO completion:^{
            [webViewController loadURL:url];
        }];
    });
}

- (void)executeWebserviceWithJSON:(NSDictionary *)json {
    // Get WS info
    NSString *urlString = json[@"url"];
    NSString *method = json[@"method"];
    NSString *contentType = json[@"content-type"];
    NSString *body = json[@"body"];
    
    NSURL *urlRequest = [NSURL URLWithString:urlString];
    if (urlRequest) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlRequest
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:20];
        // Method
        if (method) [request setHTTPMethod:method];
        // Content-Type
        if (contentType) [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        // Body
        if (body && contentType && [contentType isEqualToString:@"application/json"]) {
            // Transform body to JSON data
            NSData *objectData = [body dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:objectData];
        }
        
        // Send asynchronous request
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                     completionHandler:
                                      ^(NSData * _Nullable data,
                                        NSURLResponse * _Nullable response,
                                        NSError * _Nullable error) {
                                          if (error != nil) {
                                              NSLog(@"Action Custom request error: %@", error.localizedDescription);
                                          }
                                      }];
        [task resume];
    }
}

@end
