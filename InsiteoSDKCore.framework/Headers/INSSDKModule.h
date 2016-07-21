//
//  INSSDKModule.h
//  InsiteoSDKCore
//
//  Copyright 2015-present Insiteo SAS - All Rights Reserved
//

#import <Foundation/Foundation.h>

/*!
 `INSSDKModule` protocol defines Insiteo SDK module interface. 
 */
@protocol INSSDKModule <NSObject>

///-------------------------------
/// @name Availability
///-------------------------------

/*!
 Checks if you are able to use the specific module according to your client configuration.
 
 @return `YES` if the module is available, otherwise `NO`.
 */
+ (BOOL)isAvailable;

///-------------------------------
/// @name Start / Stop
///-------------------------------

/*!
 Checks if the module is started.
 
 @return `YES` if the module is started, otherwise `NO`.
 */
+ (BOOL)isStarted;

/*!
 Starts the module manually.
 
 @param error Pointer to a `NSError` that will be set if an error occured.
 
 @return `YES` if the module started successfully, otherwise `NO`.
 */
+ (BOOL)start:(NSError **)error;

/*!
 Stops the module manually.
 */
+ (void)stop;

///-------------------------------
/// @name Clean
///-------------------------------

/*!
 Clean module data.
 */
+ (void)clean;

@end
