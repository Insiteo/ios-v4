//
//  INSConstants.h
//  InsiteoSDK
//
//  Created by Lionel Rossignol on 29/12/2015.
//  Copyright © 2015 Insiteo. All rights reserved.
//

#import <Foundation/Foundation.h>

///-------------------------------
/// @name Insiteo SDK
///-------------------------------

/*!
 Insiteo SDK version.
 */
FOUNDATION_EXPORT NSString *const InsiteoSDKVersion;

///-------------------------------
/// @name Errors
///-------------------------------

/*!
 Insiteo error domain.
 */
FOUNDATION_EXPORT NSString *const INSInsiteoErrorDomain;

/*!
 `INSErrorCode` enum contains all custom error codes that are used as `code` for `NSError` in Insiteo SDK.
 
 These codes are used when `domain` of `NSError` that you receive is set to `INSInsiteoErrorDomain`.
 */
typedef NS_ENUM(NSUInteger, INSErrorCode) {
    /*!
     Internal server error. No information available.
     */
    kINSErrorInternal = 1,
    
    /*!
     Your client API key is invalid.
     */
    kINSErrorBadCredentials = 100,
    /*!
     SDK initialization failed.
     */
    kINSErrorInitialization = 101,
    /*!
     SDK synchronization failed.
     */
    kINSErrorSynchronization = 102,
    /*!
     The operation is not allowed for client.
     */
    kINSErrorAuthorization = 103,
    /*!
     Invalid event name.
     */
    kINSErrorInvalidEventName = 104,
    /*!
     Invalid event data format.
     */
    kINSErrorInvalidEventData = 105,
    /*!
     Malformed json object. A json dictionary is expected.
     */
    kINSErrorInvalidJSON = 200,
    /*!
     The request failed for unknown reason.
     */
    kINSErrorServerUnknown = 300,
    /*!
     The request timed out on the server.
     */
    kINSErrorServerTimeOut = 301,
    /*!
     The request failed on the server that received an invalid response from an upstream server.
     */
    kINSErrorServerBadGateway = 302,
};

///-------------------------------
/// @name Blocks
///-------------------------------

/*!
 A block that provides a boolean if an operation succeed, otherwise an `NSError` that describes the problem.
 
 @param success `YES` if the operation succeed, otherwise `NO`.
 @param error   If not nil an `NSError` that describes the problem.
 */
typedef void (^InsiteoSuccessHandler)(BOOL success, NSError *error);