//
//  INSLogger.h
//  InsiteoSDK
//
//  Created by Lionel Rossignol on 20/11/2015.
//  Copyright © 2015 Insiteo. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 `INSLogLevel` enum specifies different levels of logging that could be used to limit or display more messages in logs.
 */
typedef NS_ENUM(NSUInteger, INSLogLevel) {
    /*!
     Log level that disables all logging.
     */
    INSLogLevelNone = 0,
    /*!
     Log level that if set is going to output error messages to the log.
     */
    INSLogLevelError = 1,
    /*!
     Log level that if set is going to output the following messages to log:
     - Errors
     - Warnings
     */
    INSLogLevelWarning = 2,
    /*!
     Log level that if set is going to output the following messages to log:
     - Errors
     - Warnings
     - Informational messages
     */
    INSLogLevelInfo = 3,
};

/*!
 The `INSLoggerDelegate` protocol defines a method that a delegate of `INSLogger` object can optionally implement to 
 intercept logging message.
 */
@protocol INSLoggerDelegate <NSObject>

@optional

/*!
 Sent when a message will be logged.
 
 @param level   The log level used for the message.
 @param tag     The tag used for the message (could be nil).
 @param message The logged message.
 */
- (void)getLogWithLevel:(INSLogLevel)level tag:(NSString *)tag message:(NSString *)message;

@end

/*!
 The `INSLogger` class will manage Insiteo SDK logging. You can change the current log level and enable or disable file 
 logging.
 */
@interface INSLogger : NSObject

/*!
 Defines a delegate receiver conforming to `INSLoggerDelegate` protocol to intercept logging messages.
 
 @param delegate A delegate receiver.
 */
+ (void)setDelegate:(id<INSLoggerDelegate>)delegate;

///-------------------------------
/// @name Accessing Log Levels
///-------------------------------

/*!
 Returns the current log level.
 
 @return The current log level.
 */
+ (INSLogLevel)getLogLevel;

/*!
 Sets a new log level.
 
 @param logLevel The new log level.
 */
+ (void)setLogLevel:(INSLogLevel)logLevel;

@end
