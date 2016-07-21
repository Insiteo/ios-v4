//
//  AppDelegate.m
//  BasicExample
//
//  Created by Lionel Rossignol on 18/07/2016.
//  Copyright © 2016 Insiteo. All rights reserved.
//

#import "AppDelegate.h"

#import <InsiteoSDKCore/InsiteoSDKCore.h>

@interface AppDelegate () <INSCoreLocationDelegate>

@end

@implementation AppDelegate

/* Only synchronize SDK once a day, for example */
#define kMaxSynchroOnStartupInterval 86400

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Enable background fetch
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    // Enable Insiteo SDK logs
    [Insiteo setSDKLogLevel:INSLogLevelInfo];
    // Enable analytics debug mode
    [INSAnalytics setDebugMode:YES];
    // Subscribe to location detection events
    [Insiteo registerLocationEventsDelegate:self];
    
    // Initialization
    NSError *error;
    if ([Insiteo initializeWithAPIKey:@"API-KEY" modules:@[ [INSAnalytics class] ] error:&error]) {
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

#pragma mark - Background Fetch

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
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
}

#pragma mark - INSCoreLocationDelegate

- (void)onBeaconRegionEnter:(INSBeaconRegion *)beaconRegion {
    NSLog(@"Beacon region enter: %@", beaconRegion.label);
}

- (void)onBeaconRegionExit:(INSBeaconRegion *)beaconRegion {
    NSLog(@"Beacon region exit: %@", beaconRegion.label);
}

- (void)onBeaconRegion:(INSBeaconRegion *)beaconRegion newStateDetected:(CLRegionState)state {
    NSString *stateString = (state == CLRegionStateInside) ? @"Inside" : (state == CLRegionStateOutside) ? @"Outside" : @"Unknown";
    NSLog(@"Beacon region new state detected: %@", stateString);
}

- (void)onBeaconsRanged:(NSArray<INSBeacon *> *)beacons inBeaconRegion:(INSBeaconRegion *)beaconRegion {
    NSLog(@"Beacon region ranging: %@", beaconRegion.label);
    
    NSMutableString *beaconsLabel = [[NSMutableString alloc] init];
    for (INSBeacon *beacon in beacons) {
        [beaconsLabel appendString:[NSString stringWithFormat:@"\n%@", beacon.label]];
    }
    
    NSLog(@"Beacons:%@", ([beaconsLabel length] > 0) ? beaconsLabel : @"No beacons detected");
}

- (void)onGeofenceAreaEnter:(INSGeofenceArea *)geofenceArea {
    NSLog(@"Geofence area enter: %@", geofenceArea.label);
}

- (void)onGeofenceAreaExit:(INSGeofenceArea *)geofenceArea {
    NSLog(@"Geofence area exit: %@", geofenceArea.label);
}

- (void)onGeofenceArea:(INSGeofenceArea *)geofenceArea newStateDetected:(CLRegionState)state {
    NSString *stateString = (state == CLRegionStateInside) ? @"Inside" : (state == CLRegionStateOutside) ? @"Outside" : @"Unknown";
    NSLog(@"Geofence area new state detected: %@", stateString);
}

@end
