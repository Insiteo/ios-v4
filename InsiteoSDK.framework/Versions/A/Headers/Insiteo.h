//
//  Insiteo.h
//  InsiteoSDK
//
//  Created by Lionel Rossignol on 14/09/2015.
//  Copyright (c) 2015 Insiteo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "INSConstants.h"

/*!
 The `Insiteo` class contains static functions to interact with the Insiteo framework.
 */
@interface Insiteo : NSObject

///-------------------------------
/// @name Initialization
///-------------------------------

/*!
 Initializes the Insiteo SDK with your client API key.
 
 @param APIKey Your Insiteo client API key (available in 'My Profile' in your Insiteo web interface).
 @param error  Pointer to a `NSError` that will be set if an error occured during initialization process.
 
 @return `YES` if the SDK has been initialized with a valid API key, otherwise, `NO`.
 */
+ (BOOL)initializeWithAPIKey:(NSString *)APIKey error:(NSError **)error;

///-------------------------------
/// @name Synchronization
///-------------------------------

/*!
 Performs remote synchronization to retrieve your client configuration.
 
 The SDK should be properly initialized.
 
 @param successHandler A block which provides a boolean if the synchronization succeed, otherwise an `NSError` which 
 describes the problem.
 
 @see initializeWithAPIKey:error:
 */
+ (void)synchronize:(InsiteoSuccessHandler)successHandler;

/*!
 Returns the last SDK synchronization date.
 
 @return The last synchronization date if the SDK has already been synchronized, otherwise `nil`.
 
 @see synchronize:
 */
+ (NSDate *)lastSynchronizationDate;

///-------------------------------
/// @name Start / Stop Insiteo SDK
///-------------------------------

/*!
 Starts Insiteo SDK modules according to your client configuration.
 
 Insiteo SDK should be initialized AND synchronized.
 
 @param error Pointer to a `NSError` that will be set if an error occured during the start process.
 
 @see initializeWithAPIKey:error:
 @see synchronize:
 */
+ (BOOL)start:(NSError **)error;

/*!
 Stops Insiteo SDK modules. 
 
 If you need background support, do not stop the SDK on application killed. Geofences and beacons will not be monitored 
 anymore and no action will be triggered until you call the `+start:` method again.
 */
+ (void)stop;

///-------------------------------
/// @name Insiteo Root Directory
///-------------------------------

/*!
 Returns the default Insiteo root directory path.
 
 @return The Insiteo default root directory path.
 */
+ (NSString *)rootDirectoryPath;

@end
