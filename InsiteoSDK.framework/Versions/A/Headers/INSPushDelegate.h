//
//  INSPushDelegate.h
//  InsiteoSDK
//
//  Created by Lionel Rossignol on 03/03/2016.
//  Copyright © 2016 Insiteo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UILocalNotification, INSPushAction;

/*!
 `INSTriggerSource` enum specifies all different trigger source.
 */
typedef NS_ENUM(NSUInteger, INSTriggerSource) {
    /*!
     Unknown source (Typically when user open notification)
     */
    INSTriggerSourceUnknown = -1,
    /*!
     iBeacon source (Proximity)
     */
    INSTriggerSourceIBeacon = 3,
    /*!
     iBeacon region source (Enter / Exit)
     */
    INSTriggerSourceIBeaconRegion = 5,
};

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
 return `NO` for specific action (by checking the action.type or even the trigger source). If you want to override a
 behavior, you must implement your code here and return `NO`.
 
 If a notification is defined for the action, it will be presented as a `UILocalNotification`.
 
 Here is the default behaviors for each action type:
 
 - `INSActionTypeNotification`: a `UILocalNotification` through `UIApplication presentLocalNotificationNow:` method.
 
 - `INSActionTypeCustom`: no default behavior, you must implement this method in order to execute something.
 
 - `INSActionTypeWebView`: a `UIView` with a `UIWebView` with a close button on the most top of view controller.
 
 @param action        The action that should be executed by the push manager.
 @param triggerSource The source that has triggered the action.
 
 @return `YES` if the push manager could execute the action, otherwise `NO`.
 */
- (BOOL)shouldExecuteAction:(INSPushAction *)action triggeredBy:(INSTriggerSource)triggerSource;

@end
