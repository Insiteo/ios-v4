//
//  INSPushAction.h
//  InsiteoSDKPush
//
//  Copyright 2015-present Insiteo SAS - All Rights Reserved
//

#import <Foundation/Foundation.h>

#import "INSActionType.h"

@class UILocalNotification;

/*!
 `INSPushAction` class represents an action entity that will be configured according to your client configuration on 
 the server.

 This action will be created by the SDK and passing through `INSPushDelegate` callback methods to application. You can 
 use the automatically generated action properties or update with your own values. For example: when the action is 
 triggered, you can customize the notification title or body for a specific user.
 */
@interface INSPushAction : NSObject

/*!
 Action type.
 
 @see INSActionType
 */
@property (nonatomic, assign, readonly) INSActionType type;

/*!
 Action label.
 */
@property (nonatomic, copy, readonly) NSString *label;

/*!
 Action content.
 */
@property (nonatomic, copy, readonly) NSString *content;

/*!
 Action filters.
 */
@property (nonatomic, copy, readonly) NSString *filters;

/*!
 Action notification if configured, otherwise `nil`.
 
 This value can be updated before execution (i.e. you can change its `title`, `body` and `userInfo` properties or set 
 directly a new local notification before presentation or simply set to `nil` to discard presentation).
 */
@property (nonatomic, strong, readwrite) UILocalNotification *notification;

@end
