//
//  INSPush.h
//  InsiteoSDKPush
//
//  Copyright 2015-present Insiteo SAS - All Rights Reserved
//

#import <Foundation/Foundation.h>

#import <InsiteoSDKCore/INSSDKModule.h>
#import "INSTriggerType.h"

@class INSPushAction, UILocalNotification;

/*!
 The `INSPushDelegate` protocol defines optional methods for push delegation to intercept action triggering before their
 execution.
 */
@protocol INSPushDelegate <NSObject>

@optional

/*!
 Sent when an action is triggered. It is called just before the push manager executes the action according to its type
 and content.
 
 If the method is implemented, returning `NO` will disable any default action behavior. You are able to
 return `NO` for specific action (by checking the action.type, the trigger type or source). If you want to override a
 behavior, you must implement your code here and return `NO`.
 
 If a notification is defined for an action, it will be presented as a `UILocalNotification`.
 
 Here are default implemented behaviors :
 
 - `INSActionTypeNotification`: a `UILocalNotification` through `UIApplication presentLocalNotificationNow:` method.
 
 When the `executeActionFromLocalNotification:` method is implemented, this callback will be called with `nil` source 
 and `INSTriggerTypeUnknown` trigger type.
 
 @param action        The action that should be executed by the push manager.
 @param triggerSource The trigger source which has triggered the action (it could be an object of class `INSBeacon`, 
 `INSBeaconRegion` or `INSGeofenceArea` according to the trigger type).
 @param triggerType   The type of the trigger source.
 
 @return `YES` if the push manager could execute the action, otherwise `NO`.
 */
- (BOOL)shouldExecuteAction:(INSPushAction *)action triggeredBy:(id)triggerSource triggerType:(INSTriggerType)triggerType;

@end

/*!
 `INSPush` class is conform to `INSSDKModule` protocol provides an interface to interact with Insiteo Push module.
 */
@interface INSPush : NSObject <INSSDKModule>

///-------------------------------
/// @name Application
///-------------------------------

/*!
 When the application is launched from a `UILocalNotification`, the SDK could try to handle the notification and
 execute appropriate behavior if needed.
 
 @param notification The notification that launched the application.
 */
+ (void)executeActionFromLocalNotification:(UILocalNotification *)notification;

///-------------------------------
/// @name Push Delegate
///-------------------------------

/*!
 Registers to the Push module events.
 
 @param delegate The delegate receiver that is sent messages when the Push module will exectute triggered actions.
 */
+ (void)registerPushDelegate:(id<INSPushDelegate>)delegate;

@end
