//
//  INSPush.h
//  InsiteoSDK
//
//  Created by Lionel Rossignol on 03/03/2016.
//  Copyright © 2016 Insiteo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "INSConstants.h"

@protocol INSPushDelegate;

@class UILocalNotification;

/*!
 `INSPush` provides an interface to interact with Insiteo Push module.
 */
@interface INSPush : NSObject

///-------------------------------
/// @name Start / Stop
///-------------------------------

/*!
 Method used to know if the Push module is started.
 
 @return `YES` if the module is started, otherwise NO.
 */
+ (BOOL)isStarted;

/*!
 Starts the Push module.
 
 @param error Pointer to a `NSError` that will be set if an error occured.
 
 @return `YES` if the module started successfully, otherwise `NO`.
 */
+ (BOOL)start:(NSError **)error;

/*!
 Stops the Push module.
 */
+ (void)stop;

///-------------------------------
/// @name Clean Cache
///-------------------------------

/*!
 Cleans the Push module cache.
 */
+ (void)clean;

///-------------------------------
/// @name Application
///-------------------------------

/*!
 When the application is launched from a `UILocalNotification`, the SDK could try to handle the notification and
 execute appropriate behavior if needed.
 
 @param localNotification The notification that launched the application.
 */
+ (void)executeActionFromLocalNotification:(UILocalNotification *)localNotification;

///-------------------------------
/// @name Push Delegate
///-------------------------------

/*!
 Registers to the Push module events.
 
 @param delegate The delegate receiver that is sent messages when the Push module will exectute triggered actions.
 */
+ (void)registerPushDelegate:(id<INSPushDelegate>)delegate;

///-------------------------------
/// @name Module Availability
///-------------------------------

/*!
 Checks if you are able to use Push module according to your client configuration.
 
 @return `YES` if Push module is available, otherwise `NO`.
 */
+ (BOOL)isModuleAvailable;

@end
