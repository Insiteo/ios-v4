//
//  Insiteo.h
//  InsiteoSDKCore
//
//  Copyright 2015-present Insiteo SAS - All Rights Reserved
//

#import <Foundation/Foundation.h>

#import "INSConstants.h"

@protocol INSCoreLocationDelegate;

@class INSSite;

/*!
 The `Insiteo` class contains static functions to interact with the Insiteo framework.
 */
@interface Insiteo : NSObject

///-------------------------------
/// @name Initialization
///-------------------------------

/*!
 Initializes the Insiteo SDK with your client API key.
 
 The `modules` parameter is a `NSArray` of modules class. If you only want to use location services and no other 
 features, just pass an empty array or `nil`. Otherwise, you will call the init method like (analytics module):
 [Insiteo initializeWithAPIKey:@"YOUR-API-KEY" modules:@[ [INSAnalytics class] ] error:&error];
 
 @param APIKey  Your Insiteo client API key (available in 'My Profile' in your Insiteo web interface).
 @param modules Insiteo modules to work with.
 @param error   Pointer to a `NSError` that will be set if an error occured during initialization process.
 
 @return `YES` if the SDK has been initialized with a valid API key, otherwise `NO`.
 */
+ (BOOL)initializeWithAPIKey:(NSString *)APIKey modules:(NSArray *)modules error:(NSError **)error;

///-------------------------------
/// @name Synchronization
///-------------------------------

/*!
 Performs remote synchronization to retrieve your client configuration.
 
 The SDK should be properly initialized.
 
 @param successHandler A block which provides a boolean if the synchronization succeed, otherwise an `NSError` which 
 describes the problem.
 
 @see initializeWithAPIKey:modules:error:
 */
+ (void)synchronize:(InsiteoSuccessHandler)successHandler;

/*!
 Returns the last SDK synchronization date.
 
 @return The last synchronization date if the SDK has already been synchronized, otherwise `nil`.
 
 @see synchronize:
 */
+ (NSDate *)lastSynchronizationDate;

///-------------------------------
/// @name Start / Stop
///-------------------------------

/*!
 Boolean used to know if the SDK is started.
 
 @return `YES` if the SDK is started, otherwise `NO`.
 */
+ (BOOL)isStarted;

/*!
 Starts Insiteo SDK modules according to your client configuration.
 
 Insiteo SDK should be initialized AND synchronized.
 
 @param error Pointer to a `NSError` that will be set if an error occured during the start process.
 
 @see initializeWithAPIKey:modules:error:
 @see synchronize:
 */
+ (BOOL)start:(NSError **)error;

/*!
 Stops Insiteo SDK modules.
 
 If you need background support, do not stop the SDK on application killed. Geofences and beacons will not be monitored
 anymore and no action will be triggered until you call the `+start:` method again.
 */
+ (void)stop;

/*!
 Resets Insiteo SDK.
 
 This method will stop all modules (see `stop`) and will reset all SDK databases. After reseting the SDK you must call 
 `synchronize:` and `start:` methods again.
 */
+ (BOOL)resetSDK;

///-------------------------------
/// @name SDK Logging
///-------------------------------

/*!
 Returns the current log level.
 
 @return The current log level.
 */
+ (INSLogLevel)getSDKLogLevel;

/*!
 Sets a new log level.
 
 @param logLevel The new log level.
 */
+ (void)setSDKLogLevel:(INSLogLevel)logLevel;

///-------------------------------
/// @name Core Location Events
///-------------------------------

/*!
 Registers a delegate to core location events (iBeacon, geofencing, etc.).
 
 @param delegate The delegate receiver that is sent messages when location events occured.
 */
+ (void)registerLocationEventsDelegate:(id<INSCoreLocationDelegate>)delegate;

@end
