//
//  INSPushAction.h
//  Insiteo
//
//  Created by Lionel Rossignol on 11/03/2016.
//  Copyright © 2016 Insiteo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "INSActionType.h"

@class UILocalNotification;

/*!
 `INSPushAction` class represents a Push action that will be configured according to client configuration on the server.

 This action will be created by the SDK and passing through `INSPushDelegate` callback methods to application.
 */
@interface INSPushAction : NSObject

/*!
 Related action type.
 
 @see INSActionType
 */
@property (nonatomic, assign, readonly) INSActionType type;

/*!
 Related action label.
 */
@property (nonatomic, copy, readonly) NSString *label;

/*!
 Related action content.
 */
@property (nonatomic, copy) NSString *content;

/*!
 Related action filters.
 */
@property (nonatomic, copy) NSString *filters;

/*!
 Related action notification if configured, otherwise nil.
 */
@property (nonatomic, strong, readonly) UILocalNotification *notification;

@end
