//
//  INSAnalytics.h
//  InsiteoSDK
//
//  Created by Lionel Rossignol on 09/02/2016.
//  Copyright © 2016 Insiteo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "INSConstants.h"

/*!
 `INSAnalytics` provides an interface to Insiteo analytics backend.
 
 Tracking methods will return immediately and cache the event to be handled "eventually." That is, the request
 will be sent according to your configuration if possible or the next time a network connection is available.
 */
@interface INSAnalytics : NSObject

///-------------------------------
/// @name Start / Stop
///-------------------------------

/*!
 Method used to know if the Analytics module is started.
 
 @return `YES` if the module is started, otherwise NO.
 */
+ (BOOL)isStarted;

/*!
 Starts the Analytics module.
 
 @param error Pointer to a `NSError` that will be set if an error occured.
 
 @return `YES` if the module started successfully, otherwise `NO`.
 */
+ (BOOL)start:(NSError **)error;

/*!
 Stops the Analytics module.
 */
+ (void)stop;

///-------------------------------
/// @name Module Availability
///-------------------------------

/*!
 Checks if you are able to use Analytics module according to your client configuration.
 
 @return `YES` if Analytics module is available, otherwise `NO`.
 */
+ (BOOL)isModuleAvailable;

///-------------------------------
/// @name Custom Events
///-------------------------------

/*!
 Tracks the occurrence of a custom event with additional metadata.
 
 To track a specific event consider the following example:
 
 NSError *error;
 NSDictionary *metadata = @{ @"mydata1": @"data1", @"mydata2": @"data2", @"mydata3": @"data3" };
 [INSAnalytics trackCustomEvent:@"myevent" metadata:metadata debug:NO error:&error];
 
 @param name     The event name.
 @param metadata Related event metadata. Keys and values should be NSStrings, will throw otherwise.
 @param isDebug  Boolean used to tag the custom event as debug.
 @param error    Pointer to a `NSError` that will be set if an error occured.
 
 @return `YES` is the event creation succeed, `NO` otherwise.
 */
+ (BOOL)trackCustomEvent:(NSString *)name
                metadata:(NSDictionary <NSString *, NSString *> *)metadata
                   debug:(BOOL)isDebug
                   error:(NSError **)error;

///-------------------------------
/// @name Debug Mode
///-------------------------------

/*!
 Enables or disables Analytics debug mode.
 
 @param enable Passing `YES` will flag EVERY analytics messages as debug on creation (except your custom events).
 */
+ (void)setDebugMode:(BOOL)enable;

@end
